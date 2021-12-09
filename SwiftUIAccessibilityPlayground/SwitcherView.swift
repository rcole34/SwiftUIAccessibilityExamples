//
//  SwitcherView.swift
//  SwiftUIAccessibilityPlayground
//
//  Created by Ryan Cole on 11/29/21.
//

import SwiftUI

struct SwitcherView: View {
    @State private var accessibilityEnabled: Bool = false
    
    var body: some View {
        VStack {
            Toggle("Enable improved accessibility", isOn: $accessibilityEnabled)
                .padding(.horizontal, 16)
            Divider()
            if accessibilityEnabled {
                AccessibleContentView()
            } else {
                ContentView()
            }
        }
    }
}
