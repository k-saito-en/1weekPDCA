//
//  Check.swift
//  weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/09/04.
//

import SwiftUI

struct CheckView: View {
    var body: some View {
        ZStack {
            
            Color.backGroundColorGray.ignoresSafeArea()
            
            ScrollView {
                
                Color.clear.frame(width:200, height: 20)
                
                // 日付カード表示部分
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
                
                // 入力カード表示部分
                ZStack {
                    
                    Rectangle()
                        .fill(Color.cardColorGray)
                        .cornerRadius(25)
                        .frame(height: 600)
                        .padding(.horizontal, 20)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                   
                    
                    VStack() {
                        
                        ZStack {
                            
                            Rectangle()
                                .fill(Color.cardColorGray)
                                .cornerRadius(25)
                                .frame(height: 60)
                                .padding(.horizontal, 20)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 10)
                            
                            HStack {
                                
                                Rectangle()
                                    .fill(Color.uiColorGray)
                                    .opacity(0.5)
                                    .cornerRadius(25)
                                    .frame(width: 100, height: 50)
//                                    .padding(.leading, 20)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                
                                Rectangle()
                                    .fill(Color.uiColorGray)
                                    .opacity(0.5)
                                    .cornerRadius(25)
                                    .frame(width: 100, height: 50)
//                                    .padding(.leading, 20)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                
                                Color.clear.frame(width:.infinity, height: .infinity)
                                
                                Button(action: {
                                    // ボタンアクション記述する
                                }) {
                                    ZStack {
                                        Image(systemName: "circle.fill")
                                            .resizable()
                                            .frame(width: 50 ,height: 50)
                                            .foregroundColor(Color.uiColorGray).opacity(0.5)
                                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                        
                                        Image(systemName: "plus")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(.white)
                                    }
                                }
                                
                            }
                            .frame(width: .infinity, height: 60)
                            .padding(.horizontal, 30)
                            
                        }
                        
                        
                        // 開発中の高さ調節のためのView
                        Color.clear.frame(width:200, height: .infinity)
                        
                    }
                }
                
            }
        }
    }
}

struct Check_Previews: PreviewProvider {
    static var previews: some View {
        CheckView()
    }
}
