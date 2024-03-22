//
//  ExpandableView.swift
//  CryptoView
//
//  Created by francesco scalise on 21/03/24.
//

import SwiftUI

struct ExpandableView: View {
    @State private var isExpanded = false

    private let headerText: String
    private let bodyText: String

    private let textStyle: Font = .body
    private let textColor: Color = .white

    private let previewLimit: Int = 100

    public init(fullText: String) {
        if fullText.count > previewLimit {
            let index = fullText.index(fullText.startIndex, offsetBy: previewLimit)
            self.headerText = String(fullText[..<index]) + "..."
            self.bodyText = String(fullText[index...])
        } else {
            self.headerText = fullText
            self.bodyText = ""
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            if !isExpanded {
                Text(headerText)
                    .font(textStyle)
                    .foregroundColor(textColor)
                    .onTapGesture {
                        withAnimation {
                            self.isExpanded.toggle()
                        }
                    }
            } else {
                Text(headerText.dropLast(3) + bodyText)
                    .font(textStyle)
                    .foregroundColor(textColor)
                    .onTapGesture {
                        withAnimation {
                            self.isExpanded.toggle()
                        }
                    }
            }
        }
    }
}
