//
//  AppDelegate.swift
//  xamanager
//
//  Created by Ivan Montiel Cardona on 28/01/24.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    private var xamanager: Xamanager!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        xamanager = Xamanager()
        
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        true
    }
}
