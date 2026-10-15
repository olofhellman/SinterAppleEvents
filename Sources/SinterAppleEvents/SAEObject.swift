//
//  SAEObject.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 7/12/26.
//


import Foundation
 
@MainActor
open class SAEObject: SAEReference {
    
    public var contentsContainerSpecifier: SAEObjectSpecifier  {
        return saeObjectSpecifier
    }

    // mark as required because this is needed by SAEMakeable instances
    required override public init(appContext: SAEAppContext?, objectSpecifier: SAEObjectSpecifier) {
        super.init(appContext: appContext, objectSpecifier: objectSpecifier)
    }

    //public func objectSpecifier(for containedObject: SAEContentSpecificcation) -> NSAppleEventDescriptor {
     //   return containedObject.asTypeObjectSpecifierDescriptor(container: self.objSpec)
    //}

    public func element(ofClass classFcc: FourCharCode, atASIndex idx: Int) async -> NSAppleEventDescriptor? {
        let elements = await self.elements(ofClass: classFcc)
        let eCount = elements.count
        let index = ( idx < 0) ? eCount + 1 + idx : idx
        guard (index > 0) && (index <= eCount) else {
            return nil
        }
        return elements[index - 1]
    }
    
    public func elements(ofClass classFcc: FourCharCode) async -> [NSAppleEventDescriptor] {
        let event = appContext.coreEvent(eventID: FourCharCode.getData)
        
        let directObjectSpecifier = objectSpecifier.every(classFcc)
        event.setParam(directObjectSpecifier.asTypeObjectSpecifierDescriptor(), forKeyword: .directObject)
        
        guard let reply = try? event.sendEvent(options: [], timeout: 10) else {
            return []
        }
        
        guard let result = reply.paramDescriptor(forKeyword: .result) else {
            return []
        }
        
        if result.descriptorType == typeAEList {
            var listOfAEDesc: [NSAppleEventDescriptor] = []
            let ct = result.numberOfItems
            guard ct > 0 else { return listOfAEDesc }
            for i in 1...ct {
                if let nthItem = result.atIndex(i) {
                    listOfAEDesc.append(nthItem)
                }
            }
            return listOfAEDesc
        } else if result.descriptorType == typeObjectSpecifier {
            return [result]
        }
        
        return []
    }

    public func property(_ propCode: FourCharCode) -> SAEObjectProperty {
        return SAEObjectProperty(saeObject: self, propCode: propCode)
    }
}
