//
//  User.swift
//  MEPontaj
//
//  Created by Robert Oană on 08.08.2024.
//

import Foundation
import SwiftUI

struct Employee: Codable {
    
    let idEmployee: Int
    let lastName: String
    let firstName: String
    let cnp: String
    let employmentDate: String
    let phoneNumber: Int
    let isAdmin: Bool
    let password: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case idEmployee = "idAngajat"
        case lastName = "nume"
        case firstName = "prenume"
        case cnp = "cnp"
        case employmentDate = "dataAngajare"
        case phoneNumber = "numarTelefon"
        case isAdmin = "isAdmin"
        case password = "parola"
        case email
    }
    
}

struct LoginResponse: Codable {
    let angajat: Employee
    let token: String
}
