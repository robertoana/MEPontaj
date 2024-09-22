//
//  Holiday.swift
//  MEPontaj
//
//  Created by Robert Oană on 20.08.2024.
//

import Foundation

struct Holiday: Codable {
    let id: Int
    let holidayType: String
    let startDate: String
    let finalDate: String
    let reason: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case holidayType = "tipConcediu"
        case startDate = "dataInceput"
        case finalDate = "dataSfarsit"
        case reason = "motiv"
        case status
    }
}

struct ServerResponseHoliday: Codable {
    let message: String
}
