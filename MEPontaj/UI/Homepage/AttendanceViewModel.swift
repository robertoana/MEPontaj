//
//  AttendanceViewModel.swift
//  MEPontaj
//
//  Created by Robert Oană on 09.08.2024.
//

import Foundation
import Combine
import CoreLocation

enum AttendanceViewModelEvent {
    case completed (message:String?)
    case error(_ error: Error)
}

class AttendanceViewModel: BaseViewModel<AttendanceViewModelEvent>, ObservableObject {
    
    private let attendanceService = AttendanceService.instance
    private var locationManager = LocationManager()
    @Published private(set) var lastKnownLocation: CLLocationCoordinate2D?
    @Published private(set) var errorMessage: String?
    @Published var attendanceState = DataState<[AttendanceById]>.loading
    
    override init() {
        super.init()
        locationManager.$lastKnownLocation
            .sink { [weak self] location in
                self?.lastKnownLocation = location
            }
            .store(in: bag)
        getAttendanceById()
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
            print("No user saved")
            return nil
        }
    }
    
    func startAttendance(attendanceType: AttendanceType) {
        guard let location = lastKnownLocation else {
            print("Location not availabl")
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
                self.emitEvent(.completed(message: nil))
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
                case .finished:
                    break
                }
            } receiveValue: { [weak self] attendance in
                self?.attendanceState = .ready(attendance)
            }.store(in: bag)
    }
}



