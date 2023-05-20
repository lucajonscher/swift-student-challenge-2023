//
//  AboutMeView.swift
//  SSC23
//
//  Created by Luca Jonscher on 17.04.23.
//

import Foundation
import SwiftUI

/// A view that gives “about me” information.
struct AboutMeView: View {
    /// The array of quick infos about me.
    ///
    /// The tuple structure is `(emoji, textLabel, accessibilityLabel)`.
    let array = [
        ("🎂", Text("October 21, 2004"), "My birthday is on October 21, 2004."),
        ("📍", Text("Hövelhof, Germany [(Open in Maps)](maps://?address=33161%20H%C3%B6velhof,%20Nordrhein-Westfalen,%20Deutschland&auid=509229878030893711&ll=51.820472,8.658666&lsp=7618&q=H%C3%B6velhof&_ext=Ch8KBQgEEIEBCgQIBRADCgQIBhADCgQIChAJCgQIVRAJEiYpjSN7KeHnSUAxhU8pZQhGIUA55ZzYQ/vqSUBBtkqwOJxZIUBQDA%3D%3D)"), "I live in Hövelhof, Germany."),
        ("👨🏼‍🎓", Text("High School Student (Grade 12)"), "I am a high school student in grade 12, graduating with Abitur this summer."),
        ("👨🏼‍💻", Text("Self-employed freelance graphic designer"), "I work as a self-employed freelance graphic designer.")
    ]
    
    @ViewBuilder var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center) {
                    Image("Luca Hendrik Jonscher")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: .secondary.opacity(0.2), radius: 10, x: 0, y: 10)
                        .padding(.horizontal, 60)
                        .padding(.vertical)
                    Text("Luca Hendrik Jonscher")
                        .font(.title)
                        .padding(.bottom)
                    Text("Hey, I am Luca Hendrik Jonscher, 18 years old, and from Hövelhof, Germany. I like dancing, drawing, developing, and designing. I started development with Swift in January of 2020 and am designing for about 6 years. Since late 2022, I am self-employed as a freelance graphic designer. In September of this year, I will start studying Communications Design at the Hochschule Bielefeld (HSBI).")
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(array, id: \.0) { (emoji, text, description) in
                            HStack {
                                Text(emoji).frame(width: 40)
                                text
                            }.accessibilityLabel(description)
                        }
                    }.padding(.vertical)
                    Group {
                        let downslash = Text(" | ")
                        Text("[Twitter](https://twitter.com/lucajonscher/)").underline() +
                        downslash +
                        Text("[Instagram](https://www.instagram.com/lucajonscher/)").underline() +
                        downslash +
                        Text("[Behance](https://www.behance.net/lucaj3/)").underline() +
                        downslash +
                        Text("[Medium](https://medium.com/@lucajonscher/)").underline() +
                        downslash +
                        Text("[Email](mailto:info@lucajonscher.de)").underline()
                    }
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    Spacer(minLength: 100)
                }.scenePadding()
            }.edgesIgnoringSafeArea(.bottom)
            .navigationTitle("About Me")
            .dismissable()
        }
    }
}

