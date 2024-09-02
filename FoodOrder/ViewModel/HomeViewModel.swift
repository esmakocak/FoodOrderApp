//
//  HomeViewModel.swift
//  FoodOrder
//
//  Created by Esma Koçak on 1.09.2024.
//

import SwiftUI
import CoreLocation
import FirebaseAuth

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
            }
        }
    }
}
