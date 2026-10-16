//
//  DescType+SAE.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 10/15/26.
//

import Foundation

extension DescType {

    var description: String { self.asString() }
    
    public func asString() -> String {
        let byteArray: [UInt8] = [
            UInt8(self >> 24 & 0xFF),
            UInt8(self >> 16 & 0xFF),
            UInt8(self >> 8 & 0xFF),
            UInt8(self & 0xFF)
        ]
        return String(decoding: byteArray, as: UTF8.self)
    }
}
