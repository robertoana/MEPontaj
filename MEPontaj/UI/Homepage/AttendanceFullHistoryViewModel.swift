//
//  AttendanceFullHistroyViewModel.swift
//  MEPontaj
//
//  Created by Robert Oană on 27.08.2024.
//

import Foundation
import Combine

class AttendanceFullHistoryViewModel: BaseViewModel<DefaultViewModelEvent>, ObservableObject {
    
    private let constructionSiteService = ConstructionSiteService.instance
    private let userService = UserService.instance
    private let attendanceService = AttendanceService.instance
    @Published var assignedConstructionSiteState = DataState<[AssignedSites]>.loading
    @Published var attendanceState = DataState<[AttendanceById]>.loading
    
    override init() {
        super.init()
        getAttendanceById()
        getAssignedSites()
    }
    
    func getAssignedSites() {
        guard let userId = userService.getUserId() else {
            print("No id.")
            return
        }
        
        constructionSiteService.getAssignedSites(userId: userId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                
                if case .failure(let error) = completion {
                    self?.assignedConstructionSiteState = .failure(error)
                }
                
            } receiveValue: { [weak self] assignedConstructionSiteState in
                self?.assignedConstructionSiteState = .ready(assignedConstructionSiteState)
            }.store(in: bag)
    }
    
    func getAttendanceById() {
        guard let userId = userService.getUserId() else {
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
                self?.attendanceState = .ready(attendance.reversed())
            }.store(in: bag)
    }
}
