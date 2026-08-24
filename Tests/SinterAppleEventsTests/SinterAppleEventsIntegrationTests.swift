//
//  SinterAppleEventsIntegrationTests.swift
//  SinterAppleEventsTests
//
//  Launches the SAEScriptableTestApp helper and exercises SinterAppleEvents
//  against it: making and deleting documents, and getting/setting their
//  "name" property.
//

import XCTest
import AppKit
import SinterAppleEvents

final class SinterAppleEventsIntegrationTests: XCTestCase {
    var targetApp: NSRunningApplication!
    
    override func setUpWithError() throws {
        targetApp = NSWorkspace.shared.runningApplications.first {
            $0.localizedName == "SAEScriptableTestApp"
        }
        guard targetApp != nil else {
            throw XCTSkip("SAEScriptableTestApp is not running")
        }
    }

    override func tearDownWithError() throws {
    }

    func testDocumentLifecycle() throws {
        let app = SAEApp(processIdentifier: targetApp.processIdentifier)

        // DEBUG
        let debugEvent = app.createElementEvent()
        debugEvent.setParam(.objectClass, typeCode: .classDocument)
        do {
            let r = try debugEvent.sendEvent(options: .waitForReply, timeout: 10)
            print("DEBUG reply: \(r)")
        } catch {
            print("DEBUG error: \(error)")
        }
        let docCountAtStart = app.documents().count
        
        let props = SAERecord()
        props.setKey(.pName, descriptor: NSAppleEventDescriptor(string: "First Document"))
        guard let firstDoc = app.make(new: SAEDocument.self, props: props) else {
            return XCTFail("failed to make first document")
        }

        XCTAssertEqual(app.documents().count, docCountAtStart + 1)

        let nameProperty = firstDoc.property(.pName)
        XCTAssertEqual(nameProperty?.getData().stringValue, "First Document")

        nameProperty?.setData(newValue: NSAppleEventDescriptor(string: "Renamed Document"))
        XCTAssertEqual(nameProperty?.getData().stringValue, "Renamed Document")

        app.sendDelete(directObject: firstDoc.objSpec)
        XCTAssertEqual(app.documents().count, docCountAtStart)

    }
}
