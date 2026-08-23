//
//  SAEDocument.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/10/26.
//


import Foundation
 
open class SAEDocument: SAEClass, SAEMakeable {
    nonisolated(unsafe) public static var fcc: FourCharCode = .classDocument
}
