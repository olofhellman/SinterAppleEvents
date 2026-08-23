//
//  SAEApp.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/10/26.
//

import Foundation

// AppKit is needed for NSRunningApplication
import AppKit

open class SAEApp : SAEObject, SAEContainer {
    
    let appObjectSpecifier: AppObjectSpecifier
    let appTargetDescriptor: NSAppleEventDescriptor

    public init?(identifier: String) {
        self.appTargetDescriptor = NSAppleEventDescriptor(bundleIdentifier: identifier)
        let appOS = AppObjectSpecifier(appIdentifier: identifier)
        self.appObjectSpecifier = appOS
        super.init(app: nil, objSpec: appOS.asNSAppleEventDescriptor())
    }
    
    // SAEObject instances which are not SAEApp have a non-nil appContext
    // and just return that for the app.  SAEApp objects are their own context
    override public var app: SAEApp {
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

    public func appleEvent(eventClass: AEEventClass, eventID: AEEventID) -> NSAppleEventDescriptor {
        let event = NSAppleEventDescriptor(
            eventClass: eventClass,
            eventID: eventID,
            targetDescriptor: appTargetDescriptor,
            returnID: AEReturnID(kAutoGenerateReturnID),
            transactionID: AETransactionID(kAnyTransactionID)
        )
        return event
    }    

    public func requiredEvent(eventID: AEEventID) -> NSAppleEventDescriptor {
        return self.appleEvent(eventClass: AEEventClass.aevt, eventID: eventID)
    }    

    public func coreEvent(eventID: AEEventID) -> NSAppleEventDescriptor {
        return self.appleEvent(eventClass: AEEventClass.core, eventID: eventID)
    }    

    public func miscEvent(eventID: AEEventID) -> NSAppleEventDescriptor {
        return self.appleEvent(eventClass: AEEventClass.misc, eventID: eventID)
    }    
    
    override public func elements(ofClass classFcc: FourCharCode) -> [NSAppleEventDescriptor] {
        let event = getDataEvent()
        
        let directObjectSpecifier = appObjectSpecifier.every(classFcc)
        event.setParam(directObjectSpecifier.asNSAppleEventDescriptor(), forKeyword: .directObject)
        
        guard let reply = try? event.sendEvent(options: [], timeout: 10) else {
            return []
        }
        guard let result = reply.paramDescriptor(forKeyword: .result) else {
            return []
        }
        
        if result.descriptorType == typeAEList {
            var listOfAEDesc: [NSAppleEventDescriptor] = []
            let ct = result.numberOfItems
            for i in 1...ct {
                if let nthItem = result.atIndex(i) {
                    listOfAEDesc.append(nthItem)
                }
            }
            return listOfAEDesc
        }
        return []
    }

    public func createElementEvent() -> NSAppleEventDescriptor {
       return self.coreEvent(eventID: AEEventID.createElement)
    }
    public func countEvent() -> NSAppleEventDescriptor {
       return self.coreEvent(eventID: AEEventID.count)
    }
    public func getDataEvent() -> NSAppleEventDescriptor {
       return self.coreEvent(eventID: AEEventID.getData)
    }
    public func setDataEvent() -> NSAppleEventDescriptor {
       return self.coreEvent(eventID: AEEventID.setData)
    }
        
    public func documents() -> [SAEDocument] {
        let docs = elements(ofClass: SAEDocument.fcc)
        return docs.map { SAEDocument(app: self, objSpec: $0) }
    }
        
    public func document(atASIndex asIndex: Int) -> SAEDocument? {
        guard let doc = element(ofClass: FourCharCode.classDocument, atASIndex: asIndex) else {
            return nil
        }
        return SAEDocument(app: self, objSpec: doc)
    }

    public func count(_ whatClass: FourCharCode, container: NSAppleEventDescriptor) ->Int? {
        let event = self.countEvent()
        event.setParam(container, forKeyword: .directObject)
        let whatClassParam = NSAppleEventDescriptor(typeCode: whatClass)
        event.setParam(whatClassParam, forKeyword: .objectClass)
  
        let result = try? event.sendEvent(options: .waitForReply, timeout: 60)
        guard let countResult = result?.paramDescriptor(forKeyword: .result) else {
            return nil
        }
        return Int(countResult.int32Value)
    }
    
    public override var containerForCrelEvent: NSAppleEventDescriptor {
        return NSAppleEventDescriptor.null()
    }
    
    public func make<T: SAEMakeable>(new type: T.Type, props: SAERecord? = nil) -> T? {
       guard let nsAppleEventDescriptor = crel(fcc: type.fcc, container: containerForCrelEvent, props: props) else {
           return nil
       }
       return T(app: self, objSpec: nsAppleEventDescriptor)
    }
    
    public func crel<T: SAEMakeable>(type: T.Type, container: NSAppleEventDescriptor, props: SAERecord? = nil) -> T? {
       guard let nsAppleEventDescriptor = crel(fcc: type.fcc, container: container, props: props) else {
           return nil
       }
       return T(app: self, objSpec: nsAppleEventDescriptor)
    }
    
    // crel is the create element apple event
    // in most cases, client code that wants to send a crel event should use a 
    // make() command and specify the class of the object to be created, 
    // so that the return value is of the expected type
    public func crel(fcc: FourCharCode, container: NSAppleEventDescriptor, props: SAERecord? = nil) -> NSAppleEventDescriptor? {
        let event = self.createElementEvent()
        let insertLoc = SAEInsertionLocation(obj: container, pos: kAEEnd)
        event.setParam(.objectClass, typeCode: fcc)
        event.setParam(.insertHere, descriptor: insertLoc.asNSAppleEventDescriptor())
        if let props {
            event.setParam(.propData, descriptor: props.record)
        }
        
        let result = try? event.sendEvent(options: .waitForReply, timeout: 60)
        return result?.paramDescriptor(forKeyword: .result)
    }
    
    public func getData(directObject: NSAppleEventDescriptor) -> NSAppleEventDescriptor {
        let event = self.getDataEvent()
        event.setParam(.directObject, descriptor: directObject)
        
        let result = try? event.sendEvent(options: .waitForReply, timeout: 60)
        return result?.paramDescriptor(forKeyword: .result) ?? NSAppleEventDescriptor.null()
    }
    
    public func setData(directObject: NSAppleEventDescriptor, newValue: NSAppleEventDescriptor) {
        let event = self.setDataEvent()
        event.setParam(.directObject, descriptor: directObject)
        event.setParam(.data, descriptor: newValue)
        _ = try? event.sendEvent(options: .waitForReply, timeout: 60)
    }
}
