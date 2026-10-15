//
//  SAEObjectSpecifier.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 7/12/26.
//

import Foundation

// An SAEObjectSpecifier is not a reference, because it does not have an associated app context.
// 
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
    
    public init?(nsAppleEventDescriptor: NSAppleEventDescriptor) {
        guard let nsRecord = nsAppleEventDescriptor.coerce(toDescriptorType: typeAERecord) else {
            return nil
        }

        self.classWanted = nsRecord.param(forKey: keyAEDesiredClass)?.typeCodeValue ?? typeNull
        self.container = nsRecord.param(forKey: keyAEContainer) ?? NSAppleEventDescriptor.null()
        self.keyform = nsRecord.param(forKey: keyAEKeyForm)?.enumCodeValue ?? 0
        self.keydata = nsRecord.param(forKey: keyAEKeyData) ?? NSAppleEventDescriptor.null()
    }
 
    
    public func every(_ whatClass: FourCharCode) -> SAEObjectSpecifier {
        return self.asTypeObjectSpecifierDescriptor().every(whatClass);
    }
    
    public func property(_ whatProperty: FourCharCode) -> SAEObjectSpecifier {
        return self.asTypeObjectSpecifierDescriptor().property(whatProperty);
    }

    public var nsAppleEventDescriptor: NSAppleEventDescriptor {
        return self.asTypeObjectSpecifierDescriptor()
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
