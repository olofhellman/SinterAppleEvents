//
//  main.swift
//  SAEScriptableTestApp
//
//  A minimal scriptable macOS app, used to exercise SinterAppleEvents.
//  It is a slimmed-down stand-in for a real scriptable app such as SinterPixels:
//  it only supports "documents" that have a "name" property.
//

import AppKit

let delegate = TestAppDelegate()
let app = NSApplication.shared
app.delegate = delegate
app.setActivationPolicy(.regular)
Bundle.main.loadNibNamed("MainMenu", owner: app, topLevelObjects: nil)
app.run()
