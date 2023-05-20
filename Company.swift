//
//  Company.swift
//  LucaHendrikJonscherSSC23
//
//  Created by Luca Jonscher on 05.04.23.
//
// MARK: The company data structure
//

import Foundation
import SwiftUI

/// `Company` encapsulates the information about a German form of company, e.g., a GmbH.
struct Company: Identifiable, Hashable {
    static func == (lhs: Company, rhs: Company) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    var id = UUID()
    /// The company’ official abbreviation, if available.
    var abbreviation: String?
    /// The company’s official German name.
    var name: String
    /// The English translation of the company’s name.
    var translation: String
    /// The optional reason, purpose, or objective of a company.
    var reason: String? = nil
    /// An optional bit of information that is important about the company.
    var tidbit: String? = nil
    /// The structure describes how the company’s management, shareholders, liability, and capital is structured.
    ///
    /// A company’s structure is defined with a declarative syntax:
    /// ``` swift
    /// Company(…) {
    ///     SupervisoryBoard() // the company has a supervisory board at its top
    ///     Row { // the management and the shareholders are on the same "level"
    ///         Management(.board) // the company has a board as its management
    ///            .unlimitedLiability() // the board has unlimited liability
    ///         Shareholder(min: 2) // the company needs at least 2 shareholder
    ///            .limitedLiability() // the shareholders have limited liability
    ///     }
    ///     Capital(min: 10000) // the company needs at least 10.000 € in capital
    /// }
    /// ```
    /// The syntax resembles the company form graphic.
    ///
    /// A `Row` combines multiple layers to the same level. Specify liability by using `.limitedLiability()` and `.unlimitedLiability()`.
    @CompanyStructureBuilder var structure: [any CompanyStructure]
}

extension Company {
    /// The title of the company for the company info graphic.
    ///
    /// If an abbreviation is unavailable, the German name is used instead.
    var title: String {
        if let abbreviation {
            return abbreviation
        }
        return name
    }
    
    /// The title of the company. Lengthy parts are removed. Do not use where the accurate abbreviation is of importance.
    ///
    /// If an abbreviation is unavailable, the German name is used instead.
    /// As of now, only the “(haftungsbeschränkt)” for UGs und gUGs is removed.
    var shortenedTitle: String {
        if let abbreviation {
            return abbreviation.replacingOccurrences(of: " (haftungsbeschränkt)", with: "")
        }
        return name
    }
    
    /// The German subtitle for the company info graphic.
    ///
    /// If the company has no abbreviation (and thus, their name is used in the title), the subtitle returns `nil`.
    var subtitle: String? {
        if abbreviation == nil {
            return nil
        }
        return name
    }
    
    /// Determines if a `Company` is being searched by the user.
    /// - Parameters:
    ///  - query: The search query that the user is inputting.
    ///  - includeAlternateVersions: Whether the alternate version of a company should be included in determining, if the company is a search result.
    /// - Returns: A boolean value indicating if the company is a search result.
    func isSearchResult(_ query: String, includeAlternateVersion: Bool) -> Bool {
        var array: [String?] = [name, abbreviation, translation, reason, tidbit]
        
        if includeAlternateVersion, let alt = self.alternateStructure()?.1 {
            array.append(contentsOf: [alt.name, alt.abbreviation, alt.translation, alt.reason, alt.title])
        }
        
        for i in array {
            if let i, i.localizedCaseInsensitiveContains(query) {
                return true
            }
        }
        
        return false
    }
    
    /// Some companies have an alternate structure.
    /// - Parameter bool: Use to conditionally enable or disable this feature. If disabled, it always returns `nil`. The default is `true`.
    /// - Returns: When the company has an alternate structure and `bool` is `true`, it returns a tuple containing the company (`.0`) and its alternate structure (`.1`). Otherwise returns `nil`.
    func alternateStructure(_ bool: Bool = true) -> (Company, Company)? {
        if let interim = companiesWithAlternateStructure.first(where: {
            $0.key == self && bool
        }) {
            return (interim.key, interim.value)
        }
        return nil
    }
}

/// Create a company’s structure with declarative, visual syntax.
@resultBuilder
struct CompanyStructureBuilder {
    static func buildBlock(_ components: any CompanyStructure...) -> [any CompanyStructure] {
        components
    }
    
    static func buildArray(_ components: [[any CompanyStructure]]) -> [any CompanyStructure] {
        var interim = [any CompanyStructure]()
        for component in components {
            interim.append(contentsOf: component)
        }
        return interim
    }
}

extension [Company] {
    /// Adds all variants of the companies in the array to it.
    ///
    /// Company type variants are forms of a company that have different liability or company structure.
    /// - Parameter bool: Whether to add the variants or not.
    /// - Returns: The array of companies with or without added variants.
    func addVariants(_ bool: Bool) -> [Company] {
        if bool {
            var array = self
            for (key, value) in companiesWithAlternateStructure {
                if let index = array.firstIndex(of: key) {
                    array.insert(value, at: index + 1)
                }
            }
            return array
        }
        return self
    }
}

