//
//  SAEObjectProperty.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 7/13/26.
//

import Foundation 

public class SAEObjectProperty: SAEScriptable {
    let spObject: SAEObject
    let propCode: FourCharCode
    
    init(spObject: SAEObject, propCode: FourCharCode) {
        self.spObject = spObject
        self.propCode = propCode
        let propSpec = spObject.objSpec.property(propCode)
        super.init(app: spObject.app, objSpec: propSpec.asNSAppleEventDescriptor())
    }
}
    
 
