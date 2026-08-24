//
//  SAEObjectSpecifier.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 7/12/26.
//

import Foundation

public class SAEObjectSpecifier {

    let container: NSAppleEventDescriptor
    let classWanted: FourCharCode
    let keyform: FourCharCode
    let keydata: NSAppleEventDescriptor
 
    public init(_ classWanted: FourCharCode, container: NSAppleEventDescriptor?, keyform: FourCharCode, keydata: NSAppleEventDescriptor) {
        self.container = container ?? NSAppleEventDescriptor.null()
        self.classWanted = classWanted
        self.keyform = keyform
        self.keydata = keydata
    }
    
    public func every(_ whatClass: FourCharCode) -> SAEObjectSpecifier {
        return self.asTypeObjectSpecifierDescriptor().every(whatClass);
    }
 
    public func asTypeObjectSpecifierDescriptor() -> NSAppleEventDescriptor {
        let recordDescriptor = NSAppleEventDescriptor.record()
 
        recordDescriptor.setParam(container, forKeyword: .container)
        recordDescriptor.setParam(NSAppleEventDescriptor(enumCode: keyform), forKeyword: .keyform)
        recordDescriptor.setParam(NSAppleEventDescriptor(typeCode: classWanted), forKeyword: .desiredClass)
        recordDescriptor.setParam(keydata, forKeyword: .keydata)
        let objSpec = recordDescriptor.coerce(toDescriptorType: typeObjectSpecifier)
        return  objSpec ?? NSAppleEventDescriptor.null()
    }
 

    
}
