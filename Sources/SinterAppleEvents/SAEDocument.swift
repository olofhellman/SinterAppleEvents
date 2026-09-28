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

open class SAEDocument: SAEClass, SAEMakeable {
    
    public var name: String? {
        get async {
            guard let nameProperty = self.property(.name) else { return nil }
            let gotValue = await nameProperty.getData()
            return gotValue.stringValue
        }
    }
    
    nonisolated(unsafe) public static var fcc: FourCharCode = .classDocument
}
