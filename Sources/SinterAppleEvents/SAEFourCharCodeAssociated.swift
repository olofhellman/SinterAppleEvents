//
//  SAEFourCharCodeAssociated.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/23/26.
//

import Foundation

@MainActor
public protocol SAEFourCharCodeAssociated {
    static var fcc: FourCharCode { get }
}
