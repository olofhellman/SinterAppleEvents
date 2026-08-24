//
//  SAEContainedObjectSpecifier.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/23/26.
//

import Foundation

public class SAEContainedObjectSpecifier: SAEObjectSpecifier {
    init(fcc: FourCharCode, formAndData: SAEKeyFormAndData) {
        let keyform = formAndData.keyform
        let keydata = formAndData.keydata
        let container = NSAppleEventDescriptor(enumCode: typeObjectBeingExamined)
        super.init(fcc, container: container, keyform: keyform, keydata: keydata)
    }
    
    init(fcc: FourCharCode, specificPosition: SAESpecificPosition) {
        let keyform = specificPosition.keyform
        let keydata = specificPosition.keydata
        let container = NSAppleEventDescriptor(enumCode: typeObjectBeingExamined)
        super.init(fcc, container: container, keyform: keyform, keydata: keydata)
    }
    
    public func asTypeObjectSpecifierDescriptor(container: NSAppleEventDescriptor) -> NSAppleEventDescriptor {
        let saeObjSpec = SAEObjectSpecifier(self.classWanted, container: container, keyform: self.keyform, keydata: self.keydata)
        return saeObjSpec.asTypeObjectSpecifierDescriptor()
    }

}
