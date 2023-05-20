//
//  CompanyView.swift
//  LucaHendrikJonscherSSC23
//
//  Created by Luca Jonscher on 05.04.23.
//
//  MARK: Creates the company info graphic
//

import SwiftUI

/// The company info view for the company, including the company’s abbreviation and name, the company form, and its reason.
struct CompanyView: View {
    var company: Company
    
    @AppStorage("ShowNameTranslations") var showNameTranslations = false
    
    var body: some View {
            VStack {
                Text(company.title).font(.largeTitle).bold().padding(.bottom, 2)
                Group {
                    if let subtitle = company.subtitle {
                        Button(action: {
                            showNameTranslations.toggle()
                        }) {
                            Text(showNameTranslations ? company.translation : subtitle)
                        }.buttonStyle(.plain)
                    } else {
                        Text(company.translation)
                    }
                }.fixedSize(horizontal: false, vertical: true)
                company.body
                if let reason = company.reason {
                    VStack(spacing: 10) {
                        Image(systemName: "chevron.compact.down").imageScale(.large)
                        Text(reason).bold()
                    }.padding(.top, 8)
                }
                Spacer()
            }
            .scenePadding()
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.bottom)
    }
}

/// The simplified company info graphic, including the simplified company form and the company’s abbreviation.
struct SimplifiedCompanyView: View {
    var company: Company
    
    @ViewBuilder var body: some View {
        VStack {
            Text(company.title)
                .font(.headline)
                .bold()
                .padding(.bottom, 2)
            company.simplifiedBody
        }
    }
}

/// The container view that displays the company info view.
struct CompanyViewContainer: View {
    /// Sets the appearance of the page indicator.
    func setup() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .label
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.label.withAlphaComponent(0.2)
    }
    
    var company: Company
    @Binding var focussedCompany: Company?
    
    @State private var tabView = false
    @State private var showPopover = false
    
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("ShowNameTranslations") var showNameTranslations = false
    @AppStorage("ShowCompanyVariants") var showCompanyVariants = false
    
    @ViewBuilder var body: some View {
        NavigationView {
            Group {
                if let alternateStructure = company.alternateStructure(!showCompanyVariants) {
                    TabView(selection: $tabView) {
                            ScrollView {
                                CompanyView(company: alternateStructure.0)
                            }.tag(false)
                            ScrollView {
                                CompanyView(company: alternateStructure.1)
                            }.tag(true)
                        }.tabViewStyle(.page(indexDisplayMode: .always))
                } else {
                    ScrollView {
                        CompanyView(company: company)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if let info: (String, String) = ({
                        if !tabView {
                            if let tidbit = company.tidbit {
                                return (company.title, tidbit)
                            }
                        } else {
                            if let alternateStructure = company.alternateStructure(), let tidbit = alternateStructure.1.tidbit {
                                return (alternateStructure.1.title, tidbit)
                            }
                        }
                        return nil
                    })() {
                        Button(action: {
                            showPopover = true
                        }) {
                            Image(systemName: "info.circle")
                                .accessibilityLabel("Tidbit")
                        }.popover(isPresented: $showPopover) {
                            PopoverView(title: info.0, text: info.1)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                        focussedCompany = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .font(.title2)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Close")
                }
            }
            .onAppear {
                setup()
            }
        }
    }
}
