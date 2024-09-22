//
//  UserService.swift
//  MEPontaj
//
//  Created by Robert Oană on 08.08.2024.
//

import Foundation
import SwiftUI
import Combine

enum StorageKeys: String {
    case user = "user"
    case appTheme = "appTheme"
}

class UserService {

    private(set) var userSubject: CurrentValueSubject<Employee?,Error> = .init(nil)
    static let instance = UserService()
    private init () {}
    
    func login(email: String, password: String) -> AnyPublisher<LoginResponse, Error> {
        return EmployeesApi().login(email: email, password: password)
            .eraseToAnyPublisher()
    }
    
    func saveUserToDefaults(employee: Employee) {
        let encodedUser = try! JSONEncoder().encode(employee)
        UserDefaults.standard.setValue(encodedUser, forKey: StorageKeys.user.rawValue)
    }
    
    func getValue() -> String? {
        return UserDefaults.standard.object(forKey: StorageKeys.appTheme.rawValue) as? String
    }
    
    func setValue(value: String?) {
        UserDefaults.standard.set(value, forKey: StorageKeys.appTheme.rawValue)
    }
    
    func loadUserFromDefaults() {
        let data = UserDefaults.standard.data(forKey: StorageKeys.user.rawValue)
        if let data {
            let decoder = JSONDecoder()
            do {
                let decodedUser = try decoder.decode(Employee.self, from: data)
                userSubject.send(decodedUser)
            } catch (let error) {
                print(error)
            }
          } else {
                print("No profile")
        }
    }
    
    func removeUserFromDefaults() {
        UserDefaults.standard.removeObject(forKey: StorageKeys.user.rawValue)
    }
    
    func getUserId() -> Int? {
        let data = UserDefaults.standard.data(forKey: StorageKeys.user.rawValue)
        if let data {
            let decoder = JSONDecoder()
            do {
                let decodedEmployee = try decoder.decode(Employee.self, from: data)
                return decodedEmployee.idEmployee
            } catch(let error) {
                print(error)
                return nil
            }
        } else {
            print("No user saved")
            return nil
        }
    }
    
    func getUserName() -> String? {
        let data = UserDefaults.standard.data(forKey: StorageKeys.user.rawValue)
        if let data {
            let decoder = JSONDecoder()
            do {
                let decodedEmployee = try decoder.decode(Employee.self, from: data)
                return decodedEmployee.firstName
            } catch(let error) {
                print(error)
                return nil
            }
        } else {
            print("No user saved")
            return nil
        }
    }
    
    func getEmploymentDate() -> String? {
        let data = UserDefaults.standard.data(forKey: StorageKeys.user.rawValue)
        if let data {
            let decoder = JSONDecoder()
            do {
                let decodedEmployee = try decoder.decode(Employee.self, from: data)
                return decodedEmployee.employmentDate
            } catch(let error) {
                print(error)
                return nil
            }
        } else {
            print("No user saved")
            return nil
        }
    }
}

