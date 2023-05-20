//
//  StatisticsView.swift
//  
//
//  Created by Luca Jonscher on 17.04.23.
//

import Foundation
import SwiftUI
import Charts

/// A view that shows statistics about German company types.
struct StatisticView: View {
        
    /// The dataset for the prevalence of different types of companies in Germany.
    let data = [
        "Sole Proprietor": 59.2,
        "Corporations": 23.2,
        "Partnerships": 12.1,
        "Other": 5.4
    ]
    
    /// The dataset for the prevalence of company types in the German trade register.
    let data2 = [
        "GmbH": 79,
        "UG (haftungsbeschränkt)": 9.5,
        "e. K.": 6.4,
        "KG": 1.5,
        "PartG": 1.1,
        "OHG": 1.1,
        "AG, SE, KGaA": 0.9,
        "e. G.": 0.5,
        "Foundation": 0.05,
        "EWIV": 0.02,
        "KöR*": 0.02
    ]
    
    @ViewBuilder var body: some View {
        NavigationView {
            ScrollView {
                if #available(iOS 16.0, *) {
                     VStack {
                         VStack(alignment: .leading, spacing: 10) {
                             Text("Company Types").font(.headline)
                            Chart(data.sorted { $0.value > $1.value }, id: \.key) { datum in
                                BarMark(
                                    x: .value("Category", datum.key),
                                    y: .value("Percentage", datum.value)
                                ).annotation {
                                    Text((datum.value / 100).formatted(.percent)).font(.callout).foregroundStyle(Color.accentColor)
                                }
                            }
                            .foregroundStyle(Color.accentColor)
                            .chartYAxis {
                                AxisMarks(format: Decimal.FormatStyle.Percent.percent.scale(1), values: .automatic(desiredCount: 5))
                            }
                            .chartYScale(domain: [0, 100])
                            .frame(minHeight: 300)
                             Text("Source: Statistisches Bundesamt (as of 2021)").footnote()
                        }
                         Divider().padding(.vertical)
                         VStack(alignment: .leading, spacing: 10) {
                             Text("Companies in the Trade Register").font(.headline)
                            Chart(data2.sorted { $0.value > $1.value }, id: \.key) { datum in
                                BarMark(
                                    x: .value("Percentage", datum.value),
                                    y: .value("Company Type", datum.key)
                                ).annotation(position: .trailing) {
                                    Text((datum.value / 100).formatted(.percent)).font(.callout).foregroundStyle(Color.accentColor)
                                }
                            }
                            .foregroundStyle(Color.accentColor)
                            .chartXAxis {
                                AxisMarks(format: Decimal.FormatStyle.Percent.percent.scale(1), values: .automatic(desiredCount: 5))
                            }
                            .chartXScale(domain: [0, 100])
                            .frame(minHeight: 500)
                             Text("Source: Listflix (as of 2023)").footnote()
                             Text("* Körperschaft des öffentlichen Rechts (Corporation of Public Law)")
                        }
                     }.scenePadding()
                } else {
                    Text("This view is unavailable. Please update your device to iOS/iPadOS 16.")
                }
            }
            .navigationTitle("Statistics")
            .dismissable()
        }
    }
}

