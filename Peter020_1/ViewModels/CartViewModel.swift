//
//  CartViewModel.swift
//  Peter020_1
//
//  Created by DONG SHENG on 2022/8/28.
//

import Foundation

class CartViewModel: ObservableObject{
    
    @Published var shoppingCartData: [CartModel] = []
    let upLoader = Uploader()
    
    @Published var showAlert: Bool = false
    @Published var showCompletionMessage: Bool = false
    @Published var userName: String = ""
    @Published var phoneNumber: String = ""
    
    var dateFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        
        return formatter
    }
    
    
    
    func addToCart(drinkName: String, drinkImage: String ,size: String ,iceLevel: String ,sugarLevel: String ,topping: String ,price: Int ,note: String ,amount: Int){
        let newItem = CartModel(drinkName: drinkName, drinkImage: drinkImage, size: size, iceLevel: iceLevel, sugarLevel: sugarLevel, topping: topping, price: price, note: note ,amount: amount)
        
        self.shoppingCartData.append(newItem)
        print("ServieData \(newItem)")
    }
    
    // 物理拖拉刪除
    func deleteItem(indexSet: IndexSet){
        shoppingCartData.remove(atOffsets: indexSet)
    }
    
    // 按鈕刪除 -> 在項目中可能會有完全一樣的項目 所以利用id尋找唯一的項目 (此App 用 uuidString)
    func deleteItemButton(id: String){

        if let index = shoppingCartData.firstIndex(where: {$0.id == id}){
            print(index)
            shoppingCartData.remove(at: index)
        } else {
            print("找不到==")
        }
    }
    
    // 商品的總數量
    func filterTotalAmount() -> Int{
        let totalAmount = shoppingCartData.reduce(0){ $0 + $1.amount}
        return totalAmount
    }
    
    // 結帳的總計
    func filterTotalPrice() -> Int{
        let totalPrice = shoppingCartData.reduce(0){ $0 + $1.price}
        return totalPrice
    }
    
    // 確認訂單: 將 購物車 -> 訂單 -> 上傳至AirTable
    func addToOreder(){
//    shoppingcartArray: [CartModel]
        for item1 in shoppingCartData{
            let newItem = OrderModel(
                records: [.init(
                    fields:
                        .init(
                            drinkName: item1.drinkName,
                            drinkPrice: item1.price,
                            drinkImage: item1.drinkImage,
                            
                            size: item1.size,
                            iceLevel: item1.iceLevel,
                            sugarLevel: item1.sugarLevel,
                            
                            topping: item1.topping,
                            amount: item1.amount,
                            totalPrice: item1.price * item1.amount,
                            
                            notes: item1.note,
                            
                            userName: userName,
                            userPhoneNumber: phoneNumber,
                            date: dateFormatter.string(from: Date())
                           )
                    
                )
            ])
            print(newItem)
            upLoader.Order.append(newItem)
            upLoader.uploadData()
        }
    }
}
