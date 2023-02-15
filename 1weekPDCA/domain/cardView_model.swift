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

    // 渡された View を content に保持させることで body で使えるようにしている
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
                        .padding(Edge.Set.horizontal, 15)
                        .frame(height: geometry.size.height + 20)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
            )
        }
        .frame(height: 120)
    }
}
