//
//  OrderModel.swift
//  Peter020_1
//
//  Created by DONG SHENG on 2022/9/12.
//

import Foundation


struct OrderModel: Codable{
    let records: [Records]
    
    struct Records: Codable{
        let fields: Order
    }
    
    struct Order: Codable{
//        let id = UUID()
        let drinkName: String
        let drinkPrice: Int
        let drinkImage: String
        
        let size: String
        let iceLevel:String
        let sugarLevel: String
        let topping: String
        let amount: Int
        let totalPrice: Int
        let notes: String
        
        let userName: String
        let userPhoneNumber: String
        let date: String
    }

}
