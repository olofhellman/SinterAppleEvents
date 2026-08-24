//
//  SAEClass.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/23/26.
//

import Foundation

open class SAEClass: SAEObject {

    required override public init(appContext: SAEAppContext?, objSpec: NSAppleEventDescriptor) {
        super.init(appContext: appContext, objSpec: objSpec)
    }
}
