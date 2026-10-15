//
//  SAEContentSpecification.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/23/26.
//

import Foundation

public struct SAEContentSpecification {
    let keyform: FourCharCode
    let keydata: NSAppleEventDescriptor
    let fcc: FourCharCode

    var objectSpecifier: SAEObjectSpecifier {
        let container = NSAppleEventDescriptor(enumCode: typeObjectBeingExamined)
        return SAEObjectSpecifier(fcc, container: container, keyform: keyform, keydata: keydata)
    }
    
    init(fcc: FourCharCode, formAndData: SAEKeyFormAndData) {
        self.keyform = formAndData.keyform
        self.keydata = formAndData.keydata
        self.fcc = fcc
    }
    
    init(fcc: FourCharCode, specificPosition: SAESpecificPosition) {
        self.keyform = specificPosition.keyform
        self.keydata = specificPosition.keydata
        self.fcc = fcc
    }

    /*
    public func asTypeObjectSpecifierDescriptor(container: NSAppleEventDescriptor) -> NSAppleEventDescriptor {
        let saeObjSpec = SAEObjectSpecifier(self.classWanted, container: container, keyform: self.keyform, keydata: self.keydata)
        return saeObjSpec.asTypeObjectSpecifierDescriptor()
    }
     */
}
