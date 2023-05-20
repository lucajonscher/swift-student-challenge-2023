//
//  ContentView.swift
//  LucaHendrikJonscherSSC23
//
//  Created by Luca Jonscher on 05.04.23.
//

import SwiftUI

/// The content of the app playground.
struct ContentView: View {
    @State private var focussedCompany: Company? = nil
    @State private var query = ""
    @State private var searchTokens = [String]()
    @State private var showInfoSheet = false
    @State private var showStatisticSheet = false
    @State private var showAboutMeSheet = false
    @State private var showMixedFormsSheet = false
    
    @AppStorage("ShowNameTranslations") var showNameTranslations = false
    @AppStorage("ContentDisplayStyle") var contentDisplayStyle = 0
    @AppStorage("ShowCompanyVariants") var showCompanyVariants = false
    @AppStorage("DifferentiateWithoutColor") var differentiateWithoutColor = false
    
    /// Each section is one collection of companies.
    ///
    /// Each section is defined as a tuple with
    /// * `.0`: the title of the section,
    /// * `.1`: the optional footer text of the section, and
    /// * `.2`: the collection of companies.
    let sections: [(String, String?, [Company])] = [
        ("Partnerships", "Partnerships are companies, where the focus lies on the partner’s connection and their respective liability.", partnerships),
        ("Corporations", "Corporations are structured around their capital (which may be divided into stocks).", corporations),
        ("Cooperatives", "Cooperatives are a union of people, who have a joint economic business operation that support the member’s aims.", cooperatives),
        ("Other", nil, other),
        ("Mixed Forms (Examples)", "Companies can act as manager or shareholder of another company. For instance, at a GmbH & Co. KG, a GmbH is the complementary of the KG. This enables the benefits of a KG without a person having unlimited liability.", mixedForms)
    ]
    
    var body: some View {
        NavigationView {
            Group {
                if contentDisplayStyle == 0 { // The list view
                        List {
                            ForEach(sections, id: \.0) { (title, footer, companies) in
                                Section(header: Text(title), footer: FooterView(text: footer, showMixedFormsSheet: $showMixedFormsSheet)) {
                                    ForEach(companies.addVariants(showCompanyVariants).filter {
                                        query == "" || $0.isSearchResult(query, includeAlternateVersion: !showCompanyVariants)
                                    }, id: \.id) { company in
                                        Button(action: {
                                            focussedCompany = company
                                        }) {
                                            BadgedView(showNameTranslations ? company.translation : company.name, company.abbreviation)
                                        }.buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                        .headerProminence(.increased)
                } else if contentDisplayStyle == 1 { // The carousel view
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(sections, id: \.0) { (title, footer, companies) in
                                CarouselSectionView(title: title, footer: footer, companies: companies, showMixedFormsSheet: $showMixedFormsSheet, focussedCompany: $focussedCompany, query: $query)
                            }
                        }
                        Text("Tap each scheme to view the detailed version.").footnote()
                    }
                }
            }
            .searchable(text: $query)
            .navigationTitle("Company Types (DE)")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Toggle(isOn: $showNameTranslations) {
                            Label("Translate Names", systemImage: "textformat.alt")
                        }
                        Toggle(isOn: $showCompanyVariants) {
                            Label("Show Company Variants", systemImage: "square.on.square")
                        }
                        Toggle(isOn: $differentiateWithoutColor) {
                            Label("Differentiate Without Color", systemImage: "square.dashed.inset.filled")
                        }
                        Picker("Display Style", selection: $contentDisplayStyle) {
                            Label("List", systemImage: "list.bullet").tag(0)
                            Label("Carousel", systemImage: "square.grid.3x1.below.line.grid.1x2").tag(1)
                        }
                    } label: {
                        Image(systemName: "gear")
                            .accessibilityLabel("Settings")
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAboutMeSheet = true
                    }) {
                       Image(systemName: "person.fill")
                            .accessibilityLabel("About Me")
                    }.sheet(isPresented: $showAboutMeSheet) {
                        AboutMeView()
                    }
                    Button(action: {
                        showStatisticSheet = true
                    }) {
                       Image(systemName: "chart.bar.xaxis")
                            .accessibilityLabel("Statistics")
                    }.sheet(isPresented: $showStatisticSheet) {
                        StatisticView()
                    }
                    Button(action: {
                        showInfoSheet.toggle()
                    }) {
                        Image(systemName: "info.circle.fill")
                            .accessibilityLabel("Information")
                    }.sheet(isPresented: $showInfoSheet) {
                        InfoView()
                    }
                }
            }
        }.navigationViewStyle(.stack)
        .sheet(item: $focussedCompany) { company in
            CompanyViewContainer(company: company, focussedCompany: $focussedCompany)
                .sheetStyle()
        }.sheet(isPresented: $showMixedFormsSheet) {
            // Workaround, because if the sheet is placed inside FooterView(), and that is placed inside a list section footer, the sheet has footer style applied to it
            MixedFormsInteractiveView()
        }
    }
    
    /// A view that displays the companies in a horizontal scrolling view with their simplified info views.
    struct CarouselSectionView: View {
        var title: String
        var footer: String?
        var companies: [Company]
        
        @Binding var showMixedFormsSheet: Bool
        @Binding var focussedCompany: Company?
        @Binding var query: String
        
        @AppStorage("ShowCompanyVariants") var showCompanyVariants = false
        
        @ViewBuilder var body: some View {
            VStack(alignment: .leading) {
                NavigationLink(destination: ScrollContentView(companies: companies).navigationTitle(title)) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(title)
                        Image(systemName: "chevron.forward")
                            .imageScale(.small)
                            .foregroundColor(.secondary)
                    }
                }
                .buttonStyle(.plain)
                .font(.title)
                .scenePadding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: universalSpacing * 2) {
                        ForEach(companies.addVariants(showCompanyVariants).filter {
                            query == "" || $0.isSearchResult(query, includeAlternateVersion: !showCompanyVariants)
                        }, id: \.id) { company in
                            Button(action: {
                                focussedCompany = company
                            }) {
                                SimplifiedCompanyView(company: company)
                            }.buttonStyle(.plain)
                        }
                    }.scenePadding(.horizontal)
                }
                FooterView(text: self.footer, showMixedFormsSheet: $showMixedFormsSheet)
                    .scenePadding()
                    .conditionally(if: footer != nil) {
                        Text("").padding(.bottom, 18)
                    }
            }
            .background(LinearGradient(colors: [.clear, .secondary.opacity(0.05)], startPoint: .top, endPoint: .bottom))
            .padding(.top, 6)
        }
    }
    
    /// A view that displays the companies in a vertical scrolling view with their company info views.
    struct ScrollContentView: View {
        var companies: [Company]
        
        @State private var query = ""
        
        @AppStorage("ShowCompanyVariants") var showCompanyVariants = false
        
        @ViewBuilder var body: some View {
            ScrollView {
                VStack(alignment: .center) {
                    let companies = companies.addVariants(showCompanyVariants).filter {
                        query == "" || $0.isSearchResult(query, includeAlternateVersion: !showCompanyVariants)
                    }
                    ForEach(companies, id: \.id) { company in
                        Divider()
                            .padding(.vertical)
                            .conditionally(if: company != companies[0])
                        CompanyView(company: company)
                    }
                }
            }.searchable(text: $query)
        }
    }
    
    /// A view that is placed in the footer of a list section or a carousel section.
    struct FooterView: View {
        var text: String?
        @Binding var showMixedFormsSheet: Bool
        
        // the footers are hidden when the user is searching; this creates a smoother and less cluttered search experience
        @Environment(\.isSearching) private var isSearching
        
        @ViewBuilder var body: some View {
            if let text, !isSearching {
                VStack(alignment: .leading) {
                    Text(text)
                        .footnote()
                    
                    Button(action: {
                        showMixedFormsSheet = true
                    }) {
                        Text("Show Mixed Forms Builder")
                            .font(.callout)
                            .padding(.top, 8)
                    }.conditionally(if: text.hasPrefix("Companies can act"))
                }
            }
        }
    }
}

