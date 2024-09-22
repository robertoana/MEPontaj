//
//  AttendanceApi.swift
//  MEPontaj
//
//  Created by Robert Oană on 09.08.2024.
//

import Foundation
import Combine
import Alamofire

class AttendanceApi {
    
    func addAttendance(
        latitude: Double,
        longitude: Double,
        attendanceType: AttendanceType,
        userId: Int
        ) -> Future<Attendance, Error> {
        return Future { promise in
            let parameters = [
                "userId": userId,
                "latitudine": latitude,
                "longitudine": longitude,
                "type": attendanceType.rawValue
            ]
            
            AF.request(
                "http://localhost:8090/api/pontaj/addPontaj",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default
            )
            .responseData { response in
                let statusCode = response.response?.statusCode
                switch response.result {
                case .success(let data):
                    let okStatusCodes = ClosedRange(uncheckedBounds: (200, 300))
                    if let statusCode, okStatusCodes.contains(statusCode) {
                        do {
                            let attendance = try JSONDecoder().decode(Attendance.self, from: data)
                            promise(.success(attendance))
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
    
    func getAttendanceById(userId: Int) -> Future <[AttendanceById], Error> {
        Future { promise in
            let request = Alamofire.Session.default
                .request(
                    "http://localhost:8090/api/pontaj/getPontajByIdAngajat/\(userId)",
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
                            let attendanceWrapper = try decoder.decode([AttendanceById].self, from: data)
                            promise(.success(attendanceWrapper))
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
    
    func checkAttendanceStatus(userId: Int) -> Future <AttendanceStatus, Error> {
        Future { promise in
            let request = Alamofire.Session.default
                .request(
                    "http://localhost:8090/api/pontaj/checkAttendanceStatus/\(userId)",
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
                            let attendanceStatusWrapper = try decoder.decode(AttendanceStatus.self, from: data)
                            promise(.success(attendanceStatusWrapper))
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
