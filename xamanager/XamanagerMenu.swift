//
//  XamanagerMenu.swift
//  xamanager
//
//  Created by Ivan Montiel Cardona on 28/01/24.
//

import SwiftUI

struct XamanagerMenu: View {
    func android(){}
    func ios(){}
    func macos(){}
    
    var body: some View {
        Text("Xamarin.Android")
        Button(action: android, label: { Text("16.6") })
        
        Divider()
        
        Text("Xamarin.iOS")
        Button(action: ios, label: { Text("13.0") })
        
        Divider()
        
        Text("Xamarin.Mac")
        Button(action: macos, label: { Text("9.0.6") })
    }
}
