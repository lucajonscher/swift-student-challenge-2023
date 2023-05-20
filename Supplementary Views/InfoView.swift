//
//  InfoView.swift
//  
//
//  Created by Luca Jonscher on 17.04.23.
//

import Foundation
import SwiftUI

/// Explains the company info graphic and each layer.
struct InfoView: View {
    @ViewBuilder var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    CompanyView(company: explanatoryCompany)
                    Text("Tap each layer to get additional information")
                        .footnote()
                        .frame(maxWidth: .infinity, alignment: .center)
                    Divider().scenePadding(.vertical)
                    Group {
                        Text("Liability").font(.headline)
                        Label {
                            Text("Unlimited Liability")
                        } icon: {
                            LiabilityView(unlimited: true).frame(width: 60)
                        }.padding(.vertical, 14)
                        Label {
                            Text("Limited Liability")
                        } icon: {
                            LiabilityView(unlimited: false).frame(width: 60)
                        }
                    }
                    LayerExplanationView(title: "Management", layers: management)
                    LayerExplanationView(title: "Shareholders", layers: shareholders)
                    Text("When there is no separate management, the shareholders form the management.").footnote().padding(.top)
                    LayerExplanationView(title: "Capital", layers: capital)
                }.scenePadding()
            }
            .navigationTitle("Explanation")
            .dismissable()
        }
    }
    
    /// All management layers.
    var management: [any CompanyLayer] {
        var array: [any CompanyLayer] = [SupervisoryBoard()]
        array.append(contentsOf: Management.ManagementType.allCases.filter { $0 != .managementStructure }.map {
            Management($0)
        })
        return array
    }
    
    /// All shareholder layers.
    var shareholders: [any CompanyLayer] {
        var array = [any CompanyLayer]()
        array.append(contentsOf: Shareholder.ShareholderType.allCases.filter { $0 != .shareholderStructure }.map {
            Shareholder($0)
        })
        return array
    }
    
    /// All capital layers.
    var capital: [any CompanyLayer] {
        var array = [any CompanyLayer]()
        array.append(contentsOf: Capital.CapitalType.allCases.filter { $0 != .capitalStructure }.map {
            Capital($0)
        })
        array.append(Stocks())
        return array
    }
       
    /// A view that displays company layers in a vertical stack.
    struct LayerExplanationView: View {
        var title: String
        var layers: [any CompanyLayer]
        
        @ViewBuilder var body: some View {
            Divider().scenePadding(.vertical)
            Text(title).font(.headline)
            VStack(spacing: 14) {
                ForEach(layers, id: \.id) { layer in
                    layer.body.typeErased
                }
            }
        }
    }
}
