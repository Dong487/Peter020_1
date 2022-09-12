//
//  Uploader.swift
//  Peter020_1
//
//  Created by DONG SHENG on 2022/9/12.
//

import Foundation

// Order API: "https://api.airtable.com/v0/appVYJY0nhqeef1lG/Order?api_key=keyCp3szS3dTfqTy9"
class Uploader{
    
    @Published var Order: [OrderModel] = []
    let url: String = "https://api.airtable.com/v0/appVYJY0nhqeef1lG/Order?api_key=keyCp3szS3dTfqTy9"
    
    func uploadData(){
        
        for item in Order{
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
    //        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type") // 重要
            request.httpBody = try? JSONEncoder().encode(item)  // 這邊放入 要上傳的data(編碼成JSON)
            
            print(item)
            print("--------上傳中 -------")
            
            
            URLSession.shared.dataTask(with: request).resume()  // 記得要加上 .resume()
            // 主要是利用 dataTask() 來上傳  (也可以只用上面的)
            // 下面可以使用 guard let 來設檢查點 防止錯誤時系統 也方便偵查錯誤
    //        URLSession.shared.dataTask(with: request) { (data, response, error) in
    //            if let data = data {
    //                do{
    ////                    let content = String(data: data, encoding: .utf8) // 顯示所上傳的 轉成 String 方便print()顯示
    ////                    print(content)
    //                    print("cool")
    //                } catch{
    //                    print("上傳失敗")
    //                }
    //            }
    //        }
    //        .resume()
        }
        
        Order.removeAll()
    }
}
