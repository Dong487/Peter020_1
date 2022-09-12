//
//  HomeView.swift
//  Peter020_1
//
//  Created by DONG SHENG on 2022/8/18.
//


import SwiftUI

struct HomeView: View {
    
    @StateObject private var homeVM = HomeViewModel()
    @State private var BarHidden = true
    
    var body: some View {
        NavigationView {
            TabView{
                
                mainView
                    
                .tabItem {
                    VStack{
                        Image(systemName: "house.fill")
                        Text("首頁")
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                }
                CartView()
                    .tabItem {
                        VStack{
                            Image(systemName: "cart")
                            Text("購物車")
                        }
                        .font(.headline)
                        .foregroundColor(.black)
                      
                        
                    }
                
            }
           
            .task {
                guard homeVM.menu.isEmpty else { return }
                await homeVM.fetchMenu()
        }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(CartViewModel())
    }
}

extension HomeView{
    
    private var mainView: some View{
        
        VStack(spacing: 16){
                
                TabView{
                    ForEach(homeVM.news ,id: \.self){
                        
                            Image($0)
                                .resizable()
    //                        .frame(width: getRect().width * 0.9)
                            
                    }
                }
                .frame(height: getRect().height / 6)
                .tabViewStyle(PageTabViewStyle())
                
                
                HStack(spacing: 6){
                    ForEach(homeVM.filterString ,id: \.self) { name in
                        categoryString(category: name)
                    }
                }
                
                
                DrinkView(SnapCarouselShowIndex: $homeVM.SnapCarouselShowIndex,
                          currentIndex: $homeVM.currentIndex,
                          screenSize: getRect(),
                          item: homeVM.menuFilter)
                .opacity(homeVM.showKeyboard ? 0 : 1)
                
            
                
                
                VStack{
                    Text("找飲料 🧋 🔍")
                        .font(.headline.bold())
                        .foregroundColor(Color("textColor"))
                    
                    TextField("找飲料 !?.", text: $homeVM.searchText)
                        .foregroundColor(Color("textColor"))    // 搜尋欄 輸入的文字顏色
                        .submitLabel(.search)
                        .padding(.horizontal ,4)
                        .padding(.vertical ,2)
                        
                        .background(
                            ZStack{
                                RoundedRectangle(cornerRadius: 8.0)
                                    .fill(.gray.opacity(0.2))
                                    .frame(width: getRect().width * 0.6)
                                
                                RoundedRectangle(cornerRadius: 8.0)
                                    .stroke(Color("textColor") ,lineWidth: 1)
                                    .frame(width: getRect().width * 0.6)
                            }

                            ,alignment: .leading
                        )
                        .overlay(
                            Image(systemName: "xmark.circle.fill")
                                .font(.largeTitle)
                                .padding()
                                .foregroundColor(Color("iconRed"))
                                
                                // 搜尋欄 有文字的話 則顯示出來刪除圖示  opcity(1)
                                .opacity(homeVM.searchText == "" ?  0 : 1)
                                .onTapGesture {
                                    homeVM.searchText = ""     // 點擊後將搜尋欄清空
                                    
                                }
                                .offset(x: 10)
                            
                            ,alignment: .trailing
                        )
                        .padding(.horizontal ,12)
                }
                .padding(.leading)
                
                Spacer()
            }
            .background(Color("Background").ignoresSafeArea())
            .toolbar {
                // 在搜尋時 鍵盤上搜尋飲品建議
                ToolbarItem(placement: .keyboard) {
                    HStack{
                        Button {
                            homeVM.searchText = "紅茶"
                            hideKeyboard()
                            
                        } label: {
                            Text("紅茶")
                        }

                        Button {
                            homeVM.searchText = "綠茶"
                            hideKeyboard()
                            
                        } label: {
                            Text("綠茶")
                        }
                        Button {
                            homeVM.searchText = "奶茶"
                            hideKeyboard()
                            
                        } label: {
                            Text("奶茶")
                        }
                        
                        
                        
                    }
                }
            }
            // 鍵盤偵測到 是打開時
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                homeVM.showKeyboard = true
            }
            // 鍵盤偵測到是 關閉的
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                homeVM.showKeyboard = false
            }
        // 小Bug 有時候會 lag
        .navigationBarTitle("Back") // 重要!! 如果使用 navBar hidden 沒給Title 會多出 BarSpace
        .navigationBarHidden(BarHidden)
               
        
    }
    
    private func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    @ViewBuilder
    private func categoryString(category: String) -> some View{
        Button {
            withAnimation(.easeInOut){
                homeVM.currentFilter = category
            }
            
        } label: {
            Text(category)
                .font(homeVM.currentFilter == category ? .headline.bold() : .callout)
                .foregroundColor(homeVM.currentFilter == category ? Color("accentGold") : .gray)
                .scaleEffect(homeVM.currentFilter == category ? 1.2 : 0.8)
                .padding(.horizontal , homeVM.currentFilter == category ?  8 :  4)
        }

    }
}

extension View{
    func hideKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
