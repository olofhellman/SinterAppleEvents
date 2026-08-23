//
//  SAEContainer.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/23/26.
//

import Foundation

public protocol SAEContainer {
    func make<T: SAEClass>(new type: T.Type, props: SAERecord?) -> T?
}
