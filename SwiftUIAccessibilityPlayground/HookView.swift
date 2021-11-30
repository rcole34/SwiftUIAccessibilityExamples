//
//  HookView.swift
//  SwiftUIAccessibilityPlayground
//
//  Created by Ryan Cole on 7/19/21.
//

import SwiftUI

/**
 * A simple hook consisting of an image, title, and subtitle, that takes in a closure to execute when the hook is tapped.
 * We'll see how we can vastly improve the accessibility of this closure with just three small changes.
 */
struct HookView: View {
    var onTap: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 16) {
            Image("premium")
                .resizable()
                .frame(width: 48, height: 48)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Upgrade to Premium")
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .bold))
                
                Text("Become a premium user to get access to all the latest features.")
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .medium))
            }
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 28))
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .gray.opacity(0.2), radius: 12, x: 0, y: 6)
        .onTapGesture {
            onTap?()
        }
    }
}

struct HookView_Previews: PreviewProvider {
    static var previews: some View {
        HookView().padding(16)
    }
}














































/**
 * The first things we notice when navigating this hook with VoiceOver is that it reads each element individually, including the image. Beacuse this image does not add much contextual value, we can either add the `accessibility(hidden: true)` modifier, or use the `Image(decorative:)` constructor to tell VoiceOver to ignore the image. We can then add the `accessibilityElement(children: .combine)` modifier to the enclosing `HStack` to treat the entire hook as a single accessibility element, and to read the title and subtitle together when it receives VoiceOver focus.
 * The next thing to notice is that to a VoiceOver user it is not clear that we can tap on the hook. We can tell VoiceOver that this element acts as a button by adding the `.accessibility(addTraits: .isButton)` modifier. This trait would be added automatically if we were using a SwiftUI `Button`, but because we are using an `HStack` with an `onTap` modifier, we need to add it ourselves.
 * We can also change fonts to use dynamic font types rather than hardcoded sizes so that our test scales with a user's accesibility settings for font size.
 */
struct AccessibleHookView: View {
    var onTap: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 16) {
            Image(decorative: "premium")
                .resizable()
                .frame(width: 48, height: 48)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Upgrade to Premium")
                    .foregroundColor(.black)
                    .font(.subheadline.bold())
                
                Text("Become a premium user to get access to all the latest features.")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 28))
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .gray.opacity(0.2), radius: 12, x: 0, y: 6)
        .onTapGesture {
            onTap?()
        }
        .accessibilityElement(children: .combine)
        .accessibility(addTraits: .isButton)
    }
}
