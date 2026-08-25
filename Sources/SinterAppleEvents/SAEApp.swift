//
//  SAEApp.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/10/26.
//

import Foundation

// AppKit is needed for NSRunningApplication
import AppKit

open class SAEApp : SAEObject, SAEContainer, SAEAppContext {
    
    let appObjectSpecifier: AppObjectSpecifier
    public let appTargetDescriptor: NSAppleEventDescriptor

    public init?(identifier: String) {
        self.appTargetDescriptor = NSAppleEventDescriptor(bundleIdentifier: identifier)
        let appOS = AppObjectSpecifier(appIdentifier: identifier)
        self.appObjectSpecifier = appOS
        super.init(appContext: nil, objSpec: appOS.asTypeObjectSpecifierDescriptor())
    }

    // targets a running process directly by pid, useful for apps which are not
    // registered with Launch Services under a bundle identifier (e.g. test helper tools)
    public init(processIdentifier pid: pid_t) {
        self.appTargetDescriptor = NSAppleEventDescriptor(processIdentifier: pid)
        let appOS = AppObjectSpecifier(appIdentifier: "")
        self.appObjectSpecifier = appOS
        super.init(appContext: nil, objSpec: appOS.asTypeObjectSpecifierDescriptor())
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
   
    override public func elements(ofClass classFcc: FourCharCode) -> [NSAppleEventDescriptor] {
        let event = getDataEvent()
        
        let directObjectSpecifier = appObjectSpecifier.every(classFcc)
        event.setParam(directObjectSpecifier.asTypeObjectSpecifierDescriptor(), forKeyword: .directObject)
        
        guard let reply = try? event.sendEvent(options: [], timeout: 10) else {
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
        return []
    }

       
    public func documents() -> [SAEDocument] {
        let docs = elements(ofClass: SAEDocument.fcc)
        return docs.map { SAEDocument(appContext: self, objSpec: $0) }
    }
        
    public func document(atASIndex asIndex: Int) -> SAEDocument? {
        guard let doc = element(ofClass: FourCharCode.classDocument, atASIndex: asIndex) else {
            return nil
        }
        return SAEDocument(appContext: self, objSpec: doc)
    }

    
    public override var containerForCrelEvent: NSAppleEventDescriptor {
        return NSAppleEventDescriptor.null()
    }
    
    public func make<T: SAEMakeable>(new type: T.Type, props: SAERecord? = nil) -> T? {
       guard let nsAppleEventDescriptor = sendCreateElement(fcc: type.fcc, container: containerForCrelEvent, props: props) else {
           return nil
       }
       return T(appContext: self, objSpec: nsAppleEventDescriptor)
    }
    
    public func crel<T: SAEMakeable>(type: T.Type, container: NSAppleEventDescriptor, props: SAERecord? = nil) -> T? {
       guard let nsAppleEventDescriptor = sendCreateElement(fcc: type.fcc, container: container, props: props) else {
           return nil
       }
       return T(appContext: self, objSpec: nsAppleEventDescriptor)
    }
    
    override public func objectSpecifier(for containedObject: SAEContainedObjectSpecifier) -> NSAppleEventDescriptor {
        return containedObject.asTypeObjectSpecifierDescriptor(container: appObjectSpecifier.asTypeObjectSpecifierDescriptor())
    }
 
    
// 
}
