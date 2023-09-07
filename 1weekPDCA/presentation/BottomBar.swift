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
    BottomBarItem(image: "graduationcap.fill", view: AnyView(MockActView())),
    BottomBarItem(image: "square.fill", view: AnyView(PlanDoView())),
    BottomBarItem(image: "checkmark.circle.fill", view: AnyView(CheckView()))
]

//MARK: ボトムバーの実装
struct BottomBar: View {
    
    // タブの選択値と初期値.
    @State internal var selected = 0
    
    // 選択中のアイコンが大きくなっているか
    @State internal var isBig = false
    
    var body: some View {
        
        ZStack {
            
            // 背景色.
            Color.backGroundColorGray.ignoresSafeArea()
            
            // メイン画面部分はTabViewで定義.
            VStack {
                
                Color.clear.frame(height: 20)
                
                TabView(selection: $selected) {
                    ForEach(0 ..< 3) { index in
                        bottomBarItems[index].view
                            .tag(index).ignoresSafeArea()
                    }
                }
                // PageTabスタイルを利用する(インジケータは非表示).
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                Color.clear.frame(height: 65)
            }
            
            VStack {
                
                Spacer(minLength: 0)
                
                // ボトムバー部分.
                HStack (spacing: (UIScreen.main.bounds.width - 100.0) / 3){
                    ForEach(0 ..< 3) { index in
                        Image(systemName: bottomBarItems[index].image)
                        // View のサイズ変更を許可
                            .resizable()
                        // アスペクト比の設定
                        // 表示するコンテンツのサイズとレイアウトを設定
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                // 線型(linear)アニメーションを設定
                                withAnimation(.linear(duration: 0.05)) {
                                    self.selected = index
                                }
                                withAnimation(.linear(duration: 0.05)) {
                                    self.isBig = true
                                }
                            }
                            .foregroundColor(self.selected == index ? Color.uiColorGreen : Color.uiColorGray)
                            .scaleEffect(self.selected == index && self.isBig ? 1.3 : 1.0)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .padding(.vertical, 10.0)
                .padding(.horizontal, 50.0)
                .background(Color.cardColorGray.clipShape(Capsule()))
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: -5, y: 5)
                
                Color.clear.frame(height: 30)
                
            }
        }
        .frame(
            width: UIScreen.main.bounds.width ,
            height: UIScreen.main.bounds.height
        )
        .ignoresSafeArea(.keyboard)
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
struct MockActView: View {
    var body: some View {
        Text("Act")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .foregroundColor(.red)
    }
}

//struct MockPlanDoView: View {
//    var body: some View {
//        Text("PlanDo")
//            .font(.largeTitle)
//            .fontWeight(.heavy)
//            .foregroundColor(.green)
//    }
//}

struct MockCheckView: View {
    var body: some View {
        Text("Check")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .foregroundColor(.blue)
    }
}
