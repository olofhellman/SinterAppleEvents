//
//  SAEContainer.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/23/26.
//

import Foundation

public protocol SAEContainer {
    var appContext: any SAEAppContext { get }
    var containerForCrelEvent: NSAppleEventDescriptor { get }
    func objectSpecifier(for containedObject: SAEContainedObjectSpecifier) -> NSAppleEventDescriptor 
    
    func element(ofClass classFcc: FourCharCode, atASIndex idx: Int) -> NSAppleEventDescriptor? 
    func elements(ofClass classFcc: FourCharCode) -> [NSAppleEventDescriptor] 
    
    func make<T: SAEMakeable>(new type: T.Type, props: SAERecord?) -> T?
    func delete<T: SAEMakeable>(_ type: T.Type, _ formAndData: SAEKeyFormAndData) 
    func delete<T: SAEMakeable>(_ specificPosition: SAESpecificPosition, _ type: T.Type)
    func delete(containedObject: SAEContainedObjectSpecifier)
}

extension SAEContainer {
        
    public func delete<T: SAEMakeable>(_ type: T.Type, _ formAndData: SAEKeyFormAndData) {
        let cos = SAEContainedObjectSpecifier(fcc: type.fcc, formAndData: formAndData)
        self.delete(containedObject:cos)
    }
    
    public func delete<T: SAEMakeable>(_ specificPosition: SAESpecificPosition, _ type: T.Type) {
        let cos = SAEContainedObjectSpecifier(fcc: type.fcc, specificPosition: specificPosition)
        self.delete(containedObject:cos)
    }
    
    public func delete(containedObject: SAEContainedObjectSpecifier) {
        let directObject = self.objectSpecifier(for: containedObject)
        appContext.sendDelete(directObject: directObject)
    }
    
    public func make<T: SAEMakeable>(new type: T.Type, props: SAERecord? = nil) -> T? {
        let container = self.containerForCrelEvent
        guard let eventResult = appContext.sendCreateElement(fcc: type.fcc, container: container, props: props) else {
            return nil
        }
        return T(appContext: appContext, objSpec: eventResult)
    }

}
