//
//  CartModel.swift
//  Peter020_1
//
//  Created by DONG SHENG on 2022/8/28.
//

import Foundation

    struct CartModel: Codable ,Identifiable{
        var id: String// var 會error
        
        let drinkName: String       // 飲料名稱
        let drinkImage: String      // 飲料圖片
        let size: String            // 容量
        let iceLevel: String        // 冰塊量
        let sugarLevel: String      // 甜度
        let topping: String         // 配料
        let price: Int              // 價格
        let note: String            // 備註
        let amount: Int             // 數量
        
        init(id: String = UUID().uuidString ,drinkName: String , drinkImage: String ,size: String ,iceLevel: String ,sugarLevel: String ,topping: String ,price: Int ,note: String ,amount: Int ){
            self.id = id
            self.drinkName = drinkName
            self.drinkImage = drinkImage
            self.size = size
            self.iceLevel = iceLevel
            self.sugarLevel = sugarLevel
            self.topping = topping
            self.price = price
            self.note = note
            self.amount = amount
        }
        
    }
