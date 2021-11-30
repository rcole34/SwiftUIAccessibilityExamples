//
//  ContentView.swift
//  SwiftUIAccessibilityPlayground
//
//  Created by Ryan Cole on 7/19/21.
//

import SwiftUI

/**
 * The entry point for our SwiftUI app, we use this content view to display the hook and counter, and to respond to taps on the hook.
 * For the sake of this demo, the hook will display a pop-up that is currently not very accessible because the main way for a non-VoiceOver user to dismiss it is to tap in the background, which is not an accessibility element.
 */
struct ContentView: View {
    @State var showModal: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                HookView(onTap: {
                    showModal = true
                }).padding()
                CounterView()
                if #available(iOS 15.0, *) {
                    BarGraphView()
                        .frame(height: 256)
                }
                Spacer()
            }
            
            if showModal {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showModal = false
                    }
                
                VStack(alignment: .trailing, spacing: 0) {
                    Text("You tapped the hook for premium — way to go with taking the first step towards a premium experience!")
                        .foregroundColor(.black)
                        .font(.body)
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(12)
                .padding()
            }
        }.animation(.easeIn(duration: 1), value: showModal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}















































/**
 * To improve the accessibility of our modal pop-up we first want to make sure that users cannot still interact with elements other than the modal. My understanding was that the `.accessibility(addTraits: .isModal)` modifier on the modal `Text` should do that, but it wasn't working for me, so instead we can add an `.accessibility(hidden:)` modifier to the `VStack` with the other content on the page and set it equal to `showModal` to hide those elements when the modal is showing.
 * We can also add a `didSet` to the `showModal` variable to post a UIAccessibility `screenChanged` notification. This will cause VoiceOver to play a sound to notify the user that the content on the screen has changed. You'll notice this is the same sound that plays by default when you open an app, navigate between pages in a navigation view, etc.
 * Now however, we have no way of dismissing the modal because the background is not an accessibility element. As a general UX principal it would probably be good to add some button on the modal to accomplish this, but for the purpose of this demo we're going to stay button-less. Instead of making the background an accessibility element, we can add a custom accessibility action with the `.accessibilityAction` modifier. By passing a name to this modifier, VoiceOver will inform the user that there are actions available and the user can swipe up/down to select the action. Alternatively (or in addition to) we should add an action for the `.escape` accessibility gesture (swiping with 2 fingers in a Z-shape) to have that gesture dismiss the modal.
 * If we decided we did want to add a button, but only for VoiceOver users, we could listen to the `\.accessiblityEnabled` environment variable to conditionally add a dismiss button. Even then, it's good practice to still support at least the `.escape` modifier.
 * Another accessibility trait users can set that's easy for us to respect here is `accessibilityReduceMotion`. When this is set, we should minimize motion and animations on the screen. We can add an environment variable for that, and reduce the animation time when that is enabled.
 */
struct AccessibleContentView: View {
    @State var showModal: Bool = false {
        didSet {
            UIAccessibility.post(notification: .screenChanged, argument: nil)
        }
    }
    
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                AccessibleHookView(onTap: {
                    showModal = true
                }).padding()
                AccessibleCounterView()
                if #available(iOS 15.0, *) {
                    AccessibleBarGraphView()
                        .frame(height: 256)
                }
                Spacer()
            }.accessibility(hidden: showModal)
            
            if showModal {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showModal = false
                    }
                    
                VStack(alignment: .trailing, spacing: 0) {
                    if accessibilityEnabled && UIAccessibility.isVoiceOverRunning {
                        Button(action: { showModal = false }) {
                            Image("black-cross-icn")
                                .padding(16)
                                .accessibility(label: Text("Close alert"))
                        }
                    }
                    Text("You tapped the hook for premium — way to go with taking the first step towards a premium experience!")
                        .foregroundColor(.black)
                        .font(.body)
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(12)
                .padding()
                .accessibility(addTraits: .isModal)
                .accessibilityAction(named: Text("Dismiss modal"), {
                    showModal = false
                })
                .accessibilityAction(.escape, {
                    showModal = false
                })
            }
        }.animation(.easeIn(duration: reduceMotion ? 0.1 : 1), value: showModal)
    }
}
