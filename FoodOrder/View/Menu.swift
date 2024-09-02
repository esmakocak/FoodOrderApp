//
//  Menu.swift
//  FoodOrder
//
//  Created by Esma Koçak on 2.09.2024.
//

import SwiftUI

struct Menu: View {
    @ObservedObject var homeData : HomeViewModel
    var body: some View {
            
        VStack{
            Button {
                
            } label: {
                HStack(spacing: 15){
                    Image(systemName: "cart")
                        .font(.title)
                        .foregroundColor(Color("pinky"))
                    
                    Text("Cart")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer(minLength: 0)
                }
                .padding()
            }

        }
    }
}

#Preview {
    Menu(homeData: HomeViewModel())
}
