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
    
    func setParam(_ keyword: FourCharCode, objectSpecifier: SAEObjectSpecifier) {
        self.setParam(objectSpecifier.nsAppleEventDescriptor, forKeyword: keyword)
    }
    
    func setParam(_ keyword: FourCharCode, descriptor: NSAppleEventDescriptor) {
        self.setParam(descriptor, forKeyword: keyword)
    }

    func every(_ whatClass: FourCharCode) -> SAEObjectSpecifier {
        let allEnum = NSAppleEventDescriptor(enumCode: .all)
        guard let allAbsoluteOrdinal = NSAppleEventDescriptor(descriptorType: typeAbsoluteOrdinal, data: allEnum.data) else {
            fatalError("Failed to create NSAppleEventDescriptor for absolute ordinal")
        }
        return SAEObjectSpecifier(whatClass, container: self, keyform: .formAbsolutePosition, keydata: allAbsoluteOrdinal)
    }

    func first(_ whatClass: FourCharCode) -> SAEObjectSpecifier {
        let firstEnum = NSAppleEventDescriptor(enumCode: .first)
        guard let firstAbsoluteOrdinal = NSAppleEventDescriptor(descriptorType: typeAbsoluteOrdinal, data: firstEnum.data) else {
            fatalError("Failed to create NSAppleEventDescriptor for absolute ordinal")
        }
        return SAEObjectSpecifier(whatClass, container: self, keyform: .formAbsolutePosition, keydata: firstAbsoluteOrdinal)
    }

    func property(_ whatProp: FourCharCode) -> SAEObjectSpecifier {
        let propEnum = NSAppleEventDescriptor(enumCode: whatProp)
        return SAEObjectSpecifier(.classProperty, container: self, keyform: .formPropertyID, keydata: propEnum)
    }
    
    // AEKeyword in UInt32 even though AEKeyword constants are defined as Int.  Sigh
    func param(forKey keyword: Int) -> NSAppleEventDescriptor? {
        return self.paramDescriptor(forKeyword: (AEKeyword(keyword)))
    }
    
    func set(double: Double, for keyword: FourCharCode) {
        let nsDesc = NSAppleEventDescriptor(double: double)
        return self.setParam(nsDesc, forKeyword: (AEKeyword(keyword)))
    }
    
    func set(float: Float, for keyword: FourCharCode) {
        let nsDesc = NSAppleEventDescriptor(double: Double(float))
        return self.setParam(nsDesc, forKeyword: (AEKeyword(keyword)))
    }
    
    func set(int: Int, for keyword: FourCharCode) {
        guard let nsDesc = NSAppleEventDescriptor(int: int) else {
            print ("error calling NSAppleEventDescriptor(int:)")
            return
        }
        return self.setParam(nsDesc, forKeyword: (AEKeyword(keyword)))
    }

    func int(for keyword: FourCharCode) -> Int? {
        let param = self.paramDescriptor(forKeyword: keyword)
        return param?.intValue
    }
    
    func double(for keyword: FourCharCode) -> Double? {
        let param = self.paramDescriptor(forKeyword: keyword)
        return param?.doubleValue
    }

    func float(for keyword: FourCharCode) -> Float? {
        let param = self.paramDescriptor(forKeyword: keyword)
        guard let d = param?.doubleValue else { return nil }
        return Float(d)
    }

    var floatValue: Float {
        return Float(self.doubleValue)
    }

    func forEach( _ body: (NSAppleEventDescriptor) -> Void) {
        for n in 1...numberOfItems {
            if let nthDesc = self.atIndex(n) {
                body(nthDesc)
            }
        }
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
