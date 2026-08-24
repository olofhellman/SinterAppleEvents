//
//  TestDocument.swift
//  SAEScriptableTestApp
//

import Foundation

// the only kind of "document" this test app supports: it just has a name
final class TestDocument {
    let id: Int
    var name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
