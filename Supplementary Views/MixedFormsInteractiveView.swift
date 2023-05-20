//
//  MixedFormsInteractiveView.swift
//  
//
//  Created by Luca Jonscher on 17.04.23.
//

import Foundation
import SwiftUI

/// A view that lets the user try out different mixed company variations.
struct MixedFormsInteractiveView: View {
    // The most common and known mixed company—GmbH & Co. KG—is used as the default
    @State private var base = KG
    @State private var insertion = GmbH
        
    @ViewBuilder var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Picker(selection: $insertion) {
                            ForEach([KG, EWIV, UG, gUG, GmbH, gGmbH, GmbH_Co_KG, KGaA, AG, gAG, SE, eG, SCE, foundation, eV]) { company in
                                Text(company.shortenedTitle).tag(company)
                            }
                        } label: {
                            Text("Insertion Company")
                        }
                        .pickerStyle(.menu)
                        .padding(2)
                        .background(
                            RoundedRectangle(cornerRadius: 6, style: .continuous).foregroundColor(Color(UIColor.systemGray6))
                        )
                        Text("& Co.")
                        Picker(selection: $base) {
                            ForEach([OHG, KG, UG, gUG, GmbH, gGmbH, KGaA, AG, gAG, SE]) { company in
                                Text(company.shortenedTitle).tag(company)
                            }
                        } label: {
                            Text("Base Company")
                        }
                        .pickerStyle(.menu)
                        .padding(2)
                        .background(
                            RoundedRectangle(cornerRadius: 6, style: .continuous).foregroundColor(Color(UIColor.systemGray6))
                        )
                    }
                    Text("While most of these mixed forms are not used in practice (and mostly without benefit), it would theoretically be possible to create them.")
                        .footnote()
                }.scenePadding()
                CompanyView(company: mixCompanies(base: base, insertion: insertion))
            }
            .navigationTitle("Mixed Forms Builder")
            .dismissable()
        }
    }
    
    /// Inserts a company as management or shareholder into another company.
    /// - Parameters:
    ///   - base: The company where the other company is inserted into.
    ///   - insertion: The company that is inserted into the other company.
    /// - Returns: The base company with the other company inserted into it. Whether the company is inserted as management or shareholder is dependent on the base company.
    func mixCompanies(base: Company, insertion: Company) -> Company {
        /// The interim company that combines the base and the insertion company.
        ///
        /// It combines the abbreviation, the German name, and the English translation with “& Co.”. The reason, if available, of the base company is used. Tidbits get removed. Initially, the structure is empty.
        var interim = Company(abbreviation: "\(insertion.title) & Co. \(base.title)", name: "\(insertion.name) & Co. \(base.name)", translation: "\(insertion.translation) & Co. \(base.translation)", reason: base.reason, tidbit: nil) {}
        
        var structure: [any CompanyStructure] = base.structure
        
        /// Whether the company is inserted into a management or shareholder level.
        ///
        /// Some base companies do not have a management layer, thus, the other company is inserted into the shareholder level
        let replacementRole: InsertedCompany.CompanyRole = [OHG, gUG, UG, gGmbH, GmbH].contains(base) ? .shareholder : .management
                
        // Iterates over every layer in the base company’s structure
        for index in structure.indices {
            /// The layer of the current index.
            let item = structure[index]
            
            // The inserted company never replaces a supervisory board
            if let _ = item as? SupervisoryBoard {
                continue
            }
            
            // The layer is a CompanyLayer
            if let layer = item as? any CompanyLayer {
                // Dependent on the role, this mechanism checks for Management respectively Shareholder; Capital and Stocks are irrelevant
                if (replacementRole == .management) ? layer is Management : layer is Shareholder {
                    // Only layers with liability can be replaced by a company
                    if let liability = layer.liability {
                        // The second company is being inserted
                        structure.insert(InsertedCompany(insertion, replacementRole).liability(liability), at: index)
                        // The original layer gets removed
                        structure.remove(at: index + 1)
                        break
                    }
                    continue
                }
                continue
            }
            
            // The layer is a Row, thus each layer of the Row has to be checked
            if var row = item as? Row {
                // Iterates over every layer in the Row’s structure
                for rowIndex in row.layers.indices {
                    if let layer = row.layers[rowIndex] as? any CompanyLayer {
                        // Dependent on the role, this mechanism checks for Management respectively Shareholder; Capital and Stocks are irrelevant
                        if (replacementRole == .management) ? layer is Management : layer is Shareholder {
                            // Only layers with liability can be replaced by a company
                            if let liability = layer.liability {
                                // The second company is being inserted
                                row.layers.insert(InsertedCompany(insertion, replacementRole).liability(liability), at: rowIndex)
                                // The original layer gets removed
                                row.layers.remove(at: rowIndex + 1)
                                
                                // The updated Row is being inserted
                                structure.insert(row, at: index)
                                // The original Row gets removed
                                structure.remove(at: index + 1)
                                break
                            }
                            continue
                        }
                        continue
                    }
                    continue
                }
            }
        }
                            
        // Adds the new structure to the interim company
        interim.structure = structure
        
        return interim
    }
}

