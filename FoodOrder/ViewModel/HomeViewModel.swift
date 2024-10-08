//
//  HomeViewModel.swift
//  FoodOrder
//
//  Created by Esma Koçak on 1.09.2024.
//

import SwiftUI
import CoreLocation
import FirebaseAuth
import FirebaseFirestore

// HomeViewModel handles location-related functionality.
class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // CLLocationManager instance to manage location services
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
    
    // Location Details
    @Published var userLocation: CLLocation!
    @Published var userAddress = "" // Stores the user's current address based on the location
    @Published var noLocation = false
    
    // Menu
    @Published var showMenu = false
    
    // Food Data
    @Published var items: [Item] = []
    @Published var filtered: [Item] = []
    
    // Cart Data
    @Published var cartItems : [Cart] = []
    
    // Calculate Order Price
    var totalPrice: Double {
            cartItems.reduce(0) { $0 + (Double(truncating: $1.item.item_cost) * Double($1.quantity)) }
    }
    
    // This method is called whenever the location authorization status changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Checking the user's location access permission status
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("authorized")
            self.noLocation = false
            
            // Request the current location after authorization is allowed,
            // triggering locationManager(_:didUpdateLocations:) to provide the user's location.
            manager.requestLocation()
        case .denied:
            print("denied")
            self.noLocation = true
        default:
            print("unknown")
            self.noLocation = false
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // This method is called when new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations.last
        
        // Extracting address details from the location data
        self.extractLocation()
        self.login()
    }
    
    
    func extractLocation() {
        // Reverse geocoding to convert location coordinates to a human-readable address
        CLGeocoder().reverseGeocodeLocation(self.userLocation) { (res, err) in
            
            guard let safeData = res else { return }
            
            var address = ""
            
            // Extracting the name of the location and locality (e.g., street name, city)
            address += safeData.first?.name ?? ""
            address += ", "
            address += safeData.first?.locality ?? ""
            
            self.userAddress = address
        }
    }
    
    // Anonymous Auth
    func login(){
        Auth.auth().signInAnonymously { (res, err) in
            
            if let error = err {
                print(error.localizedDescription)
                return
            }
            
            if let result = res {
                print("Success \(result.user.uid)")
                
                // after logged in, fetch data
                self.fetchData()
            }
        }
    }
    
    // Fetch food data from firebase
    func fetchData(){
            
        let db = Firestore.firestore()
        
        // Fetching documents from the "Items" collection
        db.collection("Items").getDocuments { (snap, err) in
            
            // Check if the snapshot is not nil
            guard let itemData = snap else { return }
            
            // Mapping documents to Item model objects
            self.items = itemData.documents.compactMap({ (doc) -> Item? in
                
                // Extracting values safely with default values if nil
                let id = doc.documentID
                let name = doc.get("item_name") as? String ?? "Unknown Name"
                let cost = doc.get("item_cost") as? NSNumber ?? 0
                let ratings = doc.get("item_ratings") as? String ?? "No Ratings"
                let image = doc.get("item_image") as? String ?? "No Image"
                let details = doc.get("item_details") as? String ?? "No Details"
                
                // Returning an Item object
                return Item(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_ratings: ratings)
            })
            
            self.filtered = self.items
        }
    }
    
    // Search or Filter
    func filterData(){
        
        withAnimation(.linear){
            self.filtered = self.items.filter{
                return $0.item_name.lowercased().contains(self.search.lowercased())
            }
        }
        
    }
    
    // Add to Cart Function
    func addToCart(item: Item){
        // Check if item already exists in the cart
            if let index = cartItems.firstIndex(where: { $0.item.id == item.id }) {
                // If item is already in the cart, increase the quantity
                cartItems[index].quantity += 1
            } else {
                // If item is not in the cart, add it with quantity 1
                cartItems.append(Cart(item: item, quantity: 1))
            }
    }
    
    
    func saveOrderToFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        let orderData: [String: Any] = [
            "location": [
                "latitude": userLocation.coordinate.latitude,
                "longitude": userLocation.coordinate.longitude
            ],
            "ordered_food": cartItems.enumerated().reduce(into: [String: Any]()) { result, element in
                let (index, cart) = element
                result[String(index)] = [
                    "item_cost": cart.item.item_cost,
                    "item_name": cart.item.item_name,
                    "item_quantity": cart.quantity
                ]
            },
            "total_cost": totalPrice
        ]
        
        db.collection("users").document(userId).setData([
            "orders": [
                "order_\(UUID().uuidString)": orderData
            ]
        ], merge: true) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Order successfully written!")
            }
        }
    }
    
    
    // it doesn't work FİX !!
    func deleteOrderFromFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).collection("orders").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    document.reference.delete { error in
                        if let error = error {
                            print("Error removing document: \(error)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                }
            }
        }
    }
}
