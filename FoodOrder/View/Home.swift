//
//  Home.swift
//  FoodOrder
//
//  Created by Esma Koçak on 1.09.2024.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack(spacing: 10){
            
            HStack(spacing: 15){
                
                Button {
                    
                } label: {
                    Image(systemName: "line.horizontal.3")
                        .font(.title)
                        .foregroundColor(Color("pinky"))
                }

                Text("Deliver To")
                    .foregroundColor(.black)
                
                Text("Apple")
                    .font(.caption)
                    .fontWeight(.heavy)
                    .foregroundColor(Color("pinky"))
            }
            .padding([.horizontal, .top])
            
            Divider()
            
            Spacer()
        }
    }
}

#Preview {
    Home()
}
