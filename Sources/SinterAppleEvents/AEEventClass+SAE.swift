//
//  AEEventClass+SAE.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/10/26.
//


import Foundation

public extension AEEventClass {
    static var aevt: AEEventClass { return AEEventClass(FourCharCode(string: "aevt")) }
    static var core: AEEventClass { return AEEventClass(FourCharCode(string: "core")) }
    static var misc: AEEventClass { return AEEventClass(FourCharCode(string: "misc")) }
}
