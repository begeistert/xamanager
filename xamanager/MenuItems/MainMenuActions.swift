//
//  MainMenuActions.swift
//  xamanager
//
//  Created by Ivan Montiel Cardona on 29/01/24.
//

import Foundation


enum MainMenuActions: Int, CaseIterable {
    case clearDerrivedData = 200
    case preferences
    case quit

    var keyEquivalent: String {
        switch self {
        case .quit:
            return "q"
        case .preferences:
            return ","
        default:
            return ""
        }
    }

    var title: String {
        switch self {
        case .quit:
            return NSLocalizedString("Quit", comment: "")
        case .preferences:
            return NSLocalizedString("Preferences", comment: "")
        case .clearDerrivedData:
            return NSLocalizedString("Clear Xamanager Derived Data", comment: "")
        }
    }
}

