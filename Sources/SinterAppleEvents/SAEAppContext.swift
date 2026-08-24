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

}
 
