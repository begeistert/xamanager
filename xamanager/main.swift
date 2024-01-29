//
//  main.swift
//  xamanager
//
//  Created by Ivan Montiel Cardona on 29/01/24.
//

import AppKit

let app = NSApplication.shared

let delegate = AppDelegate()
app.delegate = delegate

app.setActivationPolicy(.accessory)

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
