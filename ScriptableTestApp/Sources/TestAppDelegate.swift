//
//  TestAppDelegate.swift
//  SAEScriptableTestApp
//

import AppKit

// resolving an object specifier can point at the app itself, a document,
// or a property of one of those, so the resolved target has to be recursive
indirect enum ResolvedTarget {
    case app
    case document(TestDocument)
    case property(owner: ResolvedTarget, code: FourCharCode)
}

@objc @MainActor final class TestAppDelegate: NSObject, NSApplicationDelegate {

    var documents: [TestDocument] = []
    private var nextDocumentID = 1

    func applicationDidFinishLaunching(_ notification: Notification) {
        let manager = NSAppleEventManager.shared()
        let selector = #selector(handleAppleEvent(_:withReplyEvent:))
        let coreEventIDs: [AEEventID] = [.getData, .setData, .createElement, .delete, .count]
        for eventID in coreEventIDs {
            manager.setEventHandler(self, andSelector: selector, forEventClass: AEEventClass.core, andEventID: eventID)
        }
        manager.setEventHandler(self, andSelector: selector, forEventClass: AEEventClass.aevt, andEventID: .quit)
    }

    @objc func handleAppleEvent(_ event: NSAppleEventDescriptor, withReplyEvent reply: NSAppleEventDescriptor) {
        switch event.eventID {
        case AEEventID.getData:
            handleGetData(event, reply: reply)
        case AEEventID.setData:
            handleSetData(event, reply: reply)
        case AEEventID.createElement:
            handleCreateElement(event, reply: reply)
        case AEEventID.delete:
            handleDelete(event, reply: reply)
        case AEEventID.count:
            handleCount(event, reply: reply)
        case AEEventID.quit:
            NSApp.terminate(nil)
        default:
            break
        }
    }

    func makeDocumentID() -> Int {
        let id = nextDocumentID
        nextDocumentID += 1
        return id
    }
}
