//
//  Peter020_1App.swift
//  Peter020_1
//
//  Created by DONG SHENG on 2022/8/18.
//

import SwiftUI

@main
struct Peter020_1App: App {
    
    @StateObject var cartVM = CartViewModel()
    
    init(){
        // 自定義 Picker 顏色 (被選定時 、 未選定時)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("iconRed"))
        UISegmentedControl.appearance().backgroundColor = UIColor(Color("pickerSelectedColor"))
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : UIColor(Color(.white))
        ]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)

        
        let attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor : UIColor(Color("pickerNormalColor"))
        ]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes2, for: .normal)
    }
    
    var body: some Scene {
        WindowGroup {
//            NavigationView{
                HomeView()
//            }
//            .navigationBarTitle("")
//            .navigationBarHidden(true)
//            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(cartVM)
        }
    }
}
