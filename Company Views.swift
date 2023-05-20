//
//  Company Views.swift
//  LucaHendrikJonscherSSC23
//
//  Created by Luca Jonscher on 05.04.23.
//

import SwiftUI

// MARK: Properties

/// Universal spacing for the company form graphic.
let universalSpacing: CGFloat = 14
/// Layer corner radius for the company form graphic.
let cornerRadius: CGFloat = 14

/// Spacing for the simplified company form graphic.
let simplifiedSpacing: CGFloat = 9
/// Layer height for the simplified company form graphic.
let simplifiedHeight: CGFloat = 16
/// Layer corner radius for the simplified company form graphic.
let simplifiedCornerRadius: CGFloat = 5

extension Company {
    /// The company form graphic for the company.
    ///
    /// It shows the management, shareholder, liability, and capital layers. The layers are interactive; when tapped, they reveal more detailed information.
    var body: some View {
        VStack(spacing: universalSpacing) {
            ForEach(structure, id: \.id) { layer in
                layer.body.typeErased
            }
        }
        .padding(universalSpacing)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius + universalSpacing, style: .continuous)
                .foregroundColor(.yellow)
        )
    }
    
    /// The simplified company form graphic for the company.
    ///
    /// It displays the labeled layers as rounded rectangles only, while being smaller in general. The simplified body is not interactive.
    var simplifiedBody: some View {
        VStack(spacing: simplifiedSpacing) {
            ForEach(structure, id: \.id) { layer in
                Group {
                    if let layer = layer as? any CompanyLayer {
                        layer.simplifiedBody.typeErased
                    } else if let row = layer as? Row {
                        row.simplifiedBody.typeErased
                    }
                }
            }
        }
        .padding(simplifiedSpacing)
        .background(
            RoundedRectangle(cornerRadius: simplifiedCornerRadius + simplifiedSpacing, style: .continuous)
            .foregroundColor(.yellow)
        )
        .frame(minWidth: simplifiedSpacing * 8)
        .accessibilityHidden(true)
    }
}

extension CompanyLayer {
    /// The visual representation of the company layer.
    var body: some View {
        CompanyLayerView(layer: self)
    }
    
    /// The simplified visual representation of the company layer.
    ///
    /// The label is omitted and the layer is of smaller size. The layer is not interactive.
    var simplifiedBody: some View {
        VStack(alignment: .center) {
            RoundedRectangle(cornerRadius: simplifiedCornerRadius, style: .continuous)
                .foregroundColor(self.color)
                .frame(height: simplifiedHeight)
            if let liability = self.liability {
                SimplifiedLiabilityView(unlimited: liability)
            }
        }
    }
}

extension CompanyStructure {
    /// Wraps the company structure’s body in an `AnyView`.
    ///
    /// This property may be used in places, where the `.body` property results in a type error.
    @available(*, deprecated, message: "Use `.body.typeErased` instead")
    var anyView: AnyView {
        AnyView(self.body)
    }
}

extension Row {
    /// The visual representation of the row.
    var body: some View {
        HStack(alignment: .top, spacing: universalSpacing) {
            ForEach(layers, id: \.id) { layer in
                layer.body.typeErased
            }
        }
    }
    
    /// The simplified visual representation of the row.
    var simplifiedBody: some View {
        HStack(alignment: .top, spacing: simplifiedSpacing) {
            ForEach(layers, id: \.id) { layer in
                if let layer = layer as? any CompanyLayer {
                    layer.simplifiedBody.typeErased
                } else if let row = layer as? Row {
                    row.simplifiedBody.typeErased
                }
            }
        }
    }
}

extension ExampleLiability {
    /// The content for the example liability view.
    var body: some View {
        ExampleLiabilityView()
    }
}

// MARK: Views

/// Creates the visual and interactive representation of a company layer.
struct CompanyLayerView: View {
    var layer: any CompanyLayer
    
    @State private var showPopover = false
    
    @Environment(\.accessibilityDifferentiateWithoutColor) private var systemDifferentiateWithoutColor
    @AppStorage("DifferentiateWithoutColor") var differentiateWithoutColor = false
    
    @ViewBuilder var body: some View {
        VStack(alignment: .center) {
            Button(action: {
                showPopover = true
            }) {
                HStack {
                    Spacer()
                    Text(layer.label)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.vertical, universalSpacing + 4)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }.background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .foregroundColor(layer.color)
                        .overlay {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round, dash: layer.accessibilityDash, dashPhase: 1))
                                .foregroundColor(.black)
                                .conditionally(if: differentiateWithoutColor || systemDifferentiateWithoutColor)
                        }
                )
            }
            .buttonStyle(.plain)
            .popover(isPresented: $showPopover) {
                if let layer = layer as? InsertedCompany {
                    CompanyViewContainer(company: layer.company, focussedCompany: .constant(nil))
                        .sheetStyle()
                } else {
                    PopoverView(title: layer.title, text: layer.info)
                }
            }
            if let liability = layer.liability {
                LiabilityView(unlimited: liability)
                    .padding(universalSpacing)
            }
        }
    }
}

/// The visual and interactive representation of liability.
struct LiabilityView: View {
    var unlimited: Bool
    
    @State private var showPopover = false
    
    @ViewBuilder var body: some View {
        Button(action: {
            showPopover = true
        }) {
            HStack {
                Spacer()
                Image(systemName: "arrowtriangle.down")
                    .imageScale(.medium)
                    .font(.title)
                    .symbolVariant(unlimited ? .fill : .none)
                    .foregroundColor(.black)
                Spacer()
            }.padding(.top, 6)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(unlimited ? "Unlimited liability" : "Limited liability")
        .popover(isPresented: $showPopover) {
            PopoverView(title: "Unlimited Liability", text: "The shareholder is liable with the capital they put in the company and their private assets.")
                .conditionally(if: unlimited) {
                    PopoverView(title: "Limited Liability", text: "The shareholder is only liable with the capital they put in the company.")
                }
        }
    }
}

/// The simplified visual representation of liability.
struct SimplifiedLiabilityView: View {
    var unlimited: Bool
    
    @ViewBuilder var body: some View {
        HStack {
            Spacer()
            Image(systemName: "arrowtriangle.down")
                .imageScale(.medium)
                .font(.headline)
                .symbolVariant(unlimited ? .fill : .none)
                .foregroundColor(.black)
            Spacer()
        }.padding(.top, 2)
    }
}

/// The visual and interactive example representation of liability.
struct ExampleLiabilityView: View {

    @State private var showPopover = false
    
    @ViewBuilder var body: some View {
        Button(action: {
            showPopover = true
        }) {
            HStack {
                Spacer()
                Image(systemName: "arrowtriangle.down.fill")
                Text("/").accessibilityHidden(true)
                Image(systemName: "arrowtriangle.down")
                Spacer()
            }
            .padding(.top, 6)
            .imageScale(.medium)
            .font(.title)
            .foregroundColor(.black)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Liability")
        .popover(isPresented: $showPopover) {
            PopoverView(title: "Liability", text: "Liability states how, and to what degree, a person or company has to pay for debts or damages.")
        }
    }
}

