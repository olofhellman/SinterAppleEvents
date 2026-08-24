//
//  NSAppleEventDescriptor+SAE.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 7/12/26.
//

import Foundation

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

    static func listOf(ints: [Int]) -> NSAppleEventDescriptor {
        let aeList = NSAppleEventDescriptor.list()
        var count = 0
        for i in ints {
            if let desc = NSAppleEventDescriptor(int: i) {
                aeList.insert(desc, at: count + 1)
                count += 1
            }
        }
        return aeList
    }

    static func listOf(strings: [String]) -> NSAppleEventDescriptor {
        let aeList = NSAppleEventDescriptor.list()
        var count = 0
        for s in strings {
            let desc = NSAppleEventDescriptor(string: s)  
            aeList.insert(desc, at: count + 1)
            count += 1
        }
        return aeList
    }
    
    func setParam(_ keyword: FourCharCode, typeCode: FourCharCode) {
        let typeCodeDescriptor = NSAppleEventDescriptor(typeCode: typeCode)
        self.setParam(typeCodeDescriptor, forKeyword: keyword)
    }
    
    func setParam(_ keyword: FourCharCode, descriptor: NSAppleEventDescriptor) {
        self.setParam(descriptor, forKeyword: keyword)
    }
    
    func every(_ whatClass: FourCharCode) -> SAEObjectSpecifier {
        let allEnum = NSAppleEventDescriptor(enumCode: .all)
        return SAEObjectSpecifier(whatClass, container: self, keyform: .formAbsolutePosition, keydata: allEnum)
    }
    
    func property(_ whatProp: FourCharCode) -> SAEObjectSpecifier {
        let propEnum = NSAppleEventDescriptor(enumCode: whatProp)
        return SAEObjectSpecifier(.classProperty, container: self, keyform: .formPropertyID, keydata: propEnum)
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
