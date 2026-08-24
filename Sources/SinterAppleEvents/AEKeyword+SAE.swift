//
//  AEKeyword+SAE.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/10/26.
//

import Foundation

public extension AEKeyword {
    static var directObject: AEKeyword { return AEKeyword(string: "----") }
    static var container: AEKeyword { return AEKeyword(string: "from") }
    static var data: AEKeyword { return AEKeyword(string: "data") }
    static var desiredClass: AEKeyword { return AEKeyword(string: "want") }
    static var insertHere: AEKeyword { return AEKeyword(string: "insh") }
    static var keyform: AEKeyword { return AEKeyword(string: "form") }
    static var keydata: AEKeyword { return AEKeyword(string: "seld") }
    static var objectClass: AEKeyword { return AEKeyword(string: "kocl") }
    static var propData: AEKeyword { return AEKeyword(string: "prdt") }
    static var result: AEKeyword { return AEKeyword(string: "----") }
}

