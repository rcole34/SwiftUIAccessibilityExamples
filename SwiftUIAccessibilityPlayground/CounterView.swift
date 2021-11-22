//
//  CounterView.swift
//  SwiftUIAccessibilityPlayground
//
//  Created by Ryan Cole on 7/19/21.
//

import SwiftUI

/**
 * A basic counter control with buttons to increment and decrement the count on either side of a label displaying said count.
 * Here we have already made a possible pass at improving accessibility by adding accessibility labels to the -" and "+" buttons to better describe what the buttons do.
 * We'll take another pass to see how we can further improve accessibility using the `accessibilityAdjustableAction` modifier to treat this as a single control.
 */
struct CounterView: View {
    @State var count: Int = 0
    var body: some View {
        HStack {
            Button(action: { count -= 1 }) {
                Text("-")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Color.blue)
            .cornerRadius(8)
            Spacer()
            Text("Count: \(count)")
                .foregroundColor(.red)
                .font(.title)
            Spacer()
            Button(action: { count += 1 }) {
                Text("+")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Color.blue)
            .cornerRadius(8)
        }.padding(24)
        .accessibilityElement(children: .ignore)
        .accessibility(label: Text("Count"))
        .accessibility(value: Text("\(count)"))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                count += 1
            case .decrement:
                count -= 1
            @unknown default:
                break
            }
        }
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView()
            
    }
}














































/**
 * With the accessibility labels for the buttons to describe their functions better than "hyphen" and "plus", this component is at least usable from an accessibility perspective. However, there is a lot we can do to make it even better. This component should be treated as a single control. If you have used VoiceOver before, you may be familiar with how controls are commonly treated — VoiceOver reads a label and the current value, and then lets you know that you can swipe up or down to adjust the value. This may sound complicated, but accessibility modifiers make it easy to implement.
 * First, let's get rid of the individual accessibility labels for the buttons and tell VoiceOver to treat the whole thing as one element with the `.accessibilityElement()` modifier Note this uses the default value of `.ignore` for the `children` parameter so we'll need to specify a new accessibility label to use.
 * We'll make the label for this just "Count" and then make the accessibility value be the current count, using `.accessibility(label: Text("Count"))` and `.accessibility(value: Text("\(count)"))`. To support the swipe up/down to adjust behavior, we use the `accessibilityAdjustableAction` modifier to handle both kinds of swipes.
 * Like with the hook, we can also use dynamic type instead of hardcoded font sizes to make sure our text scales according to user preferences.
 */
struct AccessibleCounterView: View {
    @State var count: Int = 0
    var body: some View {
        HStack {
            Button(action: { count -= 1 }) {
                Text("-")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Color.blue)
            .cornerRadius(8)
            Spacer()
            Text("Count: \(count)")
                .foregroundColor(.red)
                .font(.title)
            Spacer()
            Button(action: { count += 1 }) {
                Text("+")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Color.blue)
            .cornerRadius(8)
        }.padding(24)
        .accessibilityElement()
        .accessibility(label: Text("Count"))
        .accessibility(value: Text("\(count)"))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: count += 1
            case .decrement: count -= 1
            @unknown default: break
            }
        }
    }
}
