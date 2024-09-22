//
//  HolidayService.swift
//  MEPontaj
//
//  Created by Robert Oană on 20.08.2024.
//

import Foundation
import Combine

class HolidayService {
    
    private let holidayApi = HolidayApi()
    static let instance = HolidayService()
    private init() {}
    
    func getHolidaysById(userId: Int) -> AnyPublisher<[Holiday], Error> {
        return holidayApi.getHolidaysById(userId: userId)
            .eraseToAnyPublisher()
    }
    
    func addHoliday(
        id: Int,
        holidayType: String,
        startDate: String,
        finalDate: String,
        reason: String) -> AnyPublisher<ServerResponseHoliday, Error> {
            return holidayApi.addHoliday(id: id, holidayType: holidayType, startDate: startDate, finalDate: finalDate, reason: reason)
                .eraseToAnyPublisher()
        }
}
