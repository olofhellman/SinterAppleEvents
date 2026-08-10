//
//  NSAppleEventDescriptor+SPB.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 7/12/26.
//

import Foundation

public extension FourCharCode {
    static var classProperty: FourCharCode { return FourCharCode(string: "prop")  }
    static var formPropertyID: FourCharCode { return FourCharCode(string: "prop")  }
}

public extension NSAppleEventDescriptor {
    
    func every(_ whatClass: FourCharCode) -> ObjectSpecifier {
        return ObjectSpecifier(whatClass, container: self, keyform: FourCharCode.formAbsolutePosition, keydata:  NSAppleEventDescriptor(enumCode: FourCharCode.all))
    }
    
    func property(_ whatProp: FourCharCode) -> ObjectSpecifier {
        return ObjectSpecifier(.classProperty, container: self, keyform: .formPropertyID, keydata:  NSAppleEventDescriptor(enumCode: whatProp))
    }
}
