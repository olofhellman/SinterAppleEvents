//
//  SPObject.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 7/12/26.
//


import Foundation
 
public class SAEObject: SAEScriptable {
    
    public func element(ofClass classFcc: FourCharCode, atASIndex idx: Int) -> NSAppleEventDescriptor? {
        let elements = self.elements(ofClass: classFcc)
        let eCount = elements.count
        let index = ( idx < 0) ? eCount + 1 + idx : idx
        guard (index > 0) && (index <= eCount) else {
            return nil
        }
        return elements[index - 1]
    }
    
    public func elements(ofClass classFcc: FourCharCode) -> [NSAppleEventDescriptor] {
        let event = app.coreEvent(eventID: FourCharCode.getData)
        
        let directObjectSpecifier = objSpec.every(classFcc)
        event.setParam(directObjectSpecifier.asNSAppleEventDescriptor(), forKeyword: .directObject)
        
        guard let reply = try? event.sendEvent(options: [], timeout: 10) else {
            return []
        }
        guard let result = reply.paramDescriptor(forKeyword: .result) else {
            return []
        }
        
        if result.descriptorType == typeAEList {
            var listOfAEDesc: [NSAppleEventDescriptor] = []
            let ct = result.numberOfItems
            for i in 1...ct {
                if let nthItem = result.atIndex(i) {
                    listOfAEDesc.append(nthItem)
                }
            }
            return listOfAEDesc
        }
        return []
    }

    public func make(new whatClass: FourCharCode, props: NSAppleEventDescriptor) -> NSAppleEventDescriptor? {
        return app.make(new: whatClass, container: self.objSpec, props: props)
     }

    public func property(_ propCode: FourCharCode) -> SAEObjectProperty? {
        return SAEObjectProperty(spObject: self, propCode: propCode)
     }
}
