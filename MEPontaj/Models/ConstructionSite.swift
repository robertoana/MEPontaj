//
//  ConstructionSite.swift
//  MEPontaj
//
//  Created by Robert on 24.08.2024.
//

import Foundation

struct ConstructionSite: Codable {
    
    let siteName: String
    let latitude: Double
    let longitude: Double
    let radius: Double
    let address: String
    let message: String?
}

struct AssignedSites: Codable {
    
    let id: Int
    let nume: String
}
