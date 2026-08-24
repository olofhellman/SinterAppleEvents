//
//  SAEScriptable.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/10/26.
//


import Foundation

open class SAEScriptable {

    private var saeAppContext: SAEAppContext?
    
    public var appContext: SAEAppContext {
        guard let saeAppContext else {
            fatalError("No app context")
        }
        return saeAppContext
    }
    
    public let objSpec: NSAppleEventDescriptor
    
    public init(appContext: SAEAppContext?, objSpec: NSAppleEventDescriptor) {
        self.saeAppContext = appContext
        self.objSpec = objSpec
    }
    
    public func getData() -> NSAppleEventDescriptor {
        return appContext.sendGetData(directObject: self.objSpec)  
    }
    
    public func setData(newValue: NSAppleEventDescriptor) {
        return appContext.sendSetData(directObject: self.objSpec, newValue: newValue)  
    }

}
