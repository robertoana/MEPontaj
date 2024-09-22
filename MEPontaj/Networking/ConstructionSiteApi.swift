//
//  ConstructionSite.swift
//  MEPontaj
//
//  Created by Robert on 24.08.2024.
//

import Foundation
import Alamofire
import Combine

class ConstructionSiteApi {
    
    func getCoordinatesByID(userId: Int) -> Future<[ConstructionSite], Error> {
        Future { promise in
            let request = Alamofire.Session.default
                .request(
                    "http://localhost:8090/api/santiere/getCoordinatesById/\(userId)",
                    method: .get
                )
            request.response { response in
                let statusCode = response.response?.statusCode
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    let okStatusCodes = ClosedRange(uncheckedBounds: (200, 300))
                    
                    guard let data = data else {
                        promise(.failure(NSError(domain: "Error", code: 500)))
                        return
                    }
                    
                    if let statusCode, okStatusCodes.contains(statusCode) {
                        do {
                            let constructionSiteWrapper = try decoder.decode([ConstructionSite].self, from: data)
                            promise(.success(constructionSiteWrapper))
                        } catch {
                            promise(.failure(error))
                        }
                    } else {
                        do {
                            let serverError = try JSONDecoder().decode(ServerError.self, from: data)
                            promise(.failure(serverError))
                        } catch {
                            promise(.failure(error))
                        }
                    }                
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    func getAssignedSites(userId: Int) -> Future<[AssignedSites], Error> {
        Future { promise in
            let request = Alamofire.Session.default
                .request(
                    "http://localhost:8090/api/angajati/angajati/\(userId)/santiere",
                    method: .get
                )
            request.response { response in
                let statusCode = response.response?.statusCode
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    let okStatusCodes = ClosedRange(uncheckedBounds: (200, 300))
                    
                    guard let data = data else {
                        promise(.failure(NSError(domain: "Error", code: 500)))
                        return
                    }
                    
                    if let statusCode, okStatusCodes.contains(statusCode) {
                        do {
                            let assignedSitesWrapper = try decoder.decode([AssignedSites].self, from: data)
                            promise(.success(assignedSitesWrapper))
                        } catch {
                            promise(.failure(error))
                        }
                    } else {
                        do {
                            let serverError = try JSONDecoder().decode(ServerError.self, from: data)
                            promise(.failure(serverError))
                        } catch {
                            promise(.failure(error))
                        }
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
}
