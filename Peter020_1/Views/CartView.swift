//
//  CartView.swift
//  Peter020_1
//
//  Created by DONG SHENG on 2022/8/28.
//

import SwiftUI

struct CartView: View {
    
    @EnvironmentObject var cartVM:  CartViewModel
    
    init(){
        UINavigationBar.appearance().titleTextAttributes = [ .foregroundColor: UIColor.black]
    
    }
    
    var body: some View {
        
        NavigationView {
            // 可以放入不同類型的View (靜態+動態)
            List{
                // 如果沒有要插入其他的 View
                // 也可以直接用 List 讀Data
                
                ForEach(cartVM.shoppingCartData){ item in
                    HStack{
                        
                        CacheAsyncImage(url: URL(string: item.drinkImage)!){ phase in
                            switch phase{
                            case .success(let returnedImage):
                                returnedImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: getRect().height / 6 - 20)
                                    .rotationEffect(Angle(degrees: 13))
                                    .shadow(color: .black.opacity(0.7), radius: 0.8, x: 1, y: 1)
                                    .shadow(color: .black.opacity(0.5), radius: 1.2, x: 1.2, y: 1.2)
                            case .empty:
                                Image(systemName: "questionmark")
                                    .resizable()
                                    .frame(width: getRect().width / 4)
                                    .padding(.horizontal ,10)
                            case .failure:
                                Image(systemName: "questionmark")
                                    .frame(width: getRect().width / 4)
                                    .padding(.horizontal ,10)
                            default:
                                Image(systemName: "questionmark")
                                    .frame(width: getRect().width / 4)
                                    .padding(.horizontal ,10)
                            }
                        }
                        
                        VStack(alignment: .leading ,spacing: 6){
                            Text(item.drinkName) + Text("  ( \(item.size) )")
                            
                            Text("冰度: \(item.iceLevel)")
                                .font(.caption)
                            Text("甜度: \(item.sugarLevel)")
                                .font(.caption)
                            
                            HStack{
                                Text("備註: \(item.note == "" ? "(無)" : item.note)")
                                    
                                Spacer()
                                
                                if item.topping != ""{
                                    Text("加料: \(item.topping)")
                                        .foregroundColor(.pink)
                                }
                                
                            }
                            .font(.caption)
                            
                            HStack{
                                Text("數量: \(item.amount) 杯")
                                    .foregroundColor(Color("accentGold"))
                                
                                Spacer()
                                
                                Text("$ \(item.price)")
                                    .foregroundColor(Color("iconRed"))
                                    .padding(.trailing ,10)
                            }
                            
                        }
                        .font(.callout.bold())
                        .foregroundColor(Color("textColor"))
                        .frame(width: getRect().width / 2)
                        .padding()
                        
                        
                        
                    }
                    // HStack (單個View完)
                    .overlay(
                        Button {
                            cartVM.deleteItemButton(id: item.id)
                        } label: {
                            Image(systemName: "multiply.square.fill")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 30 ,height: 30)
                                
                            
                        }
                            .buttonStyle(BorderlessButtonStyle())
                            .frame(width: 30)
                            .offset(x: getRect().width * 0.47) // 位移要放在 button 上 如果放在 Image會造成 點擊位置 是在位移前
                    )
                    .background(
                        Color("Background")
                            .frame(width: getRect().width * 0.95)
                            .frame(height: 158)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.25), radius: 0.5, x: -0.2, y: -0.2)
                            .shadow(color: .black.opacity(0.75), radius: 0.7, x: 0.8, y: 0.8)
                            .shadow(color: .black.opacity(0.55), radius: 1.2, x: 1.2, y: 1.2)
                    )
                }
                // ForEach (完)
                
                .onDelete(perform: cartVM.deleteItem)
                .listRowSeparator(.hidden)
                .listRowBackground(Color("Background")) // List背景透明
                .padding(.horizontal)
            }
            // List (完)
            
            .listStyle(PlainListStyle())
            .background(Color("Background"))
            .navigationTitle("購物車 🛒")
            .navigationBarTitleDisplayMode(.inline)
            
            // 總數量、總價
            .overlay(Information)
            .overlay(
                Text("購物車內 空空空空如也 🙃")
                    .font(.title2).bold()
                    .foregroundColor(Color("textColor"))
                    .opacity(cartVM.shoppingCartData.count < 1 ? 1 : 0)
            )
            .overlay(
                personalInfomationAlert
            )
            
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
            .environmentObject(CartViewModel())
    }
}

extension CartView{
    
    private func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    // 飲料資訊 總杯數、總價格
    private var Information: some View{
       Circle()
            .stroke(Color("iconRed"),
                    style:
                        StrokeStyle(
                            lineWidth: 7,
                            lineCap: .butt,
                            dash: [3]
                        )
            )
            .frame(width: 100,height: 100)
//            .background(.ultraThinMaterial)
            .background(.white.opacity(0.75))
            .clipShape(Circle())
            .overlay(
                VStack(spacing: 7){
                    Text("數量 \(cartVM.filterTotalAmount())")
                        .foregroundColor(Color("accentGold"))
                        .lineLimit(1)
                        .frame(width: 90)
                    Rectangle()
                        .fill(Color("textColor"))
                        .frame(width: 65, height: 0.7, alignment: .center)
                    
                    Text("$ \(cartVM.filterTotalPrice())")
                        .lineLimit(1)
                        .foregroundColor(Color("iconRed"))
                        .frame(width: 90)
                }
                    
                    .shadow(color: Color.white, radius: 1, x: 1, y: 1)
                    .shadow(color: Color("iconRed").opacity(0.15), radius: 1.2, x: 1, y: -1)
            )
            .overlay(
                Button {
//                    cartVM.addToOreder()
                    cartVM.showAlert.toggle()
                } label: {
                   Text("送出訂單")
                        .font(.callout.bold())
                        .foregroundColor(.white)
                        .padding(.vertical ,6)
                        .padding(.horizontal)
                        .background(
                           RoundedRectangle(cornerRadius: 15)
                            .fill(Color("iconRed").opacity(0.55))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.white)
                                    .shadow(color: Color("iconRed"), radius: 0.6, x: -0.4, y: -0.4)
                            )
                        )
                        .frame(width: 100)
                        .shadow(color: Color("textColor").opacity(0.6), radius: 1, x: 1, y: 1)
                        
                }
                    .offset(y: 75)
//                    .alert("請輸入您的 名稱、手機", isPresented: $cartVM.showAlert){
//                        Button("OK!"){
//
//                        }
//                    } message: {
//
//                            Text("名稱:")
//                            Text("手機:")
//
//                    }
                    
                
            )
            .opacity(cartVM.filterTotalAmount() < 1 ? 0 : 1)
            .position(x: getRect().width - 90, y: getRect().height - 300)
          
    }
    
    // iOS 16 可以直接 在 Alert 內 的 message 加上 TextField
    private var personalInfomationAlert: some View {
        ZStack{
            Color.black.opacity(0.35).ignoresSafeArea()
            
            VStack{
                Text("請輸入您的 名稱、手機")
                    .font(.callout.bold())
                    .foregroundColor(Color("textColor"))
                
                HStack{
                    Text("名稱: ")
                        .font(.caption)
                        .foregroundColor(Color("textColor"))
                    TextField("(name)", text: $cartVM.userName)
                        .font(.caption)
                        .foregroundColor(Color("iconRed"))
                        
                }
                HStack{
                    Text("手機: ")
                        .font(.caption)
                        .foregroundColor(Color("textColor"))
                    TextField("(number)", text: $cartVM.phoneNumber)
                        .font(.caption)
                        .foregroundColor(Color("iconRed"))
                        .keyboardType(.decimalPad)
                }
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(.gray.opacity(0.75))
                    .frame(width: getRect().width * 0.65 - 40 , height: 1)
                
                HStack{
                    Spacer()
                    Button {
                        cartVM.userName = ""
                        cartVM.phoneNumber = ""
                        cartVM.showAlert.toggle()
                        hideKeyboard()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Button {
                        cartVM.addToOreder()
                        cartVM.showAlert.toggle()
                        cartVM.showCompletionMessage.toggle()
                        cartVM.userName = ""
                        cartVM.phoneNumber = ""
                        hideKeyboard()
                        
                    } label: {
                        Text("OK!")
                            .font(.callout.bold())
                            .foregroundColor(cartVM.userName.count > 1 && cartVM.phoneNumber.count > 8 ? .pink : .gray )
                            
                    }
                    .disabled(cartVM.userName.count > 1 && cartVM.phoneNumber.count > 8 ? false : true)
                    .alert("感謝您的訂購", isPresented: $cartVM.showCompletionMessage) {
                        Button("OK !" ,role: .cancel){
                            cartVM.shoppingCartData.removeAll()
                        }
                    } message: {
                        Text("消費金額: \(cartVM.filterTotalPrice())")
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color.white.cornerRadius(15))
            .frame(width: getRect().width * 0.65, height: 200)
            
        }
            .frame(width: getRect().width, height: getRect().height)
            .opacity(cartVM.showAlert ? 1 : 0)
    }
}



