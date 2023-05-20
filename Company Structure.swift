//
//  Company Structure.swift
//  SSC23
//
//  Created by Luca Jonscher on 17.04.23.
//

import Foundation
import SwiftUI

// MARK: Company structure protocol

/// An element of a company’s structure.
///
/// There are two relevant types of company structure:
/// * `CompanyLayer`: any structural layer, e.g., management or capital, and
/// * `Row`: combines layers on the same level.
protocol CompanyStructure: Identifiable, Hashable, Equatable {
    associatedtype Content: View
    
    var id: UUID { get set }
    /// The company form graphic that visualizes the company’s structure.
    @ViewBuilder var body: Content { get }
}

extension CompanyStructure {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: Company layer protocol

/// A structural layer of a company in regard to management, shareholders, and capital.
protocol CompanyLayer: CompanyStructure {
    /// The label that is displayed in the company form graphic. It may be different from the layer’s title.
    var label: String { get set }
    /// The color of the background of the layer in the company form graphic.
    var color: Color { get set }
    /// The title that indicates the type of company layer.
    var title: String { get set }
    /// Information about the specific type of company layer.
    var info: String { get set }
    /// Whether the company layer has liability in regard to the company capital attached.
    ///
    /// When `liability = nil`, the layer has no liability. When `liability = true`, the layer has unlimited liability. When `liability = false`, the layer has limited liability.
    var liability: Bool? { get set }
    /// The dash pattern of the layer in the company form graphic. It is visible when the user has enabled Differentiate Without Color, or toggles the setting to differentiate without color.
    ///
    /// Each type of layer (i.e., Supervisory Board, Management, Shareholder, Capital, Stocks, and Physical Assets) needs a differentiable different pattern. Specific types of layer (e.g., shareholder, limited partner, etc.) should not have a different pattern.
    var accessibilityDash: [CGFloat] { get set }
    
    init()
}

extension CompanyLayer {
    /// Initializes the layer with ad hoc information.
    /// - Parameters:
    ///   - label: The label of the layer. It is visible in the company form graphic.
    ///   - title: The title of the layer. It is visible in the information popover.
    ///   - info: The information about the layer. It is visible in the information popover.
    mutating func initialize(label: String, title: String, info: String) {
        self.label = label
        self.title = title
        self.info = info
    }
    
    /// The layer has unlimited liability.
    /// - Returns: The company with added liability information.
    func unlimitedLiability() -> any CompanyLayer {
        self.liability(true)
    }
    
    /// The layer has limited liability.
    /// - Returns: The company with added liability information.
    func limitedLiability() -> any CompanyLayer {
        self.liability(false)
    }
    
    /// Sets the liability of a layer.
    ///
    /// Use only when programmatically creating a company. When hard-coding a company’s structure, solely use `.limitedLiability()` or `.unlimitedLiability()`.
    /// - Parameter liability: Unlimited liability is `true`, limited liability `false`, no liability is `nil`.
    /// - Returns: The company with added liability information.
    func liability(_ liability: Bool?) -> any CompanyLayer {
        var layer = self
        layer.liability = liability
        return layer
    }
}

// MARK: Row

/// `Row` combines multiple company layers on a single level.
struct Row: CompanyStructure {
    static func == (lhs: Row, rhs: Row) -> Bool {
        lhs.id == rhs.id
    }
        
    var id = UUID()
    /// The layers that are placed on the level.
    @CompanyStructureBuilder var layers: [any CompanyStructure]
}

// MARK: Example liability

/// An exemplary layer that explains liability. Only relevant for the info view.
struct ExampleLiability: CompanyStructure {
    var id = UUID()
}

// MARK: Specific company layers

/// A supervisory board is a possible layer of a company’s structure.
///
/// The supervisory board elects and controls the board.
struct SupervisoryBoard: CompanyLayer {
    var id = UUID()
    var label = "Supervisory Board"
    var color = Color.cyan
    var info = "The supervisory board elects and controls the board."
    var title: String
    var liability: Bool? = nil
    var accessibilityDash: [CGFloat] = [5]
    
    /// Sets up a supervisory board company layer.
    init() {
        self.title = label
    }
    
    /// Sets up a supervisory board company layer.
    /// - Parameter label: A custom layer for the layer.
    init(_ label: String) {
        self.init()
        self.label = label
    }
}

/// A shareholder is / shareholders are a possible layer of a company’s structure.
///
/// Shareholder own a share of a company. They may have management rights.
struct Shareholder: CompanyLayer {
    var id = UUID()
    var label = "Shareholder"
    var color = Color.purple
    var info = ""
    var title: String
    var liability: Bool? = nil
    var accessibilityDash: [CGFloat] = [20]
    
    internal init() {
        self.title = label
    }
    
    /// Sets up a shareholder company layer.
    /// - Parameters:
    ///   - type: The type of shareholder.
    ///   - label: An optional label that further describes the type.
    ///
    /// When there is a minimum or fixed amount of shareholders, use `Shareholder.init(_:min:)` or `Shareholder.init(_:fixedAmount:)`.
    init(_ type: ShareholderType = .shareholder, _ label: String? = nil) {
        self.init()
        self.initialize(label: label ?? type.rawValue, title: type.rawValue, info: type.info)
    }
    
    /// Sets up a shareholder company layer.
    /// - Parameters:
    ///   - type: The type of shareholder.
    ///   - label: An optional label that further describes the layer.
    ///   - fixedAmount: An optional label that further describes the type.
    init(_ type: ShareholderType = .shareholder, _ label: String? = nil, fixedAmount: Int) {
        self.init()
        if let label {
            self.initialize(label: "\(label) (\(fixedAmount))", title: type.rawValue, info: type.info)
        } else {
            self.initialize(label: String(fixedAmount), title: type.rawValue, info: type.info)
        }
    }
    
    /// Sets up a shareholder company layer.
    /// - Parameters:
    ///   - type: The type of shareholder.
    ///   - label: An optional label that further describes the layer.
    ///   - min: The minimum amount of shareholders.
    init(_ type: ShareholderType = .shareholder, _ label: String? = nil, min: Int) {
        self.init()
        if let label {
            self.initialize(label: "\(label) (\(min.plus))", title: type.rawValue, info: type.info)
        } else {
            self.initialize(label: min.plus, title: type.rawValue, info: type.info)
        }
    }
    
    /// The specific type of shareholder.
    enum ShareholderType: String, CaseIterable {
        /// A shareholder owns equity in a company.
        ///
        /// This is the default
        case shareholder = "Shareholder"
        /// A limited partner is only liable with their deposits. However, they have no right to manage the company.
        case limitedPartner = "Limited Partner"
        /// A stockholder is a shareholder of a company, which’s capital is divided into stocks. The whole of stockholders form the general assembly.
        case stockholder = "Stockholder"
        /// A person that provided assets to a cooperative.
        case cooperativeMember = "Cooperative Member"
        /// A person that holds membership of a club.
        case clubMember = "Club Member"
        /// A person that gains insurance.
        case policyholder = "Policyholder"
        /// Example type that explains shareholder structure. Only relevant for the info view.
        case shareholderStructure = "Shareholder Structure"
        
        /// The information about the shareholder. It is visible in the information popover.
        var info: String {
            switch self {
            case .shareholder: return "A shareholder owns equity in a company."
            case .limitedPartner: return "A limited partner is only liable with their deposits. However, they have no right to manage the company."
            case .stockholder: return "A stockholder is a shareholder of a company, which’s capital is divided into stocks. The whole of stockholders form the general assembly."
            case .cooperativeMember: return "A person that provides assets to a cooperative."
            case .clubMember: return "A person that holds membership of a club."
            case .policyholder: return "A person that gains insurance."
            case .shareholderStructure: return "The shareholder structure defines who, to what extend, with what rights, and with what liability a person or company owns a share of a company."
            }
        }
    }
}

/// Management is a possible layer of a company’s structure.
///
/// Management controls and represent the company.
struct Management: CompanyLayer {
    var id = UUID()
    var label = "Management"
    var color = Color.blue
    var info = ""
    var title: String
    var liability: Bool? = nil
    var accessibilityDash: [CGFloat] = [10]
    
    internal init() {
        self.title = label
    }
    
    /// Sets up a management company layer.
    /// - Parameters:
    ///   - type: The type of management.
    ///   - label: An optional label that further describes the type.
    ///
    /// When there is a minimum amount of management members, use `Management.init(_:min:)`.
    init(_ type: ManagementType = .management, _ label: String? = nil) {
        self.init()
        self.initialize(label: label ?? type.rawValue, title: type.rawValue, info: type.info)
    }
    
    /// Sets up a management company layer.
    /// - Parameters:
    ///   - type: The type of management.
    ///   - label: An optional label that further describes the layer.
    ///   - fixedAmount: An optional label that further describes the type.
    init(_ type: ManagementType = .management, _ label: String? = nil, fixedAmount: Int) {
        self.init()
        if let label {
            self.initialize(label: "\(label) (\(fixedAmount))", title: type.rawValue, info: type.info)
        } else {
            self.initialize(label: String(fixedAmount), title: type.rawValue, info: type.info)
        }
    }
    
    /// Sets up a management company layer.
    /// - Parameters:
    ///   - type: The type of management.
    ///   - min: The minimum amount of management members.
    init(_ type: ManagementType = .management, min: Int) {
        self.init()
        self.initialize(label: min.plus, title: type.rawValue, info: type.info)
    }
    
    /// The specific type of management.
    enum ManagementType: String, CaseIterable {
        /// The management manages and represents the company.
        ///
        /// This is the default.
        case management = "Management"
        /// A complementary is an unlimited liable shareholder of a KG or KGaA that manages the company.
        case complementary = "Complementary"
        /// The board manages and represents the company.
        case board = "Board"
        /// The board of directors manages and represents the company on their own responsibility.
        case boardOfDirectors = "Board of Directors"
        /// Example type that explains management structure. Only relevant for the info view.
        case managementStructure = "Management Structure"
        
        /// The information about the management. It is visible in the information popover.
        var info: String {
            switch self {
            case .management: return "The management manages and represents the company."
            case .complementary: return "A complementary is an unlimited liable shareholder of a KG or KGaA that manages the company."
            case .board: return "The board manages and represents the company."
            case .boardOfDirectors: return "The board of directors manages and represents the company on their own responsibility."
            case .managementStructure: return "The management structure defines the organs that lead and represent their company, as well as their liability."
            }
        }
    }
}

/// Capital is a possible layer of a company’s structure.
///
/// Capital is the assets a company owns.
struct Capital: CompanyLayer {
    var id = UUID()
    var label = "Capital"
    var color = Color.orange
    var info = ""
    var title: String
    var liability: Bool? = nil
    var accessibilityDash: [CGFloat] = [30]
    
    internal init() {
        self.title = label
        self.info = CapitalType.capital.info
    }
    
    /// Sets up a capital company layer.
    /// - Parameters:
    ///   - type: The type of capital.
    ///   - label: An optional label that further describes the type.
    ///
    /// When there is a minimum (and maximum) amount of capital, use `Capital.init(_:min:)` respectively `Capital.init(_:min:max:)`.
    init(_ type: CapitalType = .capital, _ label: String? = nil) {
        self.init()
        self.initialize(label: label ?? type.rawValue, title: type.rawValue, info: type.info)
    }
    
    /// Sets up a capital company layer.
    /// - Parameters:
    ///   - type: The type of capital.
    ///   - min: The minimum amount of capital in Euro.
    init(_ type: CapitalType = .capital, min: Int) {
        self.init()
        self.initialize(label: "\(min.currency)", title: type.rawValue, info: type.info)
    }
    
    /// Sets up a capital company layer.
    /// - Parameters:
    ///   - type: The type of capital.
    ///   - min: The minimum amount of capital in Euro.
    ///   - max: The maximum amount of capital in Euro.
    init(_ type: CapitalType = .capital, min: Int, max: Int) {
        self.init()
        self.initialize(label: "\(min.currency) – \(max.currency)", title: type.rawValue, info: type.info)
    }
    
    /// The specific type of capital.
    enum CapitalType: String, CaseIterable {
        /// The company is not obligated to have capital.
        case noCompulsoryCapital = "No Compulsory Capital"
        /// The capital is the money, securities, and assets a company owns.
        ///
        /// This is the default.
        case capital = "Capital"
        /// The money, securities, and assets of a person.
        case privateAssets = "Private Assets"
        /// Deposits are values that a person inserted into a company. They can include money, securities, and assets.
        case privateDeposits = "Private Deposits"
        /// The capital of a foundation. It has been gifted by a founder/donor and may only be used for the foundation’s purpose.
        case foundationCapital = "Foundation Capital"
        /// The capital the club owns.
        case clubCapital = "Club Capital"
        /// Example type that explains capital structure. Only relevant for the info view.
        case capitalStructure = "Capital Structure"
        
        /// The information about the capital. It is visible in the information popover.
        var info: String {
            switch self {
            case .noCompulsoryCapital: return "The company is not obligated to have capital."
            case .capital: return "The capital is the money, securities, and assets a company owns."
            case .privateAssets: return "The money, securities, and assets of a person."
            case .privateDeposits: return "Deposits are values that a person inserted into a company, i.e., money, securities, or assets."
            case .foundationCapital: return "The capital of a foundation. It has been gifted by a founder/donor and may only be used for the foundation’s purpose."
            case .clubCapital: return "The capital the club owns."
            case .capitalStructure: return "The capital structure defines what assets a company must and can have."
            }
        }
    }
}

/// Stocks is a possible layer of a company’s structure.
///
/// Stocks is the assets a company owns divided in shares.
struct Stocks: CompanyLayer {
    var id = UUID()
    var label = "Stocks"
    var color = Color.green
    var info = "The capital of the company is divided into stocks. The stocks may be traded on an exchange."
    var title: String
    var liability: Bool? = nil
    var accessibilityDash: [CGFloat] = [40]
    
    internal init() {
        self.title = label
    }
    
    /// Sets up a stocks company layer.
    /// - Parameter min: The minimum total value of the stocks in Euro.
    init(min: Int) {
        self.init()
        self.label = min.minCurrency
    }
    
    /// Sets up a capital company layer.
    /// - Parameters:
    ///   - label: A description of the stocks.
    ///   - min: The minimum total value of the stocks in Euro.
    init(_ label: String, min: Int) {
        self.init()
        self.label = "\(label) (\(min.minCurrency))"
    }
}

/// A ship is the compulsive asset of a partner shipping company.
///
/// This specific edge-case requires an ad hoc structure in order to customize the layer specifically for it. The different color is used to mark it specifically as a physical asset. The custom color is necessary to align it with the other colors of the company form graphic. In a future version, this could potentially be refactored to `PhysicalAsset(.ship)`.
struct Ship: CompanyLayer {
    var id = UUID()
    var label = "One Ship"
    var color = Color.orangeBrown
    var info = "A partner shipping company is based and dependent on a ship, used specifically for seafaring. The company is dissolved when the ship is lost."
    var title = "Ship"
    var liability: Bool? = nil
    var accessibilityDash: [CGFloat] = [50]
}

/// A company that acts as management or shareholder of another company.
struct InsertedCompany: CompanyLayer {
    var id = UUID()
    var label = "Company"
    var color = Color.clear
    var info = ""
    var title: String
    var liability: Bool? = nil
    var company: Company = GmbH
    var accessibilityDash: [CGFloat] = [CGFloat]()
    
    internal init() {
        self.title = label
    }
    
    /// Insert a company into the company structure.
    /// - Parameters:
    ///   - company: The company to be inserted.
    ///   - role: The role of the company.
    init(_ company: Company, _ role: CompanyRole) {
        self.init()
        self.initialize(label: company.title, title: company.title, info: self.info)
        self.company = company
        self.color = role.color
        self.accessibilityDash = role.accessibilityDash
    }
    
    /// Insert a company into the company structure.
    /// - Parameters:
    ///   - company: The company to be inserted.
    ///   - role: The role of the company.
    ///   - min: The minimum amount of companies or persons in the role.
    init(_ company: Company, _ role: CompanyRole, min: Int) {
        self.init()
        self.initialize(label: "\(company.title) (\(min.plus))", title: "", info: "")
        self.company = company
        self.color = role.color
        self.accessibilityDash = role.accessibilityDash
    }
    
    /// The role the inserted company performs in the base company.
    enum CompanyRole {
        /// The inserted company manages the base company.
        case management
        /// The inserted company is a shareholder of the base company.
        case shareholder
        
        /// The color of the background of the layer in the company form graphic.
        var color: Color {
            self == .management ? Management().color : Shareholder().color
        }
        
        /// The dash pattern of the layer in the company form graphic. It is visible when the user has enabled Differentiate Without Color, or toggles the setting to differentiate without color.
        var accessibilityDash: [CGFloat] {
            self == .management ? Management().accessibilityDash : Shareholder().accessibilityDash
        }
    }
}

/*
MARK: Initial structure ideas
CompanyBuilder("GmbH", "Gesellschaft mit beschränkter Haftung", "Limited liability company") {
    SupervisoryBoard("From 500 Employees")
    Shareholder(.onePlus)
    LimitedLiability()
    Capital(min: 25000)
 }.tidbit("Lorem ipsum dolor sit amet.")
 
 CompanyBuilder("KGaA", "Kommanditgesellschaft auf Aktien", "Limited partnership on stocks") {
    SupervisoryBoard()
    Stack {
        Management(.onePlus)
        Shareholder(.onePlus)
    }
    Stack {
        LimitedLiability()
        UnlimitedLiability()
    }
    Stack {
        Capital()
        Shares(min: 50000)
    }
 }
*/

/*
MARK: Initial method of having liability as a separate layer
@available(*, deprecated, message: "Use .limitedLiability() instead")
struct LimitedLiability: CompanyStructure {
    var id = UUID()
}

@available(*, deprecated, message: "Use .unlimitedLiability() instead")
struct UnlimitedLiability: CompanyStructure {
    var id = UUID()
}
*/
