//
//  DrinkLink.swift
//  Peter020_1
//
//  Created by DONG SHENG on 2022/8/22.
//

// 選擇飲料 (甜度、冰塊)
import SwiftUI

struct DrinkLink: View {
    
    @EnvironmentObject var homeVM: HomeViewModel // 只執行一個功能  選完飲料 回到主頁飲料畫面的 第一項 
    
    @EnvironmentObject var cartVM: CartViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var drinkLinkVM = DrinkLinkViewModel()
    let drink: Fields
    
    // 可給可不給
    init(drink: Fields){
        // 因為是用 let 宣告 所以初始化 要給值
        self.drink = drink
    }
    
    var body: some View {
        ZStack{
            Color("Background")
                .frame(width: getRect().width ,height: getRect().height)
            
            
            VStack(spacing: 12){
                
                imageAndDescription
                customDivider
                
                Group{
                    sizePicker
                    
                    customDivider
                    
                    icePicker
                    
                    customDivider
                    
                    sugarPicker
                    
                    customDivider
                }
                
                Group{
                    toppingPicker
                    
                    customDivider
                    
                    notesView
                    
                    customDivider

                    amountAndPrice
                }
    
                Spacer()
                
                Button {
                    cartVM.addToCart(
                        drinkName: drink.drinkName,
                        drinkImage: drink.drinkImage,
                        size: drinkLinkVM.sizeSelected,
                        iceLevel: drinkLinkVM.iceSelected,
                        sugarLevel: drinkLinkVM.sugarSelected,
                        topping: drinkLinkVM.topping,
                        price: drinkLinkVM.currentTotalPrice,
                        note: drinkLinkVM.notesText,
                        amount: drinkLinkVM.amount)
                    
                    dismiss()
                    homeVM.SnapCarouselShowIndex = 0
                } label: {
                    HStack{
                        Text("加到購物車 ")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color("iconRed"))
                            .cornerRadius(13)
                            .shadow(color: Color("iconRed").opacity(55), radius: 1, x: 1, y: 1)
                        
                    }
                    .offset(y: getRect().height < 750 ? -15 : 0)
                    
                }

            }
            .padding()
            .padding(.top ,35)
            
            .frame(width: getRect().width - 20)
            .frame(height:  getRect().height < 750 ? getRect().height - 50 : getRect().height - 136)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color("accentGold"),
                            style: StrokeStyle(lineWidth: 3)
                           )
            )
            .overlay(
                Image("wooTeaLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: getRect().height < 750 ? 55 : 75)
                    .padding(6)
                    .background(.white)
                    .offset(y: getRect().height < 750 ? -35 : -50)
    
                
                ,alignment: .top
            )
            
        }
        .onAppear {
            // 畫面出現時 把飲料價錢 pass 給 viewModel 以及取得 當前價格
            drinkLinkVM.getDrinkPrice(sizeL: drink.priceL, sizeM: drink.priceM ?? 0)
            drinkLinkVM.getCurrentTotalPrice()
        }
        .background(Color("Background"))
        .offset(y: getRect().height < 750 ? -40 : 0)
        .navigationBarTitleDisplayMode(.inline)
    }
        
}

struct DrinkLink_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
//            HomeView()
            DrinkLink(drink: Fields(drinkName: "一杯紅茶", drinkImage: "https://www.wootea.com/upload/catalog_list_pic/twL_catalog_20K09_jb6mwnsenx.png", description: nil, iceLevel: "去冰", sugarLevel: "固定", priceL: 30, priceM: nil, iceOnly: true, category: "醇茶"))
                .padding(.top ,100)
        }
        .environmentObject(CartViewModel())
        .environmentObject(HomeViewModel())
        
    }
}

extension DrinkLink{
    
    // 圖片和商品描述 (最上面)
    private var imageAndDescription: some View{
        HStack{
            CacheAsyncImage(url: URL(string: drink.drinkImage)!){ phase in
                switch phase{
                case .success(let returnedImage):
                    returnedImage
                        .resizable()
                        .scaledToFit()
                        .frame(height: getRect().height / 6)
                        .rotationEffect(Angle(degrees: 13))
                        .shadow(color: .black.opacity(0.86), radius: 0.5, x: 0.6, y: 0.6)
                        .shadow(color: .black.opacity(0.6), radius: 1, x: 1, y: 1)
                case .empty:
                    Image(systemName: "questionmark")
                        .resizable()
                        .scaledToFit()
                        .frame(height: getRect().height / 6)
                case .failure:
                    Image(systemName: "questionmark")
                        .resizable()
                        .scaledToFit()
                        .frame(height: getRect().height / 6)
                        .padding(.horizontal ,10)
                default:
                    Image(systemName: "questionmark")
                        .frame(width: getRect().width / 4)
                        .padding(.horizontal ,10)
                }
            }
            
            VStack(alignment: .leading,spacing: 8){
                HStack{
                    Text(drink.drinkName)
                        .font(.callout.bold())
                        .foregroundColor(Color("textColor"))
                    
                    Spacer()
                    
                    HStack(spacing: 6){
                        Text("L")
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color("iconRed"))
                            .clipShape(Circle())
                        
                        Text("\(drink.priceL)")
                            .font(.callout.bold())
                            .foregroundColor(Color("textColor"))
                    }
                    
                    if drink.priceM != nil{
                        HStack(spacing: 6){
                            Text("M")
                                .font(.caption2.bold())
                                .foregroundColor(.white)
                                .padding(3)
                                .background(Color("iconRed"))
                                .clipShape(Circle())
                            
                            Text("\(drink.priceM ?? 9999)")
                                .font(.callout.bold())
                                .foregroundColor(Color("textColor"))
                        }
                    }
                }
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(.gray)
                    .frame(width: getRect().width / 2 , height: 1.5)
                
                Text(drink.description ?? "讚 👍🏻")
                    .font(.caption)
                    .foregroundColor(Color("textColor"))
                
                Spacer()
            }
            .padding(.top ,10)
            .frame(height: getRect().height / 6)
        }
        .frame(height: getRect().height / 6)
    }
    
    // Size 容量
    private var sizePicker: some View{
        HStack{
            Text("容量 : ")
            
            if drink.priceM != nil{
                Picker(selection: $drinkLinkVM.sizeSelected) {
                    ForEach(drinkLinkVM.sizeOptions.indices ,id: \.self){ index in
                        Text(drinkLinkVM.sizeOptions[index])
                            .tag(drinkLinkVM.sizeOptions[index])
                    }
                } label: {
                    
                }
                .pickerStyle(SegmentedPickerStyle())

            } else {
                Text("大杯 (L)")
            }
            
            Spacer()
        }
        .font(.body.bold())
        .foregroundColor(Color("textColor"))
    }
    
    // Ice 冰度
    private var icePicker: some View{
        HStack{
            Text("冰度 : ")
            
            // 不是 固定冰量 且 不限冷飲
            if drink.iceLevel != "固定" && drink.iceOnly != true {
                Picker(selection: $drinkLinkVM.iceSelected) {
                    ForEach(drinkLinkVM.iceOptions.indices ,id: \.self){ index in
                        Text(drinkLinkVM.iceOptions[index])
                            .tag(drinkLinkVM.iceOptions[index])
                    }
                } label: {
                    
                }
                .pickerStyle(SegmentedPickerStyle())
                
            } else if drink.iceLevel != "固定" && drink.iceOnly == true {
                // 不是 固定冰量 但 限冷飲
                Picker(selection: $drinkLinkVM.iceSelected) {
                    ForEach(drinkLinkVM.iceOptions2.indices ,id: \.self){ index in
                        Text(drinkLinkVM.iceOptions2[index])
                            .tag(drinkLinkVM.iceOptions2[index])
                    }
                } label: {
                    
                }
                .pickerStyle(SegmentedPickerStyle())
            } else {
                // 固定
                Text("冰量固定 (無法調整)")
            }
            
            Spacer()
        }
        .font(.body.bold())
        .foregroundColor(Color("textColor"))
    }
    
    // Sugar 甜度
    private var sugarPicker: some View{
        HStack{
            Text("甜度 : ")
            
            if drink.sugarLevel != "固定"{
                Picker(selection: $drinkLinkVM.sugarSelected) {
                    ForEach(drinkLinkVM.sugarOptions.indices ,id: \.self){ index in
                        Text(drinkLinkVM.sugarOptions[index])
                            .tag(drinkLinkVM.sugarOptions[index])
                    }
                } label: {
                    
                }
                .pickerStyle(SegmentedPickerStyle())

            } else {
                Text("甜度固定 (無法調整)")
            }
            
            Spacer()
        }
        .font(.body.bold())
        .foregroundColor(Color("textColor"))
    }
    
    // topping 配料
    private var toppingPicker: some View{
        VStack{
            HStack{
                Text("配料加點 (最多可選擇一項): ")
                Spacer()
            }
            .font(.body.bold())
            .foregroundColor(Color("textColor"))
            
            HStack(spacing: 0){
                VStack(alignment: .leading){
                    toppingButton(name: "珍珠")
                    toppingButton(name: "小芋圓")
                    toppingButton(name: "豆漿凍")

                }
                .frame(width: (getRect().width - 55) / 3 )
                .frame(height: 100)
                
                VStack(alignment: .leading){
                    toppingButton(name: "仙草凍")
                    toppingButton(name: "杏仁凍")
                    toppingButton(name: "奶霜")
                }
                .frame(width: (getRect().width - 55) / 3 )
                .frame(height: 100)
                
                VStack(alignment: .leading){
                    toppingButton(name: "綠茶凍")
                    toppingButton(name: "米漿凍")
                    Spacer()
                }
                .frame(width: (getRect().width - 55) / 3 )
                .frame(height: 100)
            }
            
        }
    }
    
    private var notesView: some View{
        HStack{
            
           Text("備註 : ")
                .font(.body.bold())
                .foregroundColor(Color("textColor"))

            TextField("Ex: 不要酸菜...", text: $drinkLinkVM.notesText)
                .foregroundColor(Color("textColor"))    // 搜尋欄 輸入的文字顏色
                .padding(.horizontal ,4)
                .padding(.vertical ,2)
                .background(
                    ZStack{
                        RoundedRectangle(cornerRadius: 8.0)
                            .fill(.gray.opacity(0.12))
                            .frame(width: getRect().width * 0.6)
                        
                        RoundedRectangle(cornerRadius: 8.0)
                            .stroke(Color("textColor") ,lineWidth: 1)
                            .frame(width: getRect().width * 0.6)
                    }

                    ,alignment: .leading
                )
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .foregroundColor(Color("iconRed"))
                        // 搜尋欄 有文字的話 則顯示出來刪除圖示  opcity(1)
                        .opacity(drinkLinkVM.notesText == "" ?  0 : 1)
                        .onTapGesture {
                            drinkLinkVM.notesText = ""     // 點擊後將搜尋欄清空
                        }
                        .offset(x: 10)
                    
                    ,alignment: .trailing
                )
            
            Spacer()
        }
        .font(.headline)
    }
    
    private var amountAndPrice: some View{
        HStack{
            Text("數量 : ")
                .font(.body.bold())
            
            HStack(spacing: 6){
                Button {
                    guard drinkLinkVM.amount > 1 else { return }
                    drinkLinkVM.amount -= 1
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(Color("accentGold"))
                }
                
                Text("\(drinkLinkVM.amount)")
                    .frame(width: getRect().width / 8)
                    
                
                Button {
                    guard drinkLinkVM.amount < 999 else { return }
                    drinkLinkVM.amount += 1
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color("accentGold"))
                }
            }
            
            Spacer()
            
            Text("金額 ")
            Text("\(drinkLinkVM.currentTotalPrice)")
                .font(.title.bold())
                .foregroundColor(Color("iconRed"))
            

        }
        .font(.title3)
        .foregroundColor(Color("textColor"))
    }
    
    @ViewBuilder
    private func toppingButton(name: String) -> some View{
        Button {
            
            guard drinkLinkVM.topping != name else {
                drinkLinkVM.topping = ""
                return
            }
            withAnimation(.easeInOut){
                drinkLinkVM.addtopping(name: name)
            }
        } label: {
            HStack(spacing: 0){
                Image(systemName: "circle")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .overlay(
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 23, height: 23)
                            .offset(x: 3,y: -5)
                            .opacity(drinkLinkVM.topping == name ? 1 : 0)
                    )

                Text(name)
                    .padding(.leading ,5)
                Text(name == "珍珠" || name == "仙草凍" ? "+5" : name == "綠茶凍" ||  name == "小芋圓" ? "+10" : name == "杏仁凍" ||  name == "米漿凍" || name == "豆漿凍" ? "+15" : "+20")
                
            }
            .font(.caption)
            .foregroundColor(Color("iconRed"))
            
            
        }
    }
    
    
    // notes 的 TextField 修飾邊框用
    private var textFieldBorder: some View{
        RoundedRectangle(cornerRadius: 6)
            .stroke(Color("accentGold") ,lineWidth: 1)
    }
    
    private func getRect() -> CGRect{
        return UIScreen.main.bounds
    }
    
    private var customDivider: some View{
        RoundedRectangle(cornerRadius: 25)
            .fill(.gray.opacity(0.75))
            .frame(width: getRect().width - 40 , height: 1)
    }
}
