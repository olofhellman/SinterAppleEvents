//
//  TestAppDelegate+AppleEvents.swift
//  SAEScriptableTestApp
//
//  Implements just enough of the Apple Event Object Model to satisfy
//  SinterAppleEvents: resolving object specifiers, and handling
//  getData/setData/createElement/delete/count.
//

import AppKit

extension TestAppDelegate {

    // builds the object specifier that a client can use to refer back to this document
    func objectSpecifier(for doc: TestDocument) -> NSAppleEventDescriptor {
        let record = NSAppleEventDescriptor.record()
        record.setParam(NSAppleEventDescriptor.null(), forKeyword: .container)
        record.setParam(NSAppleEventDescriptor(enumCode: FourCharCode.formUniqueID), forKeyword: .selform)
        record.setParam(NSAppleEventDescriptor(typeCode: FourCharCode.classDocument), forKeyword: .desiredClass)
        record.setParam(NSAppleEventDescriptor(int: doc.id) ?? NSAppleEventDescriptor.null(), forKeyword: .seldata)
        return record.coerce(toDescriptorType: typeObjectSpecifier) ?? record
    }

    // resolves the "from" field of an object specifier: either the app itself (typeNull)
    // or a nested object specifier that needs to be resolved recursively
    func resolveContainer(_ containerDesc: NSAppleEventDescriptor) -> [ResolvedTarget] {
        if containerDesc.descriptorType == typeNull {
            return [.app]
        }
        return resolveSpecifier(containerDesc)
    }

    func resolveSpecifier(_ desc: NSAppleEventDescriptor) -> [ResolvedTarget] {
        guard let wantDesc = desc.paramDescriptor(forKeyword: .desiredClass) else { return [] }
        let want = wantDesc.typeCodeValue
        let fromDesc = desc.paramDescriptor(forKeyword: .container) ?? NSAppleEventDescriptor.null()
        let containers = resolveContainer(fromDesc)
        guard let keyformDesc = desc.paramDescriptor(forKeyword: .selform) else { return [] }
        let keyform = keyformDesc.enumCodeValue
        let keydata = desc.paramDescriptor(forKeyword: .seldata) ?? NSAppleEventDescriptor.null()

        if want == FourCharCode.classProperty {
            // AppleScript encodes a property's seld as typeType; typeCodeValue
            // coerces that (or the typeEnumerated form SinterAppleEvents sends) alike
            let propCode = keydata.typeCodeValue
            return containers.map { .property(owner: $0, code: propCode) }
        }

        if want == FourCharCode.classDocument {
            switch keyform {
            case FourCharCode.formAbsolutePosition:
                if keydata.descriptorType == typeEnumerated, keydata.enumCodeValue == FourCharCode.all {
                    return documents.map { .document($0) }
                }
                guard let index = keydata.intValue, let doc = documentAt(asIndex: index) else { return [] }
                return [.document(doc)]
            case FourCharCode.formUniqueID:
                guard let idValue = keydata.intValue, let doc = documents.first(where: { $0.id == idValue }) else { return [] }
                return [.document(doc)]
            case FourCharCode.formName:
                guard let nameValue = keydata.stringValue, let doc = documents.first(where: { $0.name == nameValue }) else { return [] }
                return [.document(doc)]
            default:
                return []
            }
        }

        return []
    }

    func documentAt(asIndex index: Int) -> TestDocument? {
        let resolvedIndex = index < 0 ? documents.count + 1 + index : index
        guard resolvedIndex > 0, resolvedIndex <= documents.count else { return nil }
        return documents[resolvedIndex - 1]
    }

    func value(owner: ResolvedTarget, code: FourCharCode) -> NSAppleEventDescriptor {
        switch owner {
        case .document(let doc):
            if code == FourCharCode.pName {
                return NSAppleEventDescriptor(string: doc.name)
            }
        case .app:
            if code == FourCharCode.pName {
                return NSAppleEventDescriptor(string: "SAEScriptableTestApp")
            }
        case .property:
            break
        }
        return NSAppleEventDescriptor.null()
    }

    func handleGetData(_ event: NSAppleEventDescriptor, reply: NSAppleEventDescriptor) {
        guard let directParam = event.paramDescriptor(forKeyword: .directObject),
              let wantDesc = directParam.paramDescriptor(forKeyword: .desiredClass) else {
            reply.setParam(NSAppleEventDescriptor.null(), forKeyword: .result)
            return
        }
        let want = wantDesc.typeCodeValue
        let targets = resolveSpecifier(directParam)

        if want == FourCharCode.classDocument {
            let list = NSAppleEventDescriptor.list()
            var count = 0
            for target in targets {
                if case .document(let doc) = target {
                    count += 1
                    list.insert(objectSpecifier(for: doc), at: count)
                }
            }
            reply.setParam(list, forKeyword: .result)
        } else if want == FourCharCode.classProperty {
            guard case .property(let owner, let code)? = targets.first else {
                reply.setParam(NSAppleEventDescriptor.null(), forKeyword: .result)
                return
            }
            reply.setParam(value(owner: owner, code: code), forKeyword: .result)
        }
    }

    func handleSetData(_ event: NSAppleEventDescriptor, reply: NSAppleEventDescriptor) {
        guard let directParam = event.paramDescriptor(forKeyword: .directObject),
              let newValue = event.paramDescriptor(forKeyword: .data) else { return }
        guard case .property(let owner, let code)? = resolveSpecifier(directParam).first else { return }
        guard case .document(let doc) = owner else { return }
        if code == FourCharCode.pName {
            doc.name = newValue.stringValue ?? doc.name
        }
    }

    func handleCreateElement(_ event: NSAppleEventDescriptor, reply: NSAppleEventDescriptor) {
        guard let classDesc = event.paramDescriptor(forKeyword: .objectClass),
              classDesc.typeCodeValue == FourCharCode.classDocument else { return }

        let id = makeDocumentID()
        var name = "untitled \(id)"
        if let propsRecord = event.paramDescriptor(forKeyword: .propData),
           let nameDesc = propsRecord.paramDescriptor(forKeyword: FourCharCode.pName) {
            name = nameDesc.stringValue ?? name
        }

        let doc = TestDocument(id: id, name: name)
        documents.append(doc)
        reply.setParam(objectSpecifier(for: doc), forKeyword: .result)
    }

    func handleDelete(_ event: NSAppleEventDescriptor, reply: NSAppleEventDescriptor) {
        guard let directParam = event.paramDescriptor(forKeyword: .directObject) else { return }
        for target in resolveSpecifier(directParam) {
            if case .document(let doc) = target {
                documents.removeAll { $0.id == doc.id }
            }
        }
    }

    func handleCount(_ event: NSAppleEventDescriptor, reply: NSAppleEventDescriptor) {
        guard let classDesc = event.paramDescriptor(forKeyword: .objectClass),
              classDesc.typeCodeValue == FourCharCode.classDocument else { return }
        reply.setParam(NSAppleEventDescriptor(int32: Int32(documents.count)), forKeyword: .result)
    }
}
