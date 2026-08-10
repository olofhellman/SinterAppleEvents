//
//  AEEventID+SAE.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/10/26.
//


import Foundation

public extension AEEventID {
    static var activate: AEEventID { return AEEventID(FourCharCode(string: "actv")) }
    static var close: AEEventID { return AEEventID(FourCharCode(string: "clos")) }
    static var count: AEEventID { return AEEventID(FourCharCode(string: "cnte")) }
    static var createElement: AEEventID { return AEEventID(FourCharCode(string: "crel")) }
    static var delete: AEEventID { return AEEventID(FourCharCode(string: "delo")) }
    static var exists: AEEventID { return AEEventID(FourCharCode(string: "doex")) }
    static var getData: AEEventID { return AEEventID(FourCharCode(string: "getd")) }
    static var open: AEEventID { return AEEventID(FourCharCode(string: "odoc")) }
    static var quit: AEEventID { return AEEventID(FourCharCode(string: "quit")) }
    static var reopen: AEEventID { return AEEventID(FourCharCode(string: "rapp")) }
    static var run: AEEventID { return AEEventID(FourCharCode(string: "oapp")) }
    static var setData: AEEventID { return AEEventID(FourCharCode(string: "setd")) }
}
