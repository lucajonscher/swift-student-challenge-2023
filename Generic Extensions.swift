//
//  GenericExtensions.swift
//  SSC23
//
//  Created by Luca Jonscher on 07.04.23.
//
//  MARK: Extensions to generic Swift types
//

import Foundation
import SwiftUI

extension Int {
    /// Adds a plus sign to the integer, meaning "equal or more."
    ///
    /// For instance, `1.plus` returns `"1+"`.
    var plus: String {
        "\(self)+"
    }
    
    /// Formats the integer as a Euro value.
    ///
    /// For instance, `12345.currency` returns `"€12,345.00"` in an US-English, and `"12.345,00 €"` in a German locale.
    var currency: String {
        self.formatted(.currency(code: "EUR"))
    }
    
    /// Formats the integer as a Euro value, labeled as a minimum value.
    ///
    /// For instance, `12345.minCurrency` returns `"min. €12,345.00"` in an US-English, and `"min. 12.345,00 €"` in a German locale.
    var minCurrency: String {
        "min. \(self.currency)"
    }
}

extension Color {
    /// An orangish brown color that is suitable for usage in the company form graphic.
    ///
    /// Contrary to `.brown`, this color is more in-line with other system colors like `.yellow` or `.orange`.
    static var orangeBrown = Color("Orange Brown")
}
