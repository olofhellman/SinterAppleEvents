//
//  SAEAppContext.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/24/26.
//

// SAEAppContext defines the "tell" target of an apple event 
// All SAEScriptables should know their AppContext

import Foundation

public protocol SAEAppContext {
    var appTargetDescriptor: NSAppleEventDescriptor { get }
    func sendDelete(directObject: NSAppleEventDescriptor)   
    func sendGetData(directObject: NSAppleEventDescriptor) -> NSAppleEventDescriptor
    func sendSetData(directObject: NSAppleEventDescriptor, newValue: NSAppleEventDescriptor) 
}

extension SAEAppContext {
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
    
    public func createElementEvent() -> NSAppleEventDescriptor {
       return self.coreEvent(eventID: AEEventID.createElement)
    }
    
    public func countEvent() -> NSAppleEventDescriptor {
       return self.coreEvent(eventID: AEEventID.count)
    }
    
    public func deleteEvent() -> NSAppleEventDescriptor {
       return self.coreEvent(eventID: AEEventID.delete)
    }
    
    public func getDataEvent() -> NSAppleEventDescriptor {
       return self.coreEvent(eventID: AEEventID.getData)
    }
    
    public func setDataEvent() -> NSAppleEventDescriptor {
       return self.coreEvent(eventID: AEEventID.setData)
    }

    public func sendCount(_ whatClass: FourCharCode, container: NSAppleEventDescriptor) -> Int? {
        let event = self.countEvent()
        event.setParam(container, forKeyword: .directObject)
        let whatClassParam = NSAppleEventDescriptor(typeCode: whatClass)
        event.setParam(whatClassParam, forKeyword: .objectClass)
  
        let result = self.send(appleEvent: event) 
        return result.descriptorType == typeNull ? nil :  Int(result.int32Value)
    }
     
    // crel is the create element apple event
    // in most cases, client code that wants to send a crel event should use a 
    // make() command and specify the class of the object to be created, 
    // so that the return value is of the expected type
    public func sendCreateElement(fcc: FourCharCode, container: NSAppleEventDescriptor, props: SAERecord? = nil) -> NSAppleEventDescriptor? {
        let event = self.createElementEvent()
        let insertLoc = SAEInsertionLocation(obj: container, pos: kAEEnd)
        event.setParam(.objectClass, typeCode: fcc)
        event.setParam(.insertHere, descriptor: insertLoc.asNSAppleEventDescriptor())
        if let props {
            event.setParam(.propData, descriptor: props.record)
        }
        
        return self.send(appleEvent: event)
    }
      
    public func sendDelete(directObject: NSAppleEventDescriptor) {
        let event = self.deleteEvent()
        event.setParam(.directObject, descriptor: directObject)
        
        _ = self.send(appleEvent: event)
    }
    
    public func sendGetData(directObject: NSAppleEventDescriptor) -> NSAppleEventDescriptor {
        let event = self.getDataEvent()
        event.setParam(.directObject, descriptor: directObject)
        
        return self.send(appleEvent: event)
    }
    
    public func sendSetData(directObject: NSAppleEventDescriptor, newValue: NSAppleEventDescriptor) {
        let event = self.setDataEvent()
        event.setParam(.directObject, descriptor: directObject)
        event.setParam(.data, descriptor: newValue)
        _ = self.send(appleEvent: event)
    }
    
    public func send(appleEvent: NSAppleEventDescriptor, options: NSAppleEventDescriptor.SendOptions = .waitForReply, timeout: Int = 60) -> NSAppleEventDescriptor {
        let result =  try? appleEvent.sendEvent(options: .waitForReply, timeout: 60)
        return result?.paramDescriptor(forKeyword: .result) ?? NSAppleEventDescriptor.null()
    }
}
 
