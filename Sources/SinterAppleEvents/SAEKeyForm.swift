//
//  SAEKeyForm.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/23/26.
//

import Foundation

public enum SAEKeyFormAndData {
    case atIndex(Int)
    case atIndices([Int])
    case named(String)
    case withNames([String])
    case withIntID(Int)
    case withIntIDs([Int])
    
    public var keyform: FourCharCode {
        switch(self) {
            case .atIndex(_):
                return .formAbsolutePosition
            case .atIndices(_):
                return .formAbsolutePosition
            case .named(_):
                return .formName
            case .withNames(_):
                return .formName
            case .withIntID(_):
                return .formUniqueID
            case .withIntIDs(_):
                return .formUniqueID
        }
    }    
    
    public var keydata: NSAppleEventDescriptor  {
        switch(self) {
            case .atIndex(let index):
                return NSAppleEventDescriptor(int: index) ?? NSAppleEventDescriptor.null()
            case .atIndices(let indices):
                return NSAppleEventDescriptor.listOf(ints: indices)
            case .named(let name):
               return NSAppleEventDescriptor(string: name)
            case .withNames(let names):
               return NSAppleEventDescriptor.listOf(strings: names)
            case .withIntID(let id):
                return NSAppleEventDescriptor(int: id) ?? NSAppleEventDescriptor.null()
            case .withIntIDs(let ids):
                return NSAppleEventDescriptor.listOf(ints: ids)
        }
    }
}

public enum SAESpecificPosition {
    case every
    case first
    case middle
    case last
    case random
    
    public var keyform: FourCharCode {
        return .formAbsolutePosition
    }
    
    public var keydata: NSAppleEventDescriptor {
        switch (self) {
            case .every:
                return NSAppleEventDescriptor(enumCode: .all)
            case .first:
                return NSAppleEventDescriptor(enumCode: .first)
            case .middle:
                return NSAppleEventDescriptor(enumCode: .middle)
            case .last:
                return NSAppleEventDescriptor(enumCode: .last)
            case .random:
                return NSAppleEventDescriptor(enumCode: .some)
        }
    }

}
