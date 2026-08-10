//
//  SPInsertionLocation.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 7/13/26.
//

import Foundation

public extension FourCharCode {
    static var keyAEObject: FourCharCode { return FourCharCode(string: "kobj")  }
    static var keyAEPosition: FourCharCode { return FourCharCode(string: "kpos")  }
}
///      keyAEObject a typeObjectSpecifier
///      keyAEPosition a DescType
 
public struct SAEInsertionLocation {
    let obj: NSAppleEventDescriptor
    let pos: FourCharCode
 
    init(obj: NSAppleEventDescriptor, pos: FourCharCode = FourCharCode.keyAEPosition) {
        self.obj = obj
        self.pos = pos
    }
    
    public func asNSAppleEventDescriptor() -> NSAppleEventDescriptor {
        let record = NSAppleEventDescriptor.record()
        record.setParam(obj, forKeyword: FourCharCode.keyAEObject)
        record.setParam(NSAppleEventDescriptor(enumCode: pos), forKeyword: FourCharCode.keyAEPosition)
        return record
    }
}
