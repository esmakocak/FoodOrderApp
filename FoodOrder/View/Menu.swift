//
//  Menu.swift
//  FoodOrder
//
//  Created by Esma Koçak on 2.09.2024.
//

import SwiftUI

struct Menu: View {
    @ObservedObject var homeData: HomeViewModel
    var body: some View {
        
        VStack {
            NavigationLink(destination: CartView(homeData: homeData)) {
                HStack(spacing: 15) {
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
            
            Spacer()
        }
        .padding([.top, .trailing])
        .frame(width: UIScreen.main.bounds.width / 2)
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    Menu(homeData: HomeViewModel())
}
