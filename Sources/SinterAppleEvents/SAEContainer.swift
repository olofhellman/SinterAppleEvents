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
    
    func element(ofClass classFcc: FourCharCode, atASIndex idx: Int) async -> NSAppleEventDescriptor?
    func elements(ofClass classFcc: FourCharCode) async -> [NSAppleEventDescriptor]
    
    func make<T: SAEMakeable>(new type: T.Type, props: SAERecord?) async -> T?
    func delete<T: SAEMakeable>(_ type: T.Type, _ formAndData: SAEKeyFormAndData) async
    func delete<T: SAEMakeable>(_ specificPosition: SAESpecificPosition, _ type: T.Type) async
    func delete(containedObject: SAEContainedObjectSpecifier) async
}

extension SAEContainer {
        
    public func delete<T: SAEMakeable>(_ type: T.Type, _ formAndData: SAEKeyFormAndData) async {
        let cos = SAEContainedObjectSpecifier(fcc: type.fcc, formAndData: formAndData)
        await self.delete(containedObject:cos)
    }
    
    public func delete<T: SAEMakeable>(_ specificPosition: SAESpecificPosition, _ type: T.Type) async {
        let cos = SAEContainedObjectSpecifier(fcc: type.fcc, specificPosition: specificPosition)
        await self.delete(containedObject:cos)
    }
    
    public func delete(containedObject: SAEContainedObjectSpecifier) async {
        let directObject = self.objectSpecifier(for: containedObject)
        await appContext.sendDelete(directObject: directObject)
    }
    
    public func make<T: SAEMakeable>(new type: T.Type, props: SAERecord? = nil) async -> T? {
        let container = self.containerForCrelEvent
        guard let eventResult = await appContext.sendCreateElement(fcc: type.fcc, container: container, props: props) else {
            return nil
        }
        return T(appContext: appContext, objSpec: eventResult)
    }

}
