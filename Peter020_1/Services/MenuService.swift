//
//  MenuService.swift
//  Peter020_1
//
//  Created by DONG SHENG on 2022/8/18.
//


// https://api.airtable.com/v0/appVYJY0nhqeef1lG/Menu?api_key=keyCp3szS3dTfqTy9
// key: keyCp3szS3dTfqTy9

import Foundation

class MenuService{
    
    let url: String = "https://api.airtable.com/v0/appVYJY0nhqeef1lG/Menu?api_key=keyCp3szS3dTfqTy9"
//    let apiKey: String = "keyCp3szS3dTfqTy9"
    
    func getNewsData() async throws -> MenuModel {
        guard let url = URL(string: url) else {
            throw APIError.invalidURL // 拋出錯誤 讓用戶知道
        }
        
        do {
            let (data ,response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200  else {
                throw APIError.invalidResponseStatus
            }
            print("伺服器響應成功")
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601 // 時間的解碼方式 (有些不行Model type可以改用String)
                decoder.keyDecodingStrategy = .useDefaultKeys
                
                
                // 最常是停止點的地方 (通常是Model 內的屬性、名稱有問題)
                let decodedData = try decoder.decode(MenuModel.self, from: data)
                
                return decodedData
               
            } catch  {
                print("XXX_XXX")
                throw APIError.decodingError(error.localizedDescription)
            }
        } catch  {
            throw APIError.dataTaskError(error.localizedDescription)
        }
    }
}

enum APIError: Error ,LocalizedError{
    case invalidURL                     // 無效網址
    case invalidResponseStatus          // 響應失敗
    case dataTaskError(String)          // Task錯誤
    case corruptData                    // 數據錯誤
    case decodingError(String)          // 解碼錯誤
    
    var errorDescription: String?{
        
        switch self {
        case .invalidURL:
            return NSLocalizedString("The endpoint URL is invalid(無效的URL網址)", comment: "")
        case .invalidResponseStatus:
            return NSLocalizedString("The API failed to issue a valid response(伺服器沒有響應)", comment: "")
        case .dataTaskError(let string):
            return string
        case .corruptData:
            return NSLocalizedString("The data provided appears to be corrupt(數據損毀)", comment: "")
        case .decodingError(let string):
            return string
        }
    }
}
