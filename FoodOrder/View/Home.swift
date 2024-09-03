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
            
            // MARK: Top Bar
            VStack(spacing: 10){
                
                HStack(spacing: 15){
                    
                    Button {
                        withAnimation(.easeIn) {
                            HomeVM.showMenu.toggle()
                        }
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
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    TextField("Search", text: $HomeVM.search)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Divider()
                
                // MARK: Foods View
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 25) {
                        ForEach(HomeVM.filtered) { item in
                            ZStack(alignment: .topLeading) {
                                ItemView(item: item)
                                    .frame(width: UIScreen.main.bounds.width - 30)
                                    .clipped()

                                HStack {
                                    Text("Free Delivery")
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal)
                                        .background(Color("pinky"))
                                    
                                    Spacer(minLength: 0)
                                    
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "plus")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(Color("pinky"))
                                            .clipShape(Circle())
                                    }

                                } 
                                .padding(.trailing, 10)
                                .padding(.top, 10)
                            }
                            .frame(width: UIScreen.main.bounds.width - 30)
                        }
                    }
                }

                
            }
            
            // MARK: Side Bar
            HStack{
                Menu(homeData: HomeVM)
                //Move effect from left
                    .offset(x: HomeVM.showMenu ? 0 : -UIScreen.main.bounds.width / 1.6)
                
                Spacer(minLength: 0)
            }
            .background(Color.black.opacity(HomeVM.showMenu ? 0.3 : 0).ignoresSafeArea()
                // close side menu when user taps outside
                .onTapGesture {
                    withAnimation(.easeIn) {
                        HomeVM.showMenu.toggle()
                    }
                }
            )
            
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
        .onChange(of: HomeVM.search, perform: { value in
            
            // to avoid continues search request
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                
                if value == HomeVM.search && HomeVM.search != ""{
                    
                    // Search Data
                    HomeVM.filterData()
                }
            }
            
            if HomeVM.search == ""{
                withAnimation(.linear){HomeVM.filtered = HomeVM.items}
            }
            
        })
        
    }
}

#Preview {
    Home()
}
