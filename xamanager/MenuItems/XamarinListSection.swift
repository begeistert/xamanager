//
//  XamarinListSection.swift
//  xamanager
//
//  Created by Ivan Montiel Cardona on 29/01/24.
//

import Foundation

enum XamarinListSection: Int, CaseIterable {
    case android
    case iOS = 100
    case macOS

    var title: String {
        switch self {
        case .iOS:
            return NSLocalizedString("Xamarin.iOS", comment: "")
        case .android:
            return NSLocalizedString("Xamarin.Android", comment: "")
        case .macOS:
            return NSLocalizedString("Xamarin.Mac", comment: "")
        }
    }
}
