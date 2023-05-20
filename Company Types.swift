//
//  Company Types.swift
//  SSC23
//
//  Created by Luca Jonscher on 05.04.23.
//

import Foundation

// MARK: Explanatory company

/// An example company that explains the company info graphic.
let explanatoryCompany = Company(abbreviation: "Abbr.", name: "German Name", translation: "English Translation", reason: "The Company’s Reason", tidbit: nil) {
    Management(.managementStructure)
    Shareholder(.shareholderStructure)
    ExampleLiability()
    Capital(.capitalStructure)
}

// MARK: Partnerships

/// Sole Proprietor
let EU = Company(abbreviation: nil, name: "Einzelunternehmen", translation: "Sole Proprietor", reason: nil, tidbit: "Sole proprietor is the most common form of company in Germany.") {
    Shareholder(.shareholder, "Proprietor", min: 1)
        .unlimitedLiability()
    Capital(.privateAssets)
}

/// Silent Partnership
let SG = Company(abbreviation: nil, name: "Stille Gesellschaft", translation: "Silent Partnership", reason: nil, tidbit: "A silent partnership exist when a person invests in a company with a deposit. It is only an inside company and does not have to be disclosed, except for AGs.") {
    Row {
        Management(.management, "Proprietor", fixedAmount: 1)
            .unlimitedLiability()
        Shareholder(.limitedPartner, "Investor", fixedAmount: 1)
            .limitedLiability()
    }
    Row {
        Capital(.privateAssets)
        Capital(.privateDeposits)
    }
}

/// Partner Shipping Company
let PR = Company(abbreviation: nil, name: "Partenreederei", translation: "Partner Shipping Company", reason: "Seafaring", tidbit: "Since 2013, partner shipping companies cannot be created anymore.") {
    Shareholder(.shareholder, "Mariner", min: 2)
        .unlimitedLiability()
    Ship()
}

/// Registered Merchant
let eK = Company(abbreviation: "e. K.", name: "Eingetragener Kaufmann (e. Kfm.) / Eingetragene Kauffrau (e. Kfr.)", translation: "Registered Merchant", reason: "Trade", tidbit: nil) {
    Shareholder(.shareholder, "Merchant", min: 1)
        .unlimitedLiability()
    Capital(.privateAssets)
}

/// Partnership Company
let PartG = Company(abbreviation: "PartG", name: "Partnerschaftsgesellschaft", translation: "Partnership Company", reason: nil, tidbit: nil) {
    Shareholder(.shareholder, "Freelancer", min: 2)
        .unlimitedLiability()
    Capital(.privateAssets)
}

/// Partnership Company with Limited Professional Liability
let PartGmbB = Company(abbreviation: "PartG mbB", name: "Partnerschaftsgesellschaft mit beschränkter Berufshaftung", translation: "Partnership Company with Limited Professional Liability", reason: nil, tidbit: "Only freelancers with professional indemnity insurance can found a PartG mbB.") {
    Shareholder(.shareholder, "Freelancer", min: 2)
        .limitedLiability()
    Capital(.privateAssets)
}

/// Civil Law Partnership
let GbR = Company(abbreviation: "GbR", name: "Gesellschaft bürgerlichen Rechts", translation: "Civil Law Partnership", reason: nil, tidbit: "When a GbR is involved in trade, it converts to an OHG.") {
    Shareholder(min: 2)
        .unlimitedLiability()
    Capital(.privateAssets)
}

/// General Partnership
let OHG = Company(abbreviation: "OHG", name: "Offene Handelsgesellschaft", translation: "General Partnership", reason: "Trade", tidbit: nil) {
    Shareholder(min: 2)
        .unlimitedLiability()
    Capital(.privateAssets)
}

/// Limited Partnership
let KG = Company(abbreviation: "KG", name: "Kommanditgesellschaft", translation: "Limited Partnership", reason: nil, tidbit: nil) {
    Row {
        Management(.complementary, min: 1)
            .unlimitedLiability()
        Shareholder(.limitedPartner, min: 1)
            .limitedLiability()
    }
    Capital()
}

/// European Economic Interest Grouping (EEIG)
let EWIV = Company(abbreviation: "EWIV", name: "Europäische wirtschaftliche Interessenvereinigung", translation: "European Economic Interest Grouping (EEIG)", reason: nil, tidbit: "The shareholders of an EWIV have to be from at least two countries of the European Economic Area. An EWIV can employ a maximum of 500 people.") {
    Shareholder(min: 2)
        .unlimitedLiability()
    Capital(.noCompulsoryCapital)
}

// MARK: Corporations

/// Entrepreneurial Company at Limited Liability
let UG = Company(abbreviation: "UG (haftungsbeschränkt)", name: "Unternehmergesellschaft (haftungsbeschränkt)", translation: "Entrepreneurial Company at Limited Liability", reason: nil, tidbit: "The UG (haftungsbeschränkt) is not a separate type of company, but a variation of the GmbH with lower capital.") {
    Shareholder(min: 1)
        .limitedLiability()
    Capital(min: 1, max: 24999)
}

/// Nonprofit Entrepreneurial Company at Limited Liability
let gUG = Company(abbreviation: "gUG (haftungsbeschränkt)", name: "Gemeinnützige Unternehmergesellschaft (haftungsbeschränkt)", translation: "Nonprofit Entrepreneurial Company at Limited Liability", reason: "Charitable purpose", tidbit: "The gUG (haftungsbeschränkt) is not a separate type of company, but a variant of the gGmbH with lower capital.") {
    Shareholder(min: 1)
        .limitedLiability()
    Capital(min: 1, max: 24999)
}

/// Limited Liability Partnership
let GmbH = Company(abbreviation: "GmbH", name: "Gesellschaft mit beschränkter Haftung", translation: "Limited Liability Partnership", reason: nil, tidbit: nil) {
    SupervisoryBoard("From 500 employees")
    Shareholder(min: 1)
        .limitedLiability()
    Capital(min: 25000)
}

/// Nonprofit Limited Liability Partnership
let gGmbH = Company(abbreviation: "gGmbH", name: "Gemeinnützige Gesellschaft mit beschränkter Haftung", translation: "Nonprofit Limited Liability Partnership", reason: "Charitable purpose", tidbit: nil) {
    SupervisoryBoard("From 500 employees")
    Shareholder(min: 1)
        .unlimitedLiability()
    Capital(min: 25000)
}

/// Limited Partnership on Stocks
let KGaA = Company(abbreviation: "KGaA", name: "Kommanditgesellschaft auf Aktien", translation: "Limited Partnership on Stocks", reason: nil, tidbit: nil) {
//    SupervisoryBoard()
    Row {
        Management(.complementary, min: 1)
            .unlimitedLiability()
        Shareholder(.limitedPartner, min: 1)
            .limitedLiability()
    }
    Row {
        Capital(.privateDeposits)
        Stocks(min: 50000)
    }
}

/// Joint-Stock Company
let AG = Company(abbreviation: "AG", name: "Aktiengesellschaft", translation: "Joint-Stock Company", reason: nil, tidbit: nil) {
    SupervisoryBoard()
    Row {
        Management(.board)
            .unlimitedLiability()
        Shareholder(.stockholder)
            .limitedLiability()
    }
    Stocks(min: 50000)
}

/// Nonprofit Joint-Stock Company
let gAG = Company(abbreviation: "gAG", name: "Gemeinnützige Aktiengesellschaft", translation: "Nonprofit Joint-Stock Company", reason: "Charitable purpose", tidbit: nil) {
    SupervisoryBoard()
    Row {
        Management(.board)
            .unlimitedLiability()
        Shareholder(.stockholder)
            .limitedLiability()
    }
    Stocks(min: 50000)
}

/// Investment Joint-Stock Company
let InvAG = Company(abbreviation: "Inv-AG", name: "Investment-Aktiengesellschaft", translation: "Investment Joint-Stock Company", reason: "Management of special assets", tidbit: nil) {
    SupervisoryBoard()
    Row {
        Management(.board)
            .unlimitedLiability()
        Shareholder(.stockholder)
            .limitedLiability()
    }
    Stocks("External capital managment", min: 125000)
}

/// Investment Joint-Stock Company alternative
let _InvAG = Company(abbreviation: "Inv-AG", name: "Investment-Aktiengesellschaft", translation: "Investment Joint-Stock Company", reason: "Management of special assets", tidbit: nil) {
    SupervisoryBoard()
    Row {
        Management(.board)
            .unlimitedLiability()
        Shareholder(.stockholder)
            .limitedLiability()
    }
    Stocks("Internal capital managment", min: 300000)
}

/// Real-Estate-Investment-Trust Joint-Stock Company
let REIT_AG = Company(abbreviation: "REIT-AG", name: "Real-Estate-Investment-Trust-Aktiengesellschaft", translation: "Real-Estate-Investment-Trust Joint-Stock Company", reason: "Property management and investments (min. 75% of capital)", tidbit: "REIT-AGs have strict guidelines vis-à-vis their investments and their capital structure. For instance, at least 90% of profits have to be distributed to the shareholders. They must be listed on an exchange.") {
    SupervisoryBoard()
    Row {
        Management(.board)
            .unlimitedLiability()
        Shareholder(.stockholder)
            .limitedLiability()
    }
    Stocks(min: 15000000)
}

/// Societas Europaea (European Company)
let SE = Company(abbreviation: "SE", name: "Societas Europaea (Europäische Gesellschaft)", translation: "Societas Europaea (European Company)", reason: nil, tidbit: "An SE can be managed by a dualistic system with board and supervisory board (common in Germany) or the monistic system with only a board of directors (common in countries like the UK or the US).") {
    SupervisoryBoard()
    Row {
        Management(.board)
            .unlimitedLiability()
        Shareholder(.stockholder)
            .limitedLiability()
    }
    Stocks(min: 125000)
}

/// Societas Europaea (European Company) alternative
let _SE = Company(abbreviation: "SE", name: "Societas Europaea (Europäische Gesellschaft)", translation: "Societas Europaea (European Company)", reason: nil, tidbit: "An SE can be managed by a dualistic system with board and supervisory board (common in Germany) or the monistic system with only a board of directors (common in countries like the UK or the US).") {
    Row {
        Management(.boardOfDirectors)
            .unlimitedLiability()
        Shareholder(.stockholder)
            .limitedLiability()
    }
    Stocks(min: 125000)
}

// MARK: Cooperatives

/// Registered Cooperative
let eG = Company(abbreviation: "e. G.", name: "Eingetragene Genossenschaft", translation: "Registered Cooperative", reason: "Joint economic business operation", tidbit: "A cooperative can determine in their statute, whether cooperative members have limited or unlimited liability.") {
    Row {
        Management(.board)
        SupervisoryBoard()
    }
    Shareholder(.cooperativeMember, min: 3)
        .unlimitedLiability()
    Capital(.noCompulsoryCapital)
}

/// Registered Cooperative with Limited Liability
let _eG = Company(abbreviation: "e. G.", name: "Eingetragene Genossenschaft mit beschränkter Haftung", translation: "Registered Cooperative with Limited Liability", reason: "Joint economic business operation", tidbit: "A cooperative can determine in their statute, whether cooperative members have limited or unlimited liability.") {
    Row {
        Management(.board)
        SupervisoryBoard()
    }
    Shareholder(.cooperativeMember, min: 3)
        .limitedLiability()
    Capital(.noCompulsoryCapital)
}

/// Societas Cooperativa Europaea (European Cooperative Society)
let SCE = Company(abbreviation: "SCE", name: "Societas Cooperativa Europaea (Europäische Genossenschaft)", translation: "Societas Cooperativa Europaea (European Cooperative Society)", reason: "Joint economic business operation", tidbit: "The cooperative members of an SCE have to be from at least two countries of the European Economic Area.") {
    Row {
        Management(.board)
        SupervisoryBoard()
    }
    Shareholder(.cooperativeMember, min: 5)
        .unlimitedLiability()
    Capital(.noCompulsoryCapital)
}

/// Societas Cooperativa Europaea (European Cooperative Society) with Limited Liability
let SCEmbH = Company(abbreviation: "SCE mbH", name: "Societas Cooperativa Europaea (Europäische Genossenschaft) mit beschränkter Haftung", translation: "Societas Cooperativa Europaea (European Cooperative Society) with Limited Liability", reason: "Joint economic business operation", tidbit: "The cooperative members of an SCE have to be from at least two countries of the European Economic Area.") {
    Row {
        Management(.board)
        SupervisoryBoard()
    }
    Shareholder(.cooperativeMember, min: 5)
        .limitedLiability()
    Capital(.noCompulsoryCapital)
}

// MARK: Other

/// Legal Foundation of Private/Civil Law
let foundation = Company(abbreviation: "Stiftung", name: "Rechtsfähige Stiftung des privaten/bürgerlichen Rechts", translation: "Legal Foundation of Private/Civil Law", reason: "Foundation purpose", tidbit: "The foundation capital was designated by the founder for a specific purpose. A foundation has no shareholders.") {
    Management(.board)
        .unlimitedLiability()
    Capital(.foundationCapital)
}

/// Unregistered Club
let club = Company(abbreviation: "Verein", name: "Nicht eingetragener Verein", translation: "Unregistered Club", reason: "Club purpose (not economic)", tidbit: nil) {
    Management(.board)
    Shareholder(.clubMember, min: 2)
        .unlimitedLiability()
    Capital(.clubCapital)
}

/// Registered Club
let eV = Company(abbreviation: "e. V.", name: "Eingetragener Verein", translation: "Registered Club", reason: "Club purpose (not economic)", tidbit: nil) {
    Management(.board)
    Shareholder(.clubMember, min: 7)
        .limitedLiability()
    Capital(.clubCapital)
}

/// Economic Club
let wV = Company(abbreviation: "w. V.", name: "Wirtschaftlicher Verein", translation: "Economic Club", reason: "Club purpose (economic)", tidbit: nil) {
    Management(.board)
    Shareholder(.clubMember, min: 7)
        .limitedLiability()
    Capital(.clubCapital)
}

/// Mutual Insurance Association
let VVaG = Company(abbreviation: "VVaG", name: "Versicherungsverein auf Gegenseitigkeit", translation: "Mutual Insurance Association", reason: "Insurance", tidbit: nil) {
    Row {
        SupervisoryBoard()
        Management(.board, min: 2)
    }
    Shareholder(.policyholder)
        .limitedLiability()
    Capital(.clubCapital)
}

// MARK: Mixed Forms

/// AG & Co. OHG
let AG_Co_OHG = Company(abbreviation: "AG & Co. OHG", name: "Aktiengesellschaft & Co. Offene Handelsgesellschaft", translation: "Joint-Stock Company & Co. General Partnership", reason: "Trade", tidbit: nil) {
    InsertedCompany(AG, .management, min: 2)
        .unlimitedLiability()
    Capital(.privateAssets)
}

/// GmbH & Co. KG
let GmbH_Co_KG = Company(abbreviation: "GmbH & Co. KG", name: "Gesellschaft mit beschränkter Haftung & Co. Kommanditgesellschaft", translation: "Limited Liability Partnership & Co. Limited Partnership", reason: nil, tidbit: nil) {
    Row {
        InsertedCompany(GmbH, .management)
            .unlimitedLiability()
        Shareholder(.limitedPartner, min: 1)
            .limitedLiability()
    }
    Capital()
}

/// e. G. & Co. KG
let eG_Co_KG = Company(abbreviation: "e. G. & Co. KG", name: "Eingetragene Genossenschaft & Co. Kommanditgesellschaft", translation: "Registered Cooperative & Co. Limited Partnership", reason: nil, tidbit: nil) {
    Row {
        InsertedCompany(eG, .management)
            .unlimitedLiability()
        Shareholder(.limitedPartner, min: 1)
            .limitedLiability()
    }
    Capital()
}

/// KGaA & Co. KG
let KGaA_Co_KG = Company(abbreviation: "KGaA & Co. KG", name: "Kommanditgesellschaft auf Aktien & Co. Kommanditgesellschaft", translation: "Limited Partnership on Stocks & Co. Limited Partnership", reason: nil, tidbit: nil) {
    Row {
        InsertedCompany(KGaA, .management)
            .unlimitedLiability()
        Shareholder(.limitedPartner, min: 1)
            .limitedLiability()
    }
    Capital()
}

/// Stiftung GmbH & Co. KG
let Stiftung_GmbH_Co_KG = Company(abbreviation: "Stiftung GmbH & Co. KG", name: "Stiftung, Gesellschaft mit beschränkter Haftung & Co. Kommanditgesellschaft", translation: "Foundation, Limited Liability Partnership & Co. Limited Partnership", reason: nil, tidbit: nil) {
    Row {
        InsertedCompany(GmbH, .management)
            .unlimitedLiability()
        InsertedCompany(foundation, .shareholder)
            .limitedLiability()
    }
    Capital()
}

/// SE & Co. KGaA
let SE_Co_KGaA = Company(abbreviation: "SE & Co. KGaA", name: "Societas Europaea & Co. Kommanditgesellschaft auf Aktien", translation: "Societas Europaea & Co. Limited Partnership on Stocks", reason: nil, tidbit: nil) {
    SupervisoryBoard()
    Row {
        InsertedCompany(SE, .management)
            .unlimitedLiability()
        Shareholder(.limitedPartner, min: 1)
            .limitedLiability()
    }
    Row {
        Capital(.privateDeposits)
        Stocks(min: 50000)
    }
}

/// (GmbH & Co. KG.) & Co. KGaA
let GmbH_Co_KG_Co_KGaA = Company(abbreviation: "(GmbH & Co. KG) & Co. KGaA", name: "(Gesellschaft mit beschränkter Haftung & Co. Kommanditgesellschaft) & Co. Kommanditgesellschaft auf Aktien", translation: "(Limited Liability Partnership & Co. Limited Partnership) & Co. Limited Partnership on Stocks", reason: nil, tidbit: nil) {
    SupervisoryBoard()
    Row {
        InsertedCompany(GmbH_Co_KG, .management)
            .unlimitedLiability()
        Shareholder(.limitedPartner, min: 1)
            .limitedLiability()
    }
    Row {
        Capital(.privateDeposits)
        Stocks(min: 50000)
    }
}

// MARK: Collections

/// A collection of forms of partnerships.
let partnerships = [EU, SG, PR, PartG, GbR, OHG, KG, EWIV]

/// A collection of forms of corporations.
let corporations = [UG, GmbH, KGaA, AG, InvAG, REIT_AG, SE]

/// A collection of forms of cooperatives.
let cooperatives = [eG, SCE]

/// A collection of other company forms.
let other = [foundation, club, eV, VVaG]

/// A collection of examples for mixed company forms.
let mixedForms = [AG_Co_OHG, GmbH_Co_KG, eG_Co_KG, KGaA_Co_KG, Stiftung_GmbH_Co_KG, SE_Co_KGaA, GmbH_Co_KG_Co_KGaA]
               
/// A dictionary of every company that has a variant with alternate structure.
///
/// The `key` is the normal company and the `value` its alternate form.
///
/// The alternate forms are not available in the collections. Instead, they may be added by using `.addVariants(true)` on an array of companies.
///
/// This data model only accounts for companies with exactly one alternative, not more. If there were to be a case, where there are multiple alternatives, either (1), the model would need to be changed to `[Company: [Company]]`, or (2), the views would need to be adapted to the usage of `[A: B, B: C]`.
let companiesWithAlternateStructure: [Company: Company] = [EU: eK, PartG: PartGmbB, UG: gUG, GmbH: gGmbH, AG: gAG, InvAG: _InvAG, SE: _SE, eG: _eG, SCE: SCEmbH, eV: wV]


/// A stress test company to see possible limitations or errors with the company info view.
let _stressTest = Company(abbreviation: "StrT", name: "Stress Test (DE)", translation: "STRESS_TEST (EN)", reason: "XXX", tidbit: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX") {
    Management(.management)
    Row {
        Management(.board).limitedLiability()
        Management(.boardOfDirectors).unlimitedLiability()
        Management(.complementary)
    }
    Shareholder(.shareholder)
    Row {
        Row { // Since Row conforms to CompanyLayer, these nestings are possible (although in practice useless)
            Shareholder(.clubMember)
            Shareholder(.policyholder)
        }
        Shareholder(.limitedPartner)
            .limitedLiability()
    }
    Capital()
}
