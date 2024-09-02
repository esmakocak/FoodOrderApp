//
//  ItemView.swift
//  FoodOrder
//
//  Created by Esma Koçak on 2.09.2024.
//

import SwiftUI

struct ItemView: View {
    var item: Item
    var body: some View {
        VStack{
            
            // MARK: Fetch Image
            AsyncImage(url: URL(string: item.item_image)) { phase in
                if let image = phase.image {
                    // Image successfully loaded
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                } else if phase.error != nil {
                    // Handle the error, show a placeholder or an error image
                    Text("Failed to load image")
                        .foregroundColor(.red)
                } else {
                    // Placeholder while loading
                    ProgressView()
                }
            }
            
            
        }
    }
}

#Preview {
    ItemView(item: Item(id: "1", item_name: "patates", item_cost: 40, item_details: "çok lezziz", item_image: "https://d17wu0fn6x6rgz.cloudfront.net/img/w/tarif/mgt/patates-kizartmasi.webp", item_ratings: "4"))
}
