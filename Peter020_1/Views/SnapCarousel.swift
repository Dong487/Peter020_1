//
//  SnapCarousel.swift
//  Peter020_1
//
//  Created by DONG SHENG on 2022/8/21.
//

import SwiftUI

// T -> List用
// 主要是透過 拖拉判斷 更改 -> index
struct SnapCarousel<Content: View ,T: Identifiable> : View {
    
    var content: (T) -> Content
    var list: [T]
    
    // 屬性
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    
    // Offset用
    @GestureState var offset: CGFloat = 0
    @Binding var currentIndex: Int  // @State -> @Binding
    
    // 這邊的 spacing、trailingSpace 在呼叫時都可以做調整
    init(
        spacing: CGFloat = 15, trailingSpace: CGFloat = 100,
        index: Binding<Int> ,item: [T],
        currentIndex: Binding<Int>,
        @ViewBuilder content: @escaping (T) -> Content
        
    ){
        self.list = item
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index // Binding 要加_
        self._currentIndex = currentIndex
        self.content = content
        
    }
    
    var body: some View{
        
        GeometryReader { proxy in
            
            // Setting correct Width for snap Carousel 設置正確的寬度給 snapCarousel
            
            // One sided snap Carousel
            let width =  proxy.size.width -  (trailingSpace - spacing)
            let adjustMentWidth = (trailingSpace / 2) - spacing
            
            LazyHStack(spacing: spacing){
                
                ForEach(list){ item in
                    
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                        .offset(
                            y:getOffset(item: item , width: width)
                        )
                }
            }
            .padding(.horizontal ,spacing)
            // Setting only after 0th index 第一項 (index == 0) 不設置偏移量 因為第一項顯示於畫面偏左一點 其他則是置中
            .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustMentWidth : 0) + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded({ value in
                        
                        // Updating Current Index
                        let offsetX = value.translation.width
                        
                        // were going to convert the translation into progress (0 - 1) 轉換成 百分比?
                        // and round the value 並四捨五入
                        // based on the progress increasing or decreasing the currentIndex 根據這個值 來 更動 currentIndex
                        let progress = -offsetX / width
                        
                        let roundIndex = progress.rounded()
                        
                        // setting min 設定 範圍
                        currentIndex = max( min(currentIndex + Int(roundIndex) , list.count - 1) , 0)
                        
                        // updating index
                        currentIndex = index
                    })
                    .onChanged({ value in
                        
                        // Updating Current Index
                        let offsetX = value.translation.width
                        
                        // were going to convert the translation into progress (0 - 1) 轉換成 百分比?
                        // and round the value 並四捨五入
                        // based on the progress increasing or decreasing the currentIndex 根據這個值 來 更動 currentIndex
                        let progress = -offsetX / width
                        
                        let roundIndex = progress.rounded()
                        
                        // setting min 設定 範圍
                        index = max( min(currentIndex + Int(roundIndex) , list.count - 1) , 0)
                    })
            )
        }
        // Animating when offset = 0 偏移時動畫
        .animation(.easeInOut, value: offset == 0)
    }
    
    // 移動 Scrollview的偏移 (大小、位移)
    func getOffset(item: T ,width: CGFloat) -> CGFloat{
        
        // Progress
        // Shifting current item to top 將當前項目移動至top
        let progress = ((offset < 0 ? offset : -offset) / width) * 60
        
        // max 60
        // then again minus from 60
        // 向上位移幅度
        let topOffset = -progress < 60 ? progress : -(progress + 120)
        
        // 前一個
        let previous = getIndex(item: item) - 1 == currentIndex ? (offset < 0 ? topOffset : -topOffset) : 0
        
        let next = getIndex(item: item) + 1 == currentIndex ? (offset < 0 ? -topOffset : topOffset) : 0
        
        // safey check between 0 to max list size
        // 判斷 是前一個還是下一個
        let checkBetween = currentIndex >= 0 && currentIndex < list.count ? (getIndex(item: item) - 1 == currentIndex ? previous : next) : 0
        
        // checking current
        // if so shifting view to top
        // 如果是當前的index 往上 其他則往螢幕兩側下滑
        return getIndex(item: item) == currentIndex ? -60 - topOffset : checkBetween
    }
    
    // 取得 Index數字
    func getIndex(item: T) -> Int{
        let index = list.firstIndex { currentItem in
            return currentItem.id == item.id
        } ?? 0
        return index
    }
}
    

struct SnapCarousel_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
