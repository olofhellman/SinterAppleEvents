//
//  SAEDocument.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/10/26.
//


import Foundation
 
open class SAEDocument: SAEObject, SAEClass {
    public static let fcc: FourCharCode = .classDocument
    
    required override public init(app: SAEApp?, objSpec: NSAppleEventDescriptor) {
        super.init(app: app, objSpec: objSpec)
    }
}
