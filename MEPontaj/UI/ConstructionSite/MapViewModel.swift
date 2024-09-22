//
//  MapViewModel.swift
//  MEPontaj
//
//  Created by Robert Oană on 23.08.2024.
//

import GoogleMaps
import UIKit
import Combine
import SwiftUI

class MapViewModel: NSObject, ObservableObject {
    
    private let locationManager = LocationManager()
    private let userService = UserService.instance
    private let constructionSiteSerivce = ConstructionSiteService.instance
    private var bag = Set<AnyCancellable>()
    @Published private(set) var lastKnownLocation: CLLocationCoordinate2D?
    @Published var constructionSiteState = DataState<[ConstructionSite]>.loading
    @Published var markers: [GMSMarker] = []
    @Published var circles: [GMSCircle] = []
    
    override init(){
        super.init()
        getCoordinatesById()
    }
    
    func observeLocationManager() {
        locationManager.$lastKnownLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                self?.lastKnownLocation = location
            }
            .store(in: &bag)
    }
    
    func getCoordinatesById() {
        guard let userId = userService.getUserId() else {
            print("No id.")
            return
        }
        constructionSiteSerivce.getCoordinatesById(userId: userId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.constructionSiteState = .failure(error)
                }
            } receiveValue: { [weak self] constructionSite in
                self?.constructionSiteState = .ready(constructionSite)
                self?.setupMapDetails(constructionSites: constructionSite)
            }.store(in: &bag)
    }
    
    func setupMapDetails(constructionSites: [ConstructionSite]) {
        self.markers = constructionSites.map { site in
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: site.latitude, longitude: site.longitude))
            marker.title = site.siteName
            marker.snippet = site.address
            marker.userData = site
            marker.isTappable = true
            return marker
        }
        
        self.circles = constructionSites.map { site in
            let circleCenter = CLLocationCoordinate2DMake(site.latitude, site.longitude)
            let circle = GMSCircle(position: circleCenter, radius: site.radius * 1000)
            circle.fillColor = UIColor.red.withAlphaComponent(0.2)
            circle.strokeColor = UIColor.red
            circle.strokeWidth = 1
            return circle
        }
    }
}
