//
//  HomepageViewModel.swift
//  MEPontaj
//
//  Created by Robert Oană on 08.08.2024.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation

enum HomepageViewModelEvent {
    case initAttendanceDone
    case finalAttendanceDone
    case error(_ error: Error)
}

class HomepageViewModel: BaseViewModel<HomepageViewModelEvent>, ObservableObject {
    
    private let userService = UserService.instance
    private let attendanceService = AttendanceService.instance
    let colorSet = ColorSet.instance
    var locationManager = LocationManager()
    
    @Published var userDataState: DataState<Employee> = .loading
    @Published private(set) var lastKnownLocation: CLLocationCoordinate2D?
    @Published var initAttendanceDone: Bool = false
    @Published var finalAttendanceDone: Bool = false
    @Published var showConfirmInitScreen: Bool = false
    @Published var showConfirmFinalScreen: Bool = false
    @Published var showErrorScreen: Bool = false
    @Published var isReadyToDisplay: Bool = false
    @Published var errorMessage: String = ""
    @Published var attendanceState = DataState<[AttendanceById]>.loading
    @Published var checkAttendanceState = DataState<AttendanceStatus>.loading

    override init() {
        super.init()
        observeUser()
        loadUser()
        locationManager.$lastKnownLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                self?.lastKnownLocation = location
            }
            .store(in: bag)
        checkAttendanceStatus()
        getAttendanceById()
    }
    
    private func loadUser() {
        userService.loadUserFromDefaults()
    }
    
    private func observeUser() {
        userService.userSubject
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] employee in
                if let employee, let self {
                    self.userDataState = .ready(employee)
                }
            }.store(in: bag)

    }
    
    private func getUserId() -> Int? {
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
            print("No employee")
            return nil
        }
    }
    
    func startAttendance(attendanceType: AttendanceType) {
        guard let location = lastKnownLocation else {
            locationManager.isErrorLocation = true
            showErrorScreen = true
            errorMessage = locationManager.errorLocationMessage
            return
        }

        guard let userId = getUserId() else {
            print("No id.")
            return
        }

        let latitude = location.latitude
        let longitude = location.longitude

        addAttendance(
            latitude: latitude,
            longitude: longitude,
            attendaceType: attendanceType,
            userId: userId)
    }
    
    func addAttendance(latitude: Double, longitude: Double, attendaceType: AttendanceType, userId: Int) {
            self.isLoading = true
            attendanceService.addAttendance(
                latitude: latitude,
                longitude: longitude,
                attendaceType: attendaceType,
                userId: userId
            )
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.isLoading = false
                    print(error)
                    if let receivedError = error as? ServerError {
                        self.emitEvent(.error(receivedError))
                    } else {
                        self.emitEvent(.error(error))
                    }
                }
            }, receiveValue: { [weak self] attendance in
                guard let self = self else { return }
                self.isLoading = false
                if attendaceType == .start {
                    self.emitEvent(.initAttendanceDone)
                } else {
                    self.emitEvent(.finalAttendanceDone)
                }
            })
            .store(in: bag)
        }
    
    func getAttendanceById() {
        guard let userId = getUserId() else {
            print("No id.")
            return
        }
        attendanceService.getAttendanceById(userId: userId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.attendanceState = .failure(error)
                    self?.showViews()
                case .finished:
                    break
                }
            } receiveValue: { [weak self] attendance in
                self?.attendanceState = .ready(attendance.reversed())
                self?.showViews()
            }.store(in: bag)
    }
    
    func checkAttendanceStatus() {
        guard let userId = getUserId() else {
            print("No id.")
            return
        }
        
        attendanceService.checkAttendanceStatus(userId: userId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.checkAttendanceState = .failure(error)
                    self.showViews()
                }
            } receiveValue: { [weak self] attendanceStatus in
                self?.checkAttendanceState = .ready(attendanceStatus)
                self?.initAttendanceDone = attendanceStatus.initAttendanceDone
                self?.finalAttendanceDone = attendanceStatus.finalAttendanceDone
                self?.showViews()
            }.store(in: bag)
    }
    
    func showViews() {
        switch (attendanceState, checkAttendanceState) {
        case (.ready, .ready):
            isReadyToDisplay = true
        case (.failure, _):
            isReadyToDisplay = true
        default:
            isReadyToDisplay = false
        }
    }
}
