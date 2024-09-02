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
        ZStack {
            VStack(spacing: 10){
                
                HStack(spacing: 15){
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .foregroundColor(Color("pinky"))
                    }
                    
                    Text(HomeVM.userLocation == nil ? "Locating..." : "Deliver To")
                        .foregroundColor(.black)
                    
                    Text(HomeVM.userAddress)
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
            
            // Non Closable Alert If Permission Denied
            if HomeVM.noLocation {
                Text("Please Enable Location Access In Settings To Further Move On!")
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 100, height: 120)
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3).ignoresSafeArea())
            }
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
