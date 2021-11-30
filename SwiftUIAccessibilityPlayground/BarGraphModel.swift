//
//  BarGraphModel.swift
//  SwiftUIAccessibilityPlayground
//
//  Created by Ryan Cole on 11/22/21.
//

import Foundation

struct BarGraphEntry: Identifiable {
    let id: UUID = UUID()
    let label: String
    let value: Int
}

class BarGraphModel {
    var title: String
    var entries: [BarGraphEntry]
    
    init() {
        title = "Unprovoked fatal shark attacks per year"
        entries = [
            .init(label: "2011", value: 13),
            .init(label: "2012", value: 7),
            .init(label: "2013", value: 10),
            .init(label: "2014", value: 3),
            .init(label: "2015", value: 6),
            .init(label: "2016", value: 4),
            .init(label: "2017", value: 5),
            .init(label: "2018", value: 4),
            .init(label: "2019", value: 2),
            .init(label: "2020", value: 10)
        ]
    }
}
