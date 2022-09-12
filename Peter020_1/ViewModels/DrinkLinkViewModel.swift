//
//  DrinkLinkViewModel.swift
//  Peter020_1
//
//  Created by DONG SHENG on 2022/8/23.
//

import Foundation

class DrinkLinkViewModel: ObservableObject{
    
    @Published var sizeSelected: String = "L"{
        didSet{
            getCurrentTotalPrice()
        }
    }
    let sizeOptions: [String] = [
        "L" , "M"
    ]
    
    @Published var currentTotalPrice: Int = 0
    @Published var drinkPriceL: Int = 0
    @Published var drinkPriceM: Int = 0
    
    
    @Published var iceSelected: String = "去冰"
    let iceOptions: [String] = [
        "去冰" , "微冰" , "少冰" , "正常冰" , "熱飲"
    ]
    let iceOptions2: [String] = [
        "去冰" , "微冰" , "少冰" , "正常冰"
    ]
    
    
    @Published var sugarSelected: String = "無糖"
    let sugarOptions: [String] = [
        "無糖" , "微糖" , "少糖" , "半糖" , "正常甜"
    ]
    
    @Published var topping: String = "" {
        didSet{
            getCurrentTotalPrice()
        }
    }
    
    @Published var notesText: String = ""
    
    @Published var amount: Int = 1{
        didSet{
            getCurrentTotalPrice()
        }
    }

    
    func addtopping(name: String){
        self.topping = name
    }
    
    
    // 畫面載入時 取得飲料 的 大杯、中杯(如果有) 的價錢
    func getDrinkPrice(sizeL: Int ,sizeM: Int?){
        drinkPriceL = sizeL
        drinkPriceM = sizeM ?? 0
    }
    
    // 要顯示目前選取的 價錢 + 配料(如果有)
    // 在 selectedSize & addtoping 動作時 呼叫這個func
    func getCurrentTotalPrice(){
        
        currentTotalPrice = 0
        
        // Size 容量
        if sizeSelected == "L" {
            currentTotalPrice = drinkPriceL
        } else if sizeSelected == "M" {
            guard drinkPriceM != 0 || drinkPriceM != 9999 else { print("飲料中杯價格有誤") ; return } // 多設一層保護
            currentTotalPrice = drinkPriceM
        }
        
        // topping 配料
        if topping != "" {
            if topping == "珍珠" || topping == "仙草凍" {
                currentTotalPrice += 5
            } else if topping == "綠茶凍" || topping == "小芋圓" {
                currentTotalPrice += 10
            } else if topping == "杏仁凍" || topping == "米漿凍" || topping == "豆漿凍" {
                currentTotalPrice += 15
            } else if topping == "奶霜" {
                currentTotalPrice += 20
            }
        }
        
        // amount 數量
        currentTotalPrice *= amount
    }
    
}
