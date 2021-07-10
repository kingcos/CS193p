//
//  AspectVGrid.swift
//  Memorize
//
//  Created by kingcos on 2021/7/10.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    typealias ContentFactory = (Item) -> ItemView
    
    var items: [Item]
    var aspectRatio: CGFloat
    var content: ContentFactory
    
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping ContentFactory) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                let width = widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio)
                LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                    ForEach(items) { content($0).aspectRatio(aspectRatio, contentMode: .fit) }
                }
                Spacer(minLength: 0)
            }
        }
    }
    
    private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            
            columnCount += 1
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        } while itemCount > columnCount
        
        if columnCount > itemCount {
            columnCount = itemCount
        }
        
        return floor(size.width / CGFloat(columnCount))
    }
    
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
}

//struct AspectVGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        AspectVGrid()
//    }
//}
