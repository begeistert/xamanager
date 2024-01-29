//
//  Menu.swift
//  xamanager
//
//  Created by Ivan Montiel Cardona on 28/01/24.
//

import AppKit

class Menu: NSMenu {
    
    var versions: [XamarinVersion] = [] {
        didSet {
            populateVersionsMenu(versions)
            // assignKeyEquivalents()
        }
        willSet {
            let versions = Set(versions.map { $0.version })
            let updatedVersions = Set(newValue.map { $0.version })
            removeMenuItems(removedDevices: versions.subtracting(updatedVersions))
        }
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(title: "Xamanager")
        self.delegate = self
    }
    
    func populateDefaultMenu() {
        var sections: [XamarinListSection] = []
        
        sections.append(.android)
        sections.append(.iOS)
        sections.append(.macOS)

        var menuItems: [NSMenuItem] = []

        sections.forEach { section in
            var menuItem: NSMenuItem
            if #available(macOS 14.0, *) {
                menuItem = NSMenuItem.sectionHeader(title: "")
            } else {
                menuItem = NSMenuItem()
            }
            menuItem.tag = section.rawValue
            menuItem.title = section.title
            menuItem.toolTip = section.title

            menuItems.append(menuItem)
            menuItems.append(NSMenuItem.separator())
        }
        self.items = menuItems
    }
    
    private func createMenuItem(for version: XamarinVersion) -> NSMenuItem {
        let menuItem = NSMenuItem(
            title: version.version,
            action: #selector(deviceItemClick),
            keyEquivalent: "",
            type: version.platform == .ios ? .launchIOS : version.platform == .macos ? .launchMac : .launchAndroid
        )

        menuItem.target = self
        menuItem.keyEquivalentModifierMask = version.platform == .android ? [.option] : [.command]
        menuItem.submenu = buildSubMenu(for: version)
        return menuItem
    }
    
    func buildSubMenu(for version: XamarinVersion) -> NSMenu {
        let subMenu = NSMenu()
        let platform = version.platform
        let callback = platform == .android ? #selector(androidSubMenuClick) : #selector(IOSSubMenuClick)
        let actionsSubMenu = createActionsSubMenu(
            for: platform.subMenuItems,
            isVersionInstalled: true,
            callback: callback
        )
        (actionsSubMenu).forEach { subMenu.addItem($0) }
        return subMenu
    }
    
    func createActionsSubMenu(
        for subMenuItems: [SubMenuItem],
        isVersionInstalled: Bool,
        callback: Selector
    ) -> [NSMenuItem] {
        subMenuItems.compactMap { item in
            if item is SubMenuItems.Separator {
                return NSMenuItem.separator()
            }

            if let item = item as? SubMenuActionItem {
                return NSMenuItem(menuItem: item, target: self, action: callback)
            }

            return nil
        }
    }
    
    @objc private func androidSubMenuClick(_ sender: NSMenuItem) {
        guard let tag = SubMenuItems.Tags(rawValue: sender.tag) else { return }
        guard let version = getXamarinByVersion(version: sender.parent?.title ?? "") else { return }

        // DeviceService.handleAndroidAction(device: device, commandTag: tag, itemName: sender.title)
    }

    @objc private func IOSSubMenuClick(_ sender: NSMenuItem) {
        guard let tag = SubMenuItems.Tags(rawValue: sender.tag) else { return }
        guard let version = getXamarinByVersion(version: sender.parent?.title ?? "") else { return }

        // DeviceService.handleiOSAction(device: device, commandTag: tag, itemName: sender.title)
    }
    
    @objc private func deviceItemClick(_ sender: NSMenuItem) {
        guard let version = getXamarinByVersion(version: sender.title) else { return }

        // if device.booted {
        //     XamarinService.focusDevice(device)
        //     return
        // }

        // XamarinService.launch(device: device) { error in
        //     if let error {
        //         NSAlert.showError(message: error.localizedDescription)
        //    }
        // }
    }
    
    private func populateVersionsMenu(_ versions: [XamarinVersion]) {
        let platformSections: [XamarinListSection] = sections
        for section in platformSections {
            let sectionVersions = filter(versions: versions, for: section).sorted { $0.identifier > $1.identifier }
            let menuItems = sectionVersions.map { createMenuItem(for: $0) }
            self.updateSection(with: menuItems, section: section)
        }
    }
    
    var sections: [XamarinListSection] {
        var sections: [XamarinListSection] = []

        sections.append(.android)
        sections.append(.iOS)
        sections.append(.macOS)
        return sections
    }
    
    private func filter(versions: [XamarinVersion], for section: XamarinListSection) -> [XamarinVersion] {
        let platform: Platform = section == .iOS ? .ios : section == .macOS ? .macos : .android
        return versions.filter { $0.platform == platform }
    }
    
    private func updateSection(with items: [NSMenuItem], section: XamarinListSection) {
        guard let header = self.items.first(where: { $0.tag == section.rawValue }),
              let startIndex = self.items.firstIndex(of: header) else {
            return
        }

        for menuItem in items.reversed() {
            if let itemIndex = self.items.firstIndex(where: { $0.title == menuItem.title }) {
                self.replaceMenuItem(at: itemIndex, with: menuItem)
                continue
            }
            self.safeInsertItem(menuItem, at: startIndex + 1)
        }
    }
    
    private func replaceMenuItem(at index: Int, with newItem: NSMenuItem) {
        self.removeItem(at: index)
        self.insertItem(newItem, at: index)
    }
    
    private func safeInsertItem(_ item: NSMenuItem, at index: Int) {
         guard !items.contains(where: { $0.title == item.title }),
               index <= items.count else {
             return
         }

         insertItem(item, at: index)
     }
    
    private func removeMenuItems(removedDevices: Set<String>) {
        self.items
            .filter { removedDevices.contains($0.title) }
            .forEach(safeRemoveItem)
    }
    
    private func safeRemoveItem(_ item: NSMenuItem?) {
        guard let item, items.contains(item) else {
            return
        }

        removeItem(item)
    }
    
    func updateVersionsList() {
        XamarinManager.getAllVersions() { versions, error in
            if let error {
                NSAlert.showError(message: error.localizedDescription)
                return
            }
            self.versions = versions
        }
    }
    
    private func getXamarinByVersion(version: String) -> XamarinVersion? {
        versions.first { $0.version == version }
    }
    
}

extension Menu: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        NotificationCenter.default.post(name: .menuWillOpen, object: nil)
        //self.updateDevicesList()
    }

    func menuDidClose(_ menu: NSMenu) {
        NotificationCenter.default.post(name: .menuDidClose, object: nil)
    }
}


extension Platform {
    var subMenuItems: [SubMenuItem] {
        switch self {
        case .android:
            return SubMenuItems.android
        case .ios:
            return SubMenuItems.ios
        case .macos:
            return SubMenuItems.macos
        }
    }
}

