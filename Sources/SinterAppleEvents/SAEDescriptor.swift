//
//  SAEDescriptor.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 10/13/26.
//

// SAEDescriptor is the Sendable substitute for NSAppleEventDescriptor

import Foundation

public struct SAEDescriptor {
    
    let descriptorType: DescType
    let data: Data
    
    init(ns: NSAppleEventDescriptor) {
        self.descriptorType = ns.descriptorType
        self.data = ns.data
    }
    
    var nsDescriptor: NSAppleEventDescriptor {
        guard let ns = NSAppleEventDescriptor(descriptorType: descriptorType, data: data) else {
            print ("Failed to create NSAppleEventDescriptor from SAEDescriptor")
            return NSAppleEventDescriptor.null()
        }
    
        return ns
    }
    
}
