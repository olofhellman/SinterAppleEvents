//
//  SAEObjectProperty.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 7/13/26.
//

import AppKit
import Foundation

public extension FourCharCode {
    static var property: FourCharCode { return FourCharCode(string: "prop")  }
}

@MainActor
public class SAEObjectProperty: SAEReference {
    let saeObject: SAEObject
    let propCode: FourCharCode
    
    init(saeObject: SAEObject, propCode: FourCharCode) {
        self.saeObject = saeObject
        self.propCode = propCode
        let keydata = NSAppleEventDescriptor(typeCode: propCode)
        let propObjSpec = SAEObjectSpecifier(.property, container: saeObject.contentsContainerDescriptor, keyform: .formPropertyID, keydata: keydata)
        super.init(appContext: saeObject.appContext, objectSpecifier: propObjSpec)
    }
}
    
 
