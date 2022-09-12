//
//  MenuModel.swift
//  Peter020_1
//
//  Created by DONG SHENG on 2022/8/18.
//

import Foundation

struct MenuModel: Codable{
//    var id = UUID().uuidString
    let records: [Records]
}

struct Records: Codable,Identifiable{
    let id: String
    var fields: Fields
    let createdTime: String
}

struct Fields: Codable,Identifiable{
    let id = UUID().uuidString // var 會error
    
    let drinkName: String       // 飲料名稱
    let drinkImage: String      // 飲料圖片
    let description: String?    // 商品描述
    let iceLevel: String        // 冰塊量
    let sugarLevel: String      // 甜度
    let priceL: Int             // 價格 (大杯)
    let priceM: Int?             // (中杯) 如果有的話
    let iceOnly: Bool?
    let category: String        // 類別
}

