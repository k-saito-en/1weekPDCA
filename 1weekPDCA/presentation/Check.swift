//
//  Check.swift
//  weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/09/04.
//

import SwiftUI

struct Check: View {
    var body: some View {
        ZStack {
            
            Color.backGroundColorGray.ignoresSafeArea()
            
            ScrollView {
                
                ZStack {
                    
                    Rectangle()
                        .fill(Color.cardColorGray)
                        .cornerRadius(25)
                        .frame(height: 60)
                        .padding(.horizontal, 20)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                   
                    HStack {
                        
                        Text("12 / 24")
                            .textStyle(for: .title, color: Color.uiColorGray)
//                            .padding(.leading, 40)
                        
                        Color.clear.frame(width:200, height: 40)
                        
                        Text("Sun")
                            .textStyle(for: .title, color: Color.uiColorGray)
                        
                    }
                    .frame(width: .infinity, height: 60)
                    .padding(.horizontal, 30)
                    
                }
            }
        }
    }
}

struct Check_Previews: PreviewProvider {
    static var previews: some View {
        Check()
    }
}
