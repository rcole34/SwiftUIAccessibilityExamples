//
//  BarGraphView.swift
//  SwiftUIAccessibilityPlayground
//
//  Created by Ryan Cole on 11/22/21.
//

import SwiftUI

// limited to iOS 15 availability since we'll be adding audio graph support
@available(iOS 15.0, *)
struct BarGraphView: View {
    let model: BarGraphModel = BarGraphModel()
    private var maxValue: Int {
        model.entries.map(\.value).max() ?? 10
    }
    
    var body: some View {
        VStack {
            Text(model.title)
                .foregroundColor(.black)
                .font(.headline)
            
            GeometryReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom) {
                        ForEach(model.entries) { entry in
                            VStack {
                                Spacer()
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundColor(.blue)
                                    .frame(width: 48, height: (proxy.size.height - 48) * CGFloat(entry.value) / CGFloat(maxValue))
                                
                                Text(entry.label)
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .fixedSize()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

@available(iOS 15.0, *)
struct BarGraphView_Previews: PreviewProvider {
    static var previews: some View {
        BarGraphView()
    }
}







































/**
 * The existing version of this bar graph view is pretty much worthless when running it with VoiceOver. All we get is the title and the years, as the height of each bar is purely visual.
 * To start, we can group each bar into a single accessibility element so VoiceOver highlights the entire bar. Then, we can add a custom label that describes both the label (the year) and the value (the number of fatal shark attacks).
 * Now it's time to get fancy and take advantage of a new feature in iOS 15: audio graphs. To make an audio graph, we must first make the view conform to the `AXChartDescriptorRepresentable` protocol, which requires one function to be implemented: `makeChartDescriptor()`. This function returns a `AXChartDescriptor`, which requires us to build descriptors for each axis and for the data. As long as we already have our data points in a manageable format, it is straightforward to create these descriptors from the data. The last thing we need to do is to add the `.accessibilityChartDescriptor(self)` modifier to the view. Now when we navigate to the graph with VoiceOver, we hear audio graph options and can play an audio version of the data, and get some automated statistics about the data.
 * Another nice-to-have addition here is to add the `.accessibility(addTraits: .isHeader)` modifier to the title of the graph. Marking section headings with the header trait allows VoiceOver users to easily jump between sections and not need to manually swipe through extensive elements just to get to the content they are interested in.
 */
@available(iOS 15.0, *)
struct AccessibleBarGraphView: View {
    let model: BarGraphModel = BarGraphModel()
    private var maxValue: Int {
        model.entries.map(\.value).max() ?? 10
    }
    
    var body: some View {
        VStack {
            Text(model.title)
                .foregroundColor(.black)
                .font(.headline)
                .accessibility(addTraits: .isHeader)
            
            GeometryReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom) {
                        ForEach(model.entries) { entry in
                            VStack {
                                Spacer()
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundColor(.blue)
                                    .frame(width: 48, height: (proxy.size.height - 48) * CGFloat(entry.value) / CGFloat(maxValue))
                                
                                Text(entry.label)
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .fixedSize()
                            }
                            .accessibilityElement()
                            .accessibility(label: Text("\(entry.value) fatal shark attacks in \(entry.label)"))
                            .accessibilityChartDescriptor(self)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

@available(iOS 15.0, *)
extension AccessibleBarGraphView: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Year",
            categoryOrder: model.entries.map(\.label)
        )

        let minValue: Double = Double(model.entries.map(\.value).min() ?? 0)

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Number of fatal shark attacks",
            range: minValue...Double(maxValue),
            gridlinePositions: []
        ) { value in "\(value) fatal shark attacks" }

        let series = AXDataSeriesDescriptor(
            name: model.title,
            isContinuous: false,
            dataPoints: model.entries.map {
                .init(x: $0.label, y: Double($0.value))
            }
        )

        return AXChartDescriptor(
            title: model.title,
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }
}
