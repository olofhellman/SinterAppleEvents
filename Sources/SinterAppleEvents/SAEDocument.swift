//
//  SAEDocument.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/10/26.
//


import Foundation

public extension FourCharCode {
    static var document: FourCharCode { return FourCharCode(string: "docu")  }
}

@MainActor
open class SAEDocument: SAEObject, SAEMakeable {
    
    required public init(appContext: SAEAppContext?, objectSpecifier: SAEObjectSpecifier) {
        super.init(appContext: appContext, objectSpecifier: objectSpecifier)
    }

    public var name: String? {
        get async {
            let nameProperty = self.property(.name)  
            let gotValue = await nameProperty.getData()
            return gotValue.stringValue
        }
    }
    
    nonisolated(unsafe) public static var fcc: FourCharCode = .classDocument
}
