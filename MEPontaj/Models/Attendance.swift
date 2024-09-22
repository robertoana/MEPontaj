//
//  Attendance.swift
//  MEPontaj
//
//  Created by Robert Oană on 09.08.2024.
//

import Foundation
import SwiftUI

enum AttendanceType: String {
    case start
    case final 
}

struct Attendance: Codable {

    let idAttendance: Int?
    let idEmployee: Int?
    let idConstructionSite: Int?
    let latitude: Double?
    let longitude: Double?
    let start: String?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case idAttendance = "idPontaj"
        case idEmployee = "idAngajat"
        case idConstructionSite = "idSantier"
        case latitude = "latitudine"
        case longitude = "longitudine"
        case start
        case createdAt
    }
}

struct AttendanceById: Identifiable, Codable {
    
    let id: Int?
    let employeeName: String?
    let start: String?
    let final: String?
    let time: String?
    let constructionSiteName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case employeeName = "numeAngajat"
        case start
        case final
        case time = "durata"
        case constructionSiteName = "numeSantier"
    }
}

struct AttendanceStatus: Codable {
    let initAttendanceDone: Bool
    let finalAttendanceDone: Bool
}

struct ServerError: Error, Codable {
    let message: String
}

