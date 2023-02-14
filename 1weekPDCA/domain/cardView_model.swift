//
//  cardView_model.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/14.
//

import Foundation
import SwiftUI

struct CardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Spacer().frame(height: 7)
                content
            }
            .padding(Edge.Set.horizontal, 50)
            .background(
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.cardColorGray)
                        .cornerRadius(25)
                        .padding(Edge.Set.horizontal, 25)
                        .frame(height: geometry.size.height + 20)
                }
            )
        }
        .frame(height: 120)
    }
}
