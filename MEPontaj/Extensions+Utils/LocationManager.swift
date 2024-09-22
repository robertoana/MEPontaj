//
//  LocationManager.swift
//  MEPontaj
//
//  Created by Robert Oană on 09.08.2024.
//

import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    @Published var errorLocationMessage: String = ""
    @Published var isErrorLocation: Bool = false
    private var manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location access restricted or denied")
            isErrorLocation = true
            errorLocationMessage = "Pentru a putea folosi locatia, activeaz-o din setari!"
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        @unknown default:
            print("Unknown location authorization status")
            isErrorLocation = true
            errorLocationMessage = "Pentru a putea folosi locatia, activeaz-o din setari!"
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lastKnownLocation = location.coordinate
        }
    }
}

