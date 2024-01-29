//
//  NSNotificationName.swift
//  xamanager
//
//  Created by Ivan Montiel Cardona on 28/01/24.
//

import Foundation

extension Notification.Name {
    static let menuWillOpen = Notification.Name("menuWillOpen")
    static let menuDidClose = Notification.Name("menuDidClose")
    static let deviceDeleted = Notification.Name("deviceDeleted")
    static let commandDidSucceed = Notification.Name("commandDidSucceed")
}

