//
//  SAEDocument.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/10/26.
//


import Foundation
 
public extension FourCharCode {
    static var classDocument: FourCharCode { return FourCharCode(string: "docu")  }
}

open class SAEDocument: SAEObject {
    public static let fcc: FourCharCode = .classDocument
}
