//
//  SAEInsertionLocation.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 7/13/26.
//

import Foundation


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
