//
//  DrinkView.swift
//  Peter020_1
//
//  Created by DONG SHENG on 2022/8/21.
//
// SnapCarousel -> asyncImage -> CacheAsyncImage
import SwiftUI

struct DrinkView: View {
    
    @Binding var SnapCarouselShowIndex: Int
    @Binding var currentIndex: Int
    let screenSize: CGRect
    let item: [Fields]
    
    var body: some View {
        
        SnapCarousel(spacing: screenSize.height < 750 ? 12 : 20,
                     trailingSpace: screenSize.height < 750 ? 100 : 150,
                     index: $currentIndex,
                     item: item,
                     currentIndex: $SnapCarouselShowIndex) { post in

            VStack(spacing: 10){
                GeometryReader{ proxy in

                    let size = proxy.size
                    
                    VStack{
        
                        CacheAsyncImage(url: URL(string: post.drinkImage)!){ phase in
                            switch phase{
                            case .success(let returnedImage):
                                returnedImage
                                    .resizable()
                                    .scaledToFit()
                                    .rotationEffect(Angle(degrees: 13))
                                    .shadow(color: .black.opacity(0.86), radius: 0.5, x: 0.6, y: 0.6)
                                    .shadow(color: .black.opacity(0.6), radius: 1, x: 1, y: 1)
                                    .background(
                                        Circle()
                                            .fill(
                                                RadialGradient(
                                                    colors: [Color.white.opacity(0.8) , .gray.opacity(0.65)],
                                                    center: .center,
                                                    startRadius: 35,
                                                    endRadius: size.width / 2)
                                            )
                                            .opacity(0.35)
                                            .rotation3DEffect(
                                                Angle(degrees: 190),
                                                axis: (x: -2.0 ,y: -4.0 ,z: 10.0))
                                            .offset(y: size.height / 8)
                                    )
                            case .empty:
                                ProgressView()
                            case .failure:
                                Image(systemName: "questionmark")
                                    .font(.headline)
                            default:
                                Image(systemName: "questionmark")
                                    .font(.headline)
                            }
                        }
                        .frame(width: size.width ,height: size.height / 1.5)
                        
                        
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .trim(from: 0.08, to: 0.94)
                                .stroke(Color("accentGold"),
                                        style: StrokeStyle(lineWidth: 3)
                                       )
//                                .frame(width: size.width)
                                .frame(width:  screenSize.height < 750 ? size.height / 1.5 :  size.width ,height: screenSize.height < 750 ? size.width : size.height / 1.5)
                                .rotationEffect(Angle(degrees: 270))
                                .offset(y: size.height / 6)
                        )
                        .overlay(
                            VStack(spacing: 8){
                                
                                HStack{
                                    Text("L")
                                        .font(.callout.bold())
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color("iconRed"))
                                        .clipShape(Circle())
                                    
                                    Text("\(post.priceL)")
                                        .font(.callout.bold())
                                        .foregroundColor(Color("textColor"))
                                }
                                if post.priceM != nil{
                                    HStack{
                                        Text("M")
                                            .font(.caption.bold())
                                            .foregroundColor(.white)
                                            .padding(6)
                                            .background(Color("iconRed"))
                                            .clipShape(Circle())
                                        
                                        Text("\(post.priceM ?? 999)") // 正常來說 999 不可能會出現
                                            .font(.callout.bold())
                                            .foregroundColor(Color("textColor"))
                                    }
                                }
                                
                            }
                                .offset(x: 17  ,y: size.height / 5)
                            
                            ,alignment: .topLeading
                        )
                        
                        Text(post.drinkName)
                            .font(.headline.bold())
                            .foregroundColor(Color("textColor"))
                        
                        NavigationLink {
                            DrinkLink(drink: post)
                                .environmentObject(HomeViewModel())
                                
                        } label: {
                            Text("BUY NOW")
                        }
//                        Rectangle()
//                            .fill(.yellow)
//                            .frame(width: size.width ,height: size.height / 3)
                    }
                }
                .frame(height: screenSize.height / 2.5) // 螢幕總高度 的 4分之1
                .padding(.top ,screenSize.height > 750 ? screenSize.height * 0.12 : screenSize.height * 0.12)
                
            

            }
        }
    }
}

struct DrinkView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
