//
//  HomeViewModel.swift
//  FoodOrder
//
//  Created by Esma Koçak on 1.09.2024.
//

import SwiftUI
import CoreLocation

class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
    
    @Published var userLocation : CLLocation?
    @Published var userAdress = ""
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // This method is called when the location authorization status changes
        // Checking the user's location access permission status
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("authorized")
        case .denied:
            print ("denied")
        default:
            print ("unknown")
            //Direct Call
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //reading user location and extracting details.
        self.userLocation = locations.last
        self.extractLocation()
    }
    
    func extractLocation(){}
}
