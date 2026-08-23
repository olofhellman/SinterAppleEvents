//
//  AppObjectSpecifier.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/10/26.
//

import Foundation

public class AppObjectSpecifier: SAEObjectSpecifier {
    public let appBundleIdentifier: String
    public init(appIdentifier: String) {
        self.appBundleIdentifier = appIdentifier
        super.init(FourCharCode.classApplication, container: nil, keyform: FourCharCode.formUniqueID, keydata: NSAppleEventDescriptor.null())
    }
    
    override public func asNSAppleEventDescriptor() -> NSAppleEventDescriptor {
        return NSAppleEventDescriptor.null()
    }
}
