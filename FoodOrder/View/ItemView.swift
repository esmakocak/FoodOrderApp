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
                        .clipped()
                        .overlay(
                            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]),
                                           startPoint: .top,
                                           endPoint: .bottom)
                            .frame(height: 100)
                                .edgesIgnoringSafeArea(.bottom)
                            , alignment: .bottom
                        )
                } else if phase.error != nil {
                    // Handle the error, show a placeholder or an error image
                    Text("Failed to load image")
                        .foregroundColor(.red)
                } else {
                    // Placeholder while loading
                    ProgressView()
                }
            }
            
            // MARK: Item's Name and Rating
            HStack(spacing: 8){
                Text(item.item_name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer(minLength: 0)
                
                // Ratings View
                ForEach(1...5, id: \.self){ index in
                    Image(systemName: "star.fill")
                        .foregroundColor(index <= Int(item.item_ratings) ?? 0 ? Color("pinky") : .gray)
                    
                }
            }
            
            // MARK: Item's Detail 
            HStack{
                Text(item.item_details)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                Spacer(minLength: 0)
                
            }
        }
        .padding(.bottom, 10)
    }
}

#Preview {
    ItemView(item: Item(id: "1", item_name: "patates", item_cost: 40, item_details: "delicious patatoess, with coke and souces.", item_image: "https://d17wu0fn6x6rgz.cloudfront.net/img/w/tarif/mgt/patates-kizartmasi.webp", item_ratings: "4"))
}
