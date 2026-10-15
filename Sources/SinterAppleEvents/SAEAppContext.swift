//
//  SAEAppContext.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/24/26.
//

// SAEAppContext defines the "tell" target of an apple event 
// All SAEScriptables should know their AppContext

import Foundation

@MainActor
public protocol SAEAppContext {
    var appTargetDescriptor: NSAppleEventDescriptor { get }
    
    func send(appleEvent: NSAppleEventDescriptor, options: NSAppleEventDescriptor.SendOptions?, timeout: TimeInterval?) async -> NSAppleEventDescriptor
    
    func sendCount(_ whatClass: FourCharCode, container: SAEObjectSpecifier) async -> Int?
    func sendCreateElement(fcc: FourCharCode, container: SAEObjectSpecifier, props: SAERecord?) async -> NSAppleEventDescriptor?
    func sendDelete(directObject: SAEObjectSpecifier) async
    func sendGetData(directObject: SAEObjectSpecifier) async -> NSAppleEventDescriptor
    func sendSetData(directObject: SAEObjectSpecifier, newValue: NSAppleEventDescriptor) async
}

extension SAEAppContext {
    @MainActor
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

    @MainActor
    public func requiredEvent(eventID: AEEventID) -> NSAppleEventDescriptor {
        return self.appleEvent(eventClass: AEEventClass.aevt, eventID: eventID)
    }    

    @MainActor
    public func coreEvent(eventID: AEEventID) -> NSAppleEventDescriptor {
        return self.appleEvent(eventClass: AEEventClass.core, eventID: eventID)
    }    

    @MainActor
    public func miscEvent(eventID: AEEventID) -> NSAppleEventDescriptor {
        return self.appleEvent(eventClass: AEEventClass.misc, eventID: eventID)
    }    
    
    @MainActor
    public func createElementEvent() -> NSAppleEventDescriptor {
       return self.coreEvent(eventID: AEEventID.createElement)
    }
    
    @MainActor
    public func countEvent() -> NSAppleEventDescriptor {
       return self.coreEvent(eventID: AEEventID.count)
    }
    
    @MainActor
    public func deleteEvent() -> NSAppleEventDescriptor {
       return self.coreEvent(eventID: AEEventID.delete)
    }
    
    @MainActor
    public func getDataEvent() -> NSAppleEventDescriptor {
       return self.coreEvent(eventID: AEEventID.getData)
    }
    
    @MainActor
    public func setDataEvent() -> NSAppleEventDescriptor {
       return self.coreEvent(eventID: AEEventID.setData)
    }

    @MainActor
    public func sendCount(_ whatClass: FourCharCode, container: SAEObjectSpecifier) async -> Int? {
        let event = self.countEvent()
        event.setParam(container.nsAppleEventDescriptor, forKeyword: .directObject)
        let whatClassParam = NSAppleEventDescriptor(typeCode: whatClass)
        event.setParam(whatClassParam, forKeyword: .objectClass)
  
        let result = await self.send(appleEvent: event, options: nil, timeout: nil)
        return result.descriptorType == typeNull ? nil :  Int(result.int32Value)
    }
     
    // crel is the create element apple event
    // in most cases, client code that wants to send a crel event should use a 
    // make() command and specify the class of the object to be created, 
    // so that the return value is of the expected type

    @MainActor
    public func sendCreateElement(fcc: FourCharCode, container: SAEObjectSpecifier, props: SAERecord? = nil) async -> NSAppleEventDescriptor? {
        let event = self.createElementEvent()
        let insertLoc = SAEInsertionLocation(objectSpecifier: container, pos: kAEEnd)
        event.setParam(.objectClass, typeCode: fcc)
        event.setParam(.insertHere, descriptor: insertLoc.asNSAppleEventDescriptor())
        if let props {
            event.setParam(.propData, descriptor: props.record)
        }
        
        return await self.send(appleEvent: event, options: nil, timeout: nil)
    }
      
    @MainActor
    public func sendDelete(directObject: SAEObjectSpecifier) async {
        let event = self.deleteEvent()
        event.setParam(.directObject, objectSpecifier: directObject)
        
        _ = await self.send(appleEvent: event, options: nil, timeout: nil)
    }
    
    @MainActor
    public func sendGetData(directObject: SAEObjectSpecifier) async -> NSAppleEventDescriptor {
        let event = self.getDataEvent()
        event.setParam(.directObject, objectSpecifier: directObject)
        
        return await self.send(appleEvent: event, options: nil, timeout: nil)
    }
    
    @MainActor
    public func sendSetData(directObject: SAEObjectSpecifier, newValue: NSAppleEventDescriptor) async {
        let event = self.setDataEvent()
        event.setParam(.directObject, objectSpecifier: directObject)
        event.setParam(.data, descriptor: newValue)
        _ = await self.send(appleEvent: event, options: nil, timeout: nil)
    }
    
}
 
