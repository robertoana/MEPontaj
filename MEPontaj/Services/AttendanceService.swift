//
//  AttendanceService.swift
//  MEPontaj
//
//  Created by Robert Oană on 09.08.2024.
//

import Foundation
import SwiftUI
import Combine


class AttendanceService {
    
    private let attendanceApi = AttendanceApi()
    static let instance = AttendanceService()
    private init() {}
    
    func addAttendance (
        latitude: Double,
        longitude: Double,
        attendaceType: AttendanceType,
        userId: Int
    ) -> AnyPublisher<Attendance, Error> {
        return attendanceApi.addAttendance(
            latitude: latitude,
            longitude: longitude,
            attendanceType: attendaceType,
            userId: userId)
            .eraseToAnyPublisher()
    }
    
    func getAttendanceById(userId:Int) -> AnyPublisher<[AttendanceById], Error> {
        return attendanceApi.getAttendanceById(userId: userId)
            .eraseToAnyPublisher()
    }
    
    func checkAttendanceStatus(userId:Int) -> AnyPublisher<AttendanceStatus, Error> {
        return attendanceApi.checkAttendanceStatus(userId: userId)
            .eraseToAnyPublisher()
    }
}

