//
//  HomeViewModel.swift
//  Peter020_1
//
//  Created by DONG SHENG on 2022/8/18.
//

import Foundation

class HomeViewModel: ObservableObject{
    
    // 只在一開始獲取一次Menu 提供 App做使用
    @Published var menu: [Fields] = [] {
        didSet{
            currentFilter = "醇茶"    // 初始值
        }
    }
    let news: [String] = ["news1" ,"news2"] // 可以改接後端
    
    private let service = MenuService()
    
    // drinkView 用
    @Published var currentIndex: Int = 0 // 資料 的
    @Published var SnapCarouselShowIndex: Int = 0 // 顯示的
    
    // 依照 category類別 來顯示 
    @Published var currentFilter = "醇茶"{
        didSet{
            changedItem()
        }
    }
    // 實際在 顯示的 MeunData
    @Published var menuFilter: [Fields] = []
    @Published var filterString = [
        "醇茶" , "奶茶" , "鮮奶" , "奶霜" , "農摘" , "季節限定"
    ]
    @Published var searchText: String = ""{
        didSet{
            guard searchText == "" else {
                currentFilter = ""
                return
            }
            currentFilter = "醇茶"
        }
    }
    @Published var showKeyboard: Bool = false
    
    
    
 
    @MainActor
    func fetchMenu() async {
        do{
            print("ViewModel 呼叫 Service")
            let data = try await service.getNewsData()
            for item in data.records.indices{
                menu.append(data.records[item].fields)
            }

            print(menu)
        } catch{
            print("獲取 Menu失敗")
        }
    }
    
    private func changedItem(){
        
        currentIndex = 0
        SnapCarouselShowIndex = 0 // 點選 種類 後跳回第一項Array[0] index = 0
        menuFilter.removeAll()
        guard searchText != "" else {
            menuFilter = menu.filter{ $0.category == currentFilter }
            return
        }
        menuFilter = menu.filter{ $0.drinkName.contains(searchText)}
    }
}
