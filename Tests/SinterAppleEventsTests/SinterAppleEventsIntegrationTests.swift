//
//  SinterAppleEventsIntegrationTests.swift
//  SinterAppleEventsTests
//
//  Launches the SAEScriptableTestApp helper and exercises SinterAppleEvents
//  against it: making and deleting documents, and getting/setting their
//  "name" property.
//

import XCTest
@testable import SinterAppleEvents

final class SinterAppleEventsIntegrationTests: XCTestCase {

    var process: Process!

    override func setUpWithError() throws {
        process = Process()
        process.executableURL = productsDirectory().appendingPathComponent("SAEScriptableTestApp")
        try process.run()
        // give the helper app a moment to launch and install its Apple Event handlers
        Thread.sleep(forTimeInterval: 0.5)
    }

    override func tearDownWithError() throws {
        process.terminate()
        process.waitUntilExit()
    }

    func testDocumentLifecycle() throws {
        let app = SAEApp(processIdentifier: process.processIdentifier)

        // DEBUG
        let debugEvent = app.createElementEvent()
        debugEvent.setParam(.objectClass, typeCode: .classDocument)
        do {
            let r = try debugEvent.sendEvent(options: .waitForReply, timeout: 10)
            print("DEBUG reply: \(r)")
        } catch {
            print("DEBUG error: \(error)")
        }

        let props = SAERecord()
        props.setKey(.pName, descriptor: NSAppleEventDescriptor(string: "First Document"))
        guard let firstDoc = app.make(new: SAEDocument.self, props: props) else {
            return XCTFail("failed to make first document")
        }
        guard let secondDoc = app.make(new: SAEDocument.self) else {
            return XCTFail("failed to make second document")
        }

        XCTAssertEqual(app.documents().count, 2)
        XCTAssertEqual(app.count(.classDocument, container: NSAppleEventDescriptor.null()), 2)

        let nameProperty = firstDoc.property(.pName)
        XCTAssertEqual(nameProperty?.getData().stringValue, "First Document")

        nameProperty?.setData(newValue: NSAppleEventDescriptor(string: "Renamed Document"))
        XCTAssertEqual(nameProperty?.getData().stringValue, "Renamed Document")

        app.sendDelete(directObject: firstDoc.objSpec)
        XCTAssertEqual(app.documents().count, 1)

        app.sendDelete(directObject: secondDoc.objSpec)
        XCTAssertEqual(app.documents().count, 0)
    }

    // returns the directory that holds the build products, which is where
    // the SAEScriptableTestApp executable built by this package ends up
    private func productsDirectory() -> URL {
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
    }
}
