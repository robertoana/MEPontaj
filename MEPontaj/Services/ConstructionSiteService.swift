//
//  ConstructionSiteService.swift
//  MEPontaj
//
//  Created by Robert on 25.08.2024.
//

import Foundation
import Combine

class ConstructionSiteService {
    
    private let constructionSiteApi = ConstructionSiteApi()
    static let instance = ConstructionSiteService()
    private init() {}
    
    func getCoordinatesById(userId: Int) -> AnyPublisher<[ConstructionSite], Error> {
        return constructionSiteApi.getCoordinatesByID(userId: userId)
            .eraseToAnyPublisher()
    }
    
    func getAssignedSites(userId: Int) -> AnyPublisher<[AssignedSites], Error> {
        return constructionSiteApi.getAssignedSites(userId: userId)
            .eraseToAnyPublisher()
    }
}
