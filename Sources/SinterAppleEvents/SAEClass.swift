//
//  SAEClass.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/23/26.
//

import Foundation

public protocol SAEClass: SAEObject {
    static var fcc: FourCharCode { get }
    init(app: SAEApp?, objSpec: NSAppleEventDescriptor)
}
