//
//  SAEClass.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/23/26.
//

import Foundation

open class SAEClass: SAEObject {

    required override public init(app: SAEApp?, objSpec: NSAppleEventDescriptor) {
        super.init(app: app, objSpec: objSpec)
    }
}
