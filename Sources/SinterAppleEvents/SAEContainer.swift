//
//  SAEContainer.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/23/26.
//

import Foundation

public protocol SAEContainer {
    func make<T: SAEMakeable>(new type: T.Type, props: SAERecord?) -> T?
}
