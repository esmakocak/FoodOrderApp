//
//  Home.swift
//  FoodOrder
//
//  Created by Esma Koçak on 1.09.2024.
//

import SwiftUI

struct Home: View {
    
    @StateObject var HomeVM = HomeViewModel()
    
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
                
                Spacer(minLength: 0)
            }
            .padding([.horizontal, .top])
            
            Divider()
            
            HStack(spacing: 15){
                TextField("Search", text: $HomeVM.search)
                
                if HomeVM.search != "" {
                    Button {
                        
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(.gray)
                    } 
                    .animation(.easeIn, value: HomeVM.search)

                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            Divider()
            
            Spacer()
        }
        .onAppear {
            //calling location delegate
            HomeVM.locationManager.delegate = HomeVM
            
        }
    }
}

#Preview {
    Home()
}
