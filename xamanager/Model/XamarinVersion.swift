//
//  XamarinVersion.swift
//  xamanager
//
//  Created by Ivan Montiel Cardona on 28/01/24.
//

import Foundation

struct XamarinVersion: Codable {
    var platform: Platform
    var version: String
    var identifier: Int
    var url: String
    var short_url: String?
    
    var displayName: String {
        switch platform {
        case .android:
            return "Xamarin.Android \(version)"
        case .ios:
            return "Xamarin.iOS \(version)"
        case .macos:
            return "Xamarin.Mac \(version)"
        }
    }
}
