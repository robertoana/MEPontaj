//
//  HolidayApi.swift
//  MEPontaj
//
//  Created by Robert Oană on 20.08.2024.
//

import Foundation
import Combine
import Alamofire

class HolidayApi {
    
    func getHolidaysById(userId: Int) -> Future<[Holiday], Error> {
        Future { promise in
            let request = Alamofire.Session.default
                .request(
                "http://localhost:8090/api/concedii/getConcediuByIdAngajat/\(userId)",
                method: .get
                )
            
            request.response { response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    do {
                        let holidayWrapper = try decoder.decode([Holiday].self, from: data!)
                        promise(.success(holidayWrapper))
                    } catch {
                        promise(.failure(error))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    func addHoliday(
        id: Int,
        holidayType: String,
        startDate: String,
        finalDate: String,
        reason: String ) -> Future<ServerResponseHoliday, Error> {
            return Future { promise in
                
            let parameters = [
                "userId": id,
                "tipConcediu": holidayType,
                "dataInceput": startDate,
                "dataSfarsit": finalDate,
                "motiv": reason
            ]
                
            AF.request(
                "http://localhost:8090/api/concedii/addConcediu",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default
            )
            .responseData { response in
                let statusCode = response.response?.statusCode
                switch response.result {
                case .success(let data):
                    let okStatusCodes = ClosedRange(uncheckedBounds: (200,300))
                    if let statusCode, okStatusCodes.contains(statusCode) {
                        do {
                            let holiday = try JSONDecoder().decode(ServerResponseHoliday.self, from: data)
                            promise(.success(holiday))
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
