//
//  Bundle+appName.swift
//  xamanager
//
//  Created by Ivan Montiel Cardona on 29/01/24.
//

import Foundation

extension Bundle {
    var appName: String? {
        object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}

