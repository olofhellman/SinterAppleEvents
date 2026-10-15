//
//  SAEReference.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/10/26.
//


import Foundation

// SAEReference if the basic 'scriptable object' for SinterAppleEvents
// reference is the AppleScript term corresponding to a typeObjectSpecifier AppleEventDescriptor
// SAEReference encapsulates an object specifier and an application context
// calling reference.getData() effectively sends the AppleEvent corresponding to
//
//  tell application <app context>
//      get <object specifier>
//  end tell
//
// and returns the result
@MainActor
open class SAEReference {

    // saeAppContext is an optional because an SAEApp is its own context, and initialization is easier this way
    private var saeAppContext: SAEAppContext?
    public let saeObjectSpecifier: SAEObjectSpecifier

    public var objectSpecifier: SAEObjectSpecifier {
        return saeObjectSpecifier
    }
    
    public var contentsContainerDescriptor: NSAppleEventDescriptor  {
        return saeObjectSpecifier.nsAppleEventDescriptor
    }

    public var appContext: SAEAppContext {
        guard let saeAppContext else {
            // SAEApp should override this
            fatalError("No app context")
        }
        return saeAppContext
    }
     
    public init(appContext: SAEAppContext?, objectSpecifier: SAEObjectSpecifier) {
        self.saeAppContext = appContext
        self.saeObjectSpecifier = objectSpecifier
    }
    
    public func getData() async -> NSAppleEventDescriptor {
        return await appContext.sendGetData(directObject: self.saeObjectSpecifier)
    }
    
    public func setData(newValue: NSAppleEventDescriptor) async {
        return await appContext.sendSetData(directObject: self.saeObjectSpecifier, newValue: newValue)
    }

}
