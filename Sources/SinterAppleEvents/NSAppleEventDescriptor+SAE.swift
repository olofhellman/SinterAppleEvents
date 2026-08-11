//
//  NSAppleEventDescriptor+SAE.swift
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

    convenience init?(int: Int) {
        if int <= Int32.max && int >= Int32.min {
            let int32 = Int32(int)
            self.init(int32: int32)
        } else {
            var localInt = int
            let localData = Data(bytes: &localInt, count: MemoryLayout<Int>.size)  
            self.init(descriptorType: typeSInt64, data: localData)
        }
    }
    
    func setParam(_ keyword: FourCharCode, typeCode: FourCharCode) {
        let typeCodeDescriptor = NSAppleEventDescriptor(typeCode: typeCode)
        self.setParam(typeCodeDescriptor, forKeyword: keyword)
    }
    
    func setParam(_ keyword: FourCharCode, descriptor: NSAppleEventDescriptor) {
        self.setParam(descriptor, forKeyword: keyword)
    }
    
    func every(_ whatClass: FourCharCode) -> ObjectSpecifier {
        let allEnum = NSAppleEventDescriptor(enumCode: .all)
        return ObjectSpecifier(whatClass, container: self, keyform: .formAbsolutePosition, keydata: allEnum)
    }
    
    func property(_ whatProp: FourCharCode) -> ObjectSpecifier {
        let propEnum = NSAppleEventDescriptor(enumCode: whatProp)
        return ObjectSpecifier(.classProperty, container: self, keyform: .formPropertyID, keydata: propEnum)
    }
    
    var intValue: Int? {
        switch descriptorType {
        case typeSInt64:
            guard data.count == MemoryLayout<Int64>.size else { return nil }
            let value = data.withUnsafeBytes { rawBufferPointer in
                rawBufferPointer.bindMemory(to: Int64.self)[0]
            }
            return Int(exactly: value)
            
        case typeUInt64:
            guard data.count == MemoryLayout<UInt64>.size else { return nil }
            let value = data.withUnsafeBytes { rawBufferPointer in
                rawBufferPointer.bindMemory(to: UInt64.self)[0]
            }
            return Int(exactly: value)
            
        default:
            return Int(int32Value)
        }
    }
}
