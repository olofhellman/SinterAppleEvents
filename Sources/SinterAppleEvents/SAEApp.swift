//
//  SAEApp.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/10/26.
//

import Foundation
import AppKit

@MainActor
open class SAEApp : SAEObject, SAEContainer, SAEAppContext {
    
    let appObjectSpecifier: AppObjectSpecifier
    public let appTargetDescriptor: NSAppleEventDescriptor
    
    public init?(identifier: String) {
        if let pid = NSRunningApplication.runningApplications(withBundleIdentifier: identifier).first?.processIdentifier
        {
            self.appTargetDescriptor  = NSAppleEventDescriptor(processIdentifier: pid)
        } else {
            self.appTargetDescriptor = NSAppleEventDescriptor(bundleIdentifier: identifier)
        }
        let appOS = AppObjectSpecifier(appIdentifier: identifier)
        self.appObjectSpecifier = appOS
    
        super.init(appContext: nil, objectSpecifier: appOS)
    }

    // targets a running process directly by pid, useful for apps which are not
    // registered with Launch Services under a bundle identifier (e.g. test helper tools)
    public init(processIdentifier pid: pid_t) {
        self.appTargetDescriptor = NSAppleEventDescriptor(processIdentifier: pid)
        let appOS = AppObjectSpecifier(appIdentifier: "")
        self.appObjectSpecifier = appOS
        super.init(appContext: nil, objectSpecifier: appOS)
    }
    
    required public init(appContext: SAEAppContext?, objectSpecifier: SAEObjectSpecifier) {
        fatalError("SAEApp should not be initialized with an arbitrary object specifier")
    }

    // SAEObject instances which are not SAEApp have a non-nil appContext
    // and just return that for the app.  SAEApp objects are their own context
    override public var appContext: SAEAppContext {
        return self
    }

    // activate() returns success
    public func activate() -> Bool {
        // make sure it is running.  If not, send an open app event
        // then send a misc/activate event
        let runningApplications = NSRunningApplication.runningApplications(withBundleIdentifier: appObjectSpecifier.appBundleIdentifier)
        if (runningApplications.count == 0) {
            let bundleID = appObjectSpecifier.appBundleIdentifier
            guard let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID) else { return false }
            let configuration = NSWorkspace.OpenConfiguration()
            NSWorkspace.shared.openApplication(at: appURL, configuration: configuration, completionHandler: nil)
        }
        
        // send activate
        let activateEvent = self.miscEvent(eventID: .activate)
        let _ = try? activateEvent.sendEvent(options: [], timeout: 10)
        return true
    }
   
    override public func elements(ofClass classFcc: FourCharCode) async -> [NSAppleEventDescriptor] {
        let event = getDataEvent()
        
        let directObjectSpecifier = appObjectSpecifier.every(classFcc)
        event.setParam(directObjectSpecifier.asTypeObjectSpecifierDescriptor(), forKeyword: .directObject)
        
        guard let reply = try? event.sendEvent(options: NSAppleEventDescriptor.SendOptions.defaultOptions, timeout: 10) else {
            return []
        }
        guard let result = reply.paramDescriptor(forKeyword: .result) else {
            return []
        }
        
        if result.descriptorType == typeAEList {
            var listOfAEDesc: [NSAppleEventDescriptor] = []
            let ct = result.numberOfItems
            guard ct > 0 else { return listOfAEDesc }
            for i in 1...ct {
                if let nthItem = result.atIndex(i) {
                    listOfAEDesc.append(nthItem)
                }
            }
            return listOfAEDesc
        }
        else if result.descriptorType == typeObjectSpecifier {
            return [result]
        }
        return []
    }

    // app class should override this to return the appropriate SAEDocument subclass for each document
    // descriptor should be a typeObjectSpecifier NSAppleEventDescriptor
    open func documentInit(objectSpecifier: SAEObjectSpecifier) -> SAEDocument? {
        return SAEDocument(appContext: self, objectSpecifier: objectSpecifier)
    }

    // app class should probably not override this
    open func documentInit(descriptor: NSAppleEventDescriptor) -> SAEDocument? {
        guard let objectSpecifier = SAEObjectSpecifier(nsAppleEventDescriptor: descriptor) else {
            print("failed to get an object specifier")
            return nil
        }
        return documentInit(objectSpecifier: objectSpecifier)
    }

    public func documents() async -> [SAEDocument] {
        let docs = await elements(ofClass: SAEDocument.fcc)
        return docs.compactMap { documentInit (descriptor: $0) }
    }
        
    public func document(atASIndex asIndex: Int) async -> SAEDocument? {
        guard let doc = await element(ofClass: FourCharCode.classDocument, atASIndex: asIndex) else {
            return nil
        }
        return documentInit(descriptor: doc)
    }

    public override var contentsContainerDescriptor: NSAppleEventDescriptor {
        return NSAppleEventDescriptor.null()
    }
    
    public override var contentsContainerSpecifier: SAEObjectSpecifier {
        return appObjectSpecifier
    }

    public func make<T: SAEMakeable>(new type: T.Type, props: SAERecord? = nil) async -> T? {
       guard let nsAppleEventDescriptor = await sendCreateElement(fcc: type.fcc, container: contentsContainerSpecifier, props: props) else {
           return nil
       }
       guard let objectSpecifier = SAEObjectSpecifier( nsAppleEventDescriptor: nsAppleEventDescriptor) else {
           print("make<T: SAEMakeable> failed promoting NSAppleEventDescriptor to SAEObjectSpecifier")
           return nil
       }
       return T(appContext: self, objectSpecifier: objectSpecifier)
    }
    
    public func crel<T: SAEMakeable>(type: T.Type, container: SAEObjectSpecifier, props: SAERecord? = nil) async -> T? {
        guard let nsAppleEventDescriptor = await sendCreateElement(fcc: type.fcc, container: container, props: props) else {
            return nil
        }
        guard let objectSpecifier = SAEObjectSpecifier( nsAppleEventDescriptor: nsAppleEventDescriptor) else {
            print("crel<T: SAEMakeable> failed promoting NSAppleEventDescriptor to SAEObjectSpecifier")
            return nil
        }
        return T(appContext: self, objectSpecifier: objectSpecifier)
    }
    
    public func objectSpecifier(for contents: SAEContentSpecification) -> SAEObjectSpecifier {
        return SAEObjectSpecifier(contents.fcc, container: contentsContainerDescriptor, keyform: contents.keyform, keydata: contents.keydata)
    }
 
    open func send(appleEvent: NSAppleEventDescriptor, options: NSAppleEventDescriptor.SendOptions? = nil, timeout: TimeInterval? = nil) async -> NSAppleEventDescriptor {
        let result = try? appleEvent.sendEvent(options: options ?? .waitForReply, timeout: timeout ?? 60)
        return result?.paramDescriptor(forKeyword: .result) ?? NSAppleEventDescriptor.null()
    }
}
