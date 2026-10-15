//
//  SAEContainer.swift
//  SinterAppleEvents
//
//  Created by Olof Hellman on 8/23/26.
//

import Foundation

@MainActor
public protocol SAEContainer {
    var appContext: any SAEAppContext { get }
    var contentsContainerDescriptor: NSAppleEventDescriptor { get }
    var contentsContainerSpecifier: SAEObjectSpecifier { get }
    func contentsDescriptor(for contents: SAEContentSpecification) -> NSAppleEventDescriptor
    func contentsSpecifier(for contents: SAEContentSpecification) -> SAEObjectSpecifier

    func element(ofClass classFcc: FourCharCode, atASIndex idx: Int) async -> NSAppleEventDescriptor?
    func elements(ofClass classFcc: FourCharCode) async -> [NSAppleEventDescriptor]
    
    func make<T: SAEMakeable>(new type: T.Type, props: SAERecord?) async -> T?
    func delete<T: SAEMakeable>(_ type: T.Type, _ formAndData: SAEKeyFormAndData) async
    func delete<T: SAEMakeable>(_ specificPosition: SAESpecificPosition, _ type: T.Type) async
    func delete(contents: SAEContentSpecification) async
}

extension SAEContainer {
    
    public var contentsContainerDescriptor: NSAppleEventDescriptor  {
        return contentsContainerSpecifier.nsAppleEventDescriptor
    }

    @MainActor
    public func contentsSpecifier(for contents: SAEContentSpecification) -> SAEObjectSpecifier {
        return SAEObjectSpecifier(contents.fcc, container: contentsContainerDescriptor, keyform: contents.keyform, keydata: contents.keydata)
    }
    
    @MainActor
    public func contentsDescriptor(for contents: SAEContentSpecification) -> NSAppleEventDescriptor {
        return contentsSpecifier(for: contents).nsAppleEventDescriptor
    }
    
    @MainActor
    public func delete<T: SAEMakeable>(_ type: T.Type, _ formAndData: SAEKeyFormAndData) async {
        let contents = SAEContentSpecification(fcc: type.fcc, formAndData: formAndData)
        await self.delete(contents: contents)
    }
    
    @MainActor
    public func delete<T: SAEMakeable>(_ specificPosition: SAESpecificPosition, _ type: T.Type) async {
        let contents = SAEContentSpecification(fcc: type.fcc, specificPosition: specificPosition)
        await self.delete(contents: contents)
    }
    
    @MainActor
    public func delete(contents: SAEContentSpecification) async {
        let directObject = contentsSpecifier(for: contents)
        await appContext.sendDelete(directObject: directObject)
    }
    
    @MainActor
    public func make<T: SAEMakeable>(new type: T.Type, props: SAERecord? = nil) async -> T? {
        guard let eventResult = await appContext.sendCreateElement(fcc: type.fcc, container: contentsContainerSpecifier, props: props) else {
            return nil
        }
        guard let objectSpecifier = SAEObjectSpecifier(nsAppleEventDescriptor: eventResult) else {
            print ("error initializing SAEObjectSpecifier from eventResult")
            return nil
        }
        return T(appContext: appContext, objectSpecifier: objectSpecifier)
    }

}
