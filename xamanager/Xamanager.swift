//
//  Xamanager.swift
//  xamanager
//
//  Created by Ivan Montiel Cardona on 28/01/24.
//

import Foundation
import AppKit
import SwiftUI

class Xamanager: NSObject {
    private var menu: Menu!
    
    @objc let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override init() {
        super.init()
        
        
        setup()
    }
    
    func open() {
        self.statusItem.button?.performClick(self)
    }
    
    private func setup() {
        menu = Menu()
        statusItem.menu = menu
        setMenuImage()

        if menu.items.isEmpty {
            menu.populateDefaultMenu()
            menu.items += mainMenu
        }
        menu.updateVersionsList()
    }
    
    private func setMenuImage() {
        if let button = statusItem.button {
            button.toolTip = "MiniSim"
            let itemImage = NSImage(named: "menu_icon")
            itemImage?.size = NSSize(width: 9, height: 16)
            itemImage?.isTemplate = true
            button.image = itemImage
        }
    }
    
    @objc func menuItemAction(_ sender: NSMenuItem) {
        if let tag = MainMenuActions(rawValue: sender.tag) {
            switch tag {
            case .preferences:
                //settingsController.show()
                //settingsController.window?.orderFrontRegardless()
                break
            case .quit:
                NSApp.terminate(sender)
            case .clearDerrivedData:
                break
                /*let shouldDelete = NSAlert.showQuestionDialog(
                    title: "Are you sure?",
                    message: "This action will delete derived data from your computer."
                )
                if !shouldDelete {
                    return
                }

                DeviceService.clearDerivedData { amountCleared, error in
                    guard error == nil else {
                        NSAlert.showError(message: error?.localizedDescription ?? "Failed to clear derived  data.")
                        return
                    }
                    UNUserNotificationCenter.showNotification(
                        title: "Derived data has been cleared!",
                        body: "Removed \(amountCleared) of data"
                    )
                    NotificationCenter.default.post(name: .commandDidSucceed, object: nil)
                }*/
            }
        }
    }
    
    private var mainMenu: [NSMenuItem] {
        MainMenuActions.allCases.map { item in
            NSMenuItem( 
                mainMenuItem: item,
                target: self, 
                action: #selector(menuItemAction)
            )
        }
    }

}

extension Xamanager: NSWindowDelegate {
    func windowDidBecomeKey(_ notification: Notification) {
        NSApplication.shared.setActivationPolicy(.regular)
    }

    func windowWillClose(_ notification: Notification) {
        NSApplication.shared.setActivationPolicy(.accessory)
    }
}
