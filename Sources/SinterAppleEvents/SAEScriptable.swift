//
//  SAEScriptable.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/10/26.
//


import Foundation

open class SAEScriptable {

    var appContext: SAEApp?
    public var app: SAEApp {
        guard let appContext else {
            fatalError("No app context")
        }
        return appContext
    }
    
    public let objSpec: NSAppleEventDescriptor
    
    public init(app: SAEApp?, objSpec: NSAppleEventDescriptor) {
        self.appContext = app
        self.objSpec = objSpec
    }
    
    public func getData() -> NSAppleEventDescriptor {
        return app.getData(directObject: self.objSpec)  
    }
    
    public func setData(newValue: NSAppleEventDescriptor) {
        return app.setData(directObject: self.objSpec, newValue: newValue)  
    }

}
