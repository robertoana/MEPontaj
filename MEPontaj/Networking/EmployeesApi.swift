//
//  AngajatiAPI.swift
//  MEPontaj
//
//  Created by Robert Oană on 08.08.2024.
//

import Foundation
import Combine
import Alamofire

class EmployeesApi {
    
    func login(email: String, password: String) -> Future<LoginResponse, Error> {
        return Future { promise in
            
            let parameters = [
                "email": email,
                "parola": password
            ]
            
            AF.request(
                    "http://localhost:8090/api/angajati/login",
                    method: .post,
                    parameters: parameters,
                    encoding:JSONEncoding.default
                    )
            .responseData { response in
                let statusCode = response.response?.statusCode
                switch response.result {
                case .success(let data):
                    let okStatusCodes = ClosedRange(uncheckedBounds: (200, 300))
                    if let statusCode, okStatusCodes.contains(statusCode) {
                        do {
                            let loginWrapper = try JSONDecoder().decode(LoginResponse.self, from: data)
                            promise(.success(loginWrapper))
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


