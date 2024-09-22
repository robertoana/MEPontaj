//
//  HolidayViewModel.swift
//  MEPontaj
//
//  Created by Robert Oană on 20.08.2024.
//

import Foundation
import Combine

class HolidayViewModel: BaseViewModel<DefaultViewModelEvent>, ObservableObject {
    
    private let holidayService = HolidayService.instance
    private let userService = UserService.instance
    @Published var holidayState = DataState<[Holiday]>.loading
    
    override init() {
        super.init()
        getHolidaysById()
    }
    
    func getHolidaysById() {
        guard let userId = userService.getUserId() else {
            print("No id.")
            return
        }
        
        holidayService.getHolidaysById(userId: userId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.holidayState = .failure(error)
                }
            } receiveValue: { [weak self] holiday in
                self?.holidayState = .ready(holiday.reversed())
            }.store(in: bag)
    }
}
