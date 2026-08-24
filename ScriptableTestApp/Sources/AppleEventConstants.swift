//
//  AppleEventConstants.swift
//  SAEScriptableTestApp
//
//  A real scriptable app doesn't link against SinterAppleEvents (that's a
//  client-side library), so this test app defines its own copies of the
//  four-char codes and keywords it needs to speak the Apple Event Object Model.
//

import Foundation

extension FourCharCode {
    init(string: String) {
        precondition(string.utf16.count == 4)
        self = string.utf16.reduce(0) { ($0 << 8) + FourCharCode($1) }
    }

    static var classDocument: FourCharCode { FourCharCode(string: "docu") }
    static var classProperty: FourCharCode { FourCharCode(string: "prop") }

    static var formAbsolutePosition: FourCharCode { FourCharCode(string: "indx") }
    static var formName: FourCharCode { FourCharCode(string: "name") }
    static var formUniqueID: FourCharCode { FourCharCode(string: "ID  ") }

    static var all: FourCharCode { FourCharCode(string: "all ") }

    static var pName: FourCharCode { FourCharCode(string: "pnam") }
}

extension AEEventClass {
    static var aevt: AEEventClass { AEEventClass(FourCharCode(string: "aevt")) }
    static var core: AEEventClass { AEEventClass(FourCharCode(string: "core")) }
}

extension AEEventID {
    static var count: AEEventID { AEEventID(FourCharCode(string: "cnte")) }
    static var createElement: AEEventID { AEEventID(FourCharCode(string: "crel")) }
    static var delete: AEEventID { AEEventID(FourCharCode(string: "delo")) }
    static var getData: AEEventID { AEEventID(FourCharCode(string: "getd")) }
    static var quit: AEEventID { AEEventID(FourCharCode(string: "quit")) }
    static var setData: AEEventID { AEEventID(FourCharCode(string: "setd")) }
}

extension AEKeyword {
    static var directObject: AEKeyword { AEKeyword(string: "----") }
    static var container: AEKeyword { AEKeyword(string: "from") }
    static var data: AEKeyword { AEKeyword(string: "data") }
    static var desiredClass: AEKeyword { AEKeyword(string: "want") }
    static var selform: AEKeyword { AEKeyword(string: "form") }
    static var seldata: AEKeyword { AEKeyword(string: "seld") }
    static var objectClass: AEKeyword { AEKeyword(string: "kocl") }
    static var propData: AEKeyword { AEKeyword(string: "prdt") }
    static var result: AEKeyword { AEKeyword(string: "----") }
}

extension NSAppleEventDescriptor {
    convenience init?(int: Int) {
        if int <= Int32.max && int >= Int32.min {
            self.init(int32: Int32(int))
        } else {
            var localInt = int
            let localData = Data(bytes: &localInt, count: MemoryLayout<Int>.size)
            self.init(descriptorType: typeSInt64, data: localData)
        }
    }

    var intValue: Int? {
        switch descriptorType {
        case typeSInt64:
            guard data.count == MemoryLayout<Int64>.size else { return nil }
            let value = data.withUnsafeBytes { $0.bindMemory(to: Int64.self)[0] }
            return Int(exactly: value)
        case typeUInt64:
            guard data.count == MemoryLayout<UInt64>.size else { return nil }
            let value = data.withUnsafeBytes { $0.bindMemory(to: UInt64.self)[0] }
            return Int(exactly: value)
        default:
            return Int(int32Value)
        }
    }
}
