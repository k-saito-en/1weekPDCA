//
//  component.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/07.
//

import Foundation
import SwiftUI

//MARK: ボトムバーアイコンの中身
let bottomBarItems = [
        BottomBarItem(image: "graduationcap.fill", view: AnyView(ActView())),
        BottomBarItem(image: "square.fill", view: AnyView(PlanDoView())),
        BottomBarItem(image: "checkmark.circle.fill", view: AnyView(CheckView()))
    ]

//MARK: ボトムバーの実装
struct BottomBar: View {
    
    // タブの選択値と初期値.
    @State private var selected = 0
    
    var body: some View {
        
        ZStack {
            
            // 背景色.
            Color.backGroundColorGray.ignoresSafeArea()
            
            // メイン画面部分はTabViewで定義.
            TabView(selection: $selected) {
                ForEach(0 ..< 3) { index in
                    bottomBarItems[index].view
                        .tag(index)
                }
            }
            // PageTabスタイルを利用する(インジケータは非表示).
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            VStack {
                
                Spacer(minLength: 0)
                
                // タブビュー部分.
                HStack {
                    ForEach(0 ..< 3) { index in
                        Image(systemName: bottomBarItems[index].image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                self.selected = index
                            }
                            .foregroundColor(self.selected == index ? Color.black : Color.gray)
                    }
                }
                .padding(.vertical, 10.0)
                .padding(.horizontal, 20.0)
                .background(Color.white.clipShape(Capsule()))
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: -5, y: 5)
            }
        }
    }
}



//MARK: プレビュー
struct BottomBar_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            // ここに他のViewを配置
            BottomBar()
        }
    }
}

//MARK: 以下、タブに連動している画面のモック
struct ActView: View {
    var body: some View {
        Text("Act")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .foregroundColor(.red)
    }
}

struct PlanDoView: View {
    var body: some View {
        Text("PlanDo")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .foregroundColor(.green)
    }
}

struct CheckView: View {
    var body: some View {
        Text("Check")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .foregroundColor(.blue)
    }
}
