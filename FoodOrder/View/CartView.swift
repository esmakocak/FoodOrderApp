import SwiftUI

struct CartView: View {
    @ObservedObject var homeData: HomeViewModel
    @Environment(\.presentationMode) var presentationMode

    // Calculating order price
    var totalPrice: Double {
        homeData.cartItems.reduce(0) { $0 + (Double(truncating: $1.item.item_cost) * Double($1.quantity)) }
    }
    
    var body: some View {
        VStack {
            HStack {
                // Custom back button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(Color("pinky"))
                        .padding()
                }
                
                Text("My cart")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
            }
            
            // If the cart is empty
            if homeData.cartItems.isEmpty {
                Text("Your cart is empty")
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding()
                
                Spacer()
            } else {
                // Listing cart items
                ScrollView {
                    ForEach(homeData.cartItems) { cart in
                        HStack(spacing: 15) {
                            // AsyncImage for loading images from URL
                            AsyncImage(url: URL(string: cart.item.item_image)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(8)
                                } else if phase.error != nil {
                                    // If there is an error, show a placeholder
                                    Image(systemName: "exclamationmark.triangle")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(.red)
                                } else {
                                    // While loading, show a placeholder
                                    Image(systemName: "photo")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            // Item details
                            VStack(alignment: .leading, spacing: 8) {
                                Text(cart.item.item_name)
                                    .font(.headline)
                                
                                Text(cart.item.item_details)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                
                                HStack{
                                    Text("$\(cart.item.item_cost.stringValue)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    // Quantity management buttons
                                    HStack(spacing: 10) {
                                        
                                        Button(action: {
                                            // Decrease quantity
                                            if let index = homeData.cartItems.firstIndex(where: { $0.id == cart.id }) {
                                                if homeData.cartItems[index].quantity > 1 {
                                                    homeData.cartItems[index].quantity -= 1
                                                } else {
                                                    // Remove the item if quantity is 1
                                                    homeData.cartItems.remove(at: index)
                                                }
                                            }
                                        }) {
                                            Image(systemName: "minus")
                                                .font(.system(size: 16, weight: .heavy))
                                                .foregroundColor(.black)
                                        }
                                        
                                        // Item Quantity
                                        Text("\(cart.quantity)")
                                            .fontWeight(.heavy)
                                            .foregroundColor(.black)
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 10)
                                            .background(Color.black.opacity(0.06))
                                        
                                        Button(action: {
                                            // Increase quantity
                                            if let index = homeData.cartItems.firstIndex(where: { $0.id == cart.id }) {
                                                homeData.cartItems[index].quantity += 1
                                            }
                                        }) {
                                            Image(systemName: "plus")
                                                .font(.system(size: 16, weight: .heavy))
                                                .foregroundColor(.black)
                                        }
                                        
                                        
                                    }
                                }
                            }
                            
                            
                        }
                        .padding()
                    }
                }
                
                // Total price and checkout button
                VStack {
                    HStack {
                        Text("Total")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text(String(format: "$%.2f", totalPrice))
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                    
                    // Check out button
                    Button(action: {
                        // Complete the order
                    }) {
                        Text("Check out")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("pinky"))
                            .cornerRadius(15)
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CartView(homeData: HomeViewModel())
}
