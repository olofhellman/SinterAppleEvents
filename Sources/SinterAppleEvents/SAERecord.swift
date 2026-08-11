//
//  SAERecord.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/10/26.
//

import Foundation

open class SAERecord {
    var record: NSAppleEventDescriptor
    public init() {
        self.record = NSAppleEventDescriptor.record()
    }
    
    public func setKey(_ keyword: FourCharCode, int: Int) {
        guard let param = NSAppleEventDescriptor(int: int) else { return }
        record.setParam(param, forKeyword: keyword)
    }
    
    public func setKey(_ keyword: FourCharCode, double: Double) {
        let param = NSAppleEventDescriptor(double: double) 
        record.setParam(param, forKeyword: keyword)
    }
    
    public func getKey(_ keyword: FourCharCode) -> NSAppleEventDescriptor? {
        return record.paramDescriptor(forKeyword: keyword)
    }
    
    public func getIntKey(_ keyword: FourCharCode) -> Int? {
        guard let param = getKey(keyword) else { return nil }
        return param.intValue 
    }
    
    public func getDoubleKey(_ keyword: FourCharCode) -> Double? {
        guard let param = getKey(keyword) else { return nil }
        return param.doubleValue 
    }
}
