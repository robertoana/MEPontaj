//
//  HolidayRequestViewModel.swift
//  MEPontaj
//
//  Created by Robert Oană on 22.08.2024.
//

import Foundation
import Combine
import AlertToast
import SwiftUI

enum HolidayRequestViewModelEvent {
    case succes (message: String?)
    case error (message: Error)
}

class HolidayRequestViewModel:BaseViewModel<HolidayRequestViewModelEvent> , ObservableObject {
    
    private let holidayService = HolidayService.instance
    private let userService = UserService.instance
    @Published var holidayState = DataState<Holiday>.loading
    @Published var errorMessage: String? = nil
    @Published var showErrorToast = false
    
    func addHoliday(
        holidayType: String,
        startDate: String,
        finalDate: String,
        reason: String
    ) {
        self.isLoading = true
        guard let userId = userService.getUserId() else {
            print("No id.")
            return
        }
        holidayService.addHoliday(id: userId, holidayType: holidayType, startDate: startDate, finalDate: finalDate, reason: reason)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.isLoading = false
                    if let receivedError = error as? ServerError {
                        self.emitEvent(.error(message: receivedError))
                    } else {
                        self.emitEvent(.error(message: error))
                    }
                    print(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] holiday in
                guard let self = self else { return }
                self.isLoading = false
                self.emitEvent(.succes(message: "Concediu trimis cu succes!"))
            })
            .store(in: bag)
    }
    
    func submitHoliday(selectedHoliday: String, startDate: Date, finalDate: Date, reason: String) {
        var hasError = false
        
        if selectedHoliday.contains("Selectează concediul") {
            hasError = true
            self.errorMessage = "Selectează un concediu!"
        } else if startDate.formatDate().isEmpty || finalDate.formatDate().isEmpty {
            print("Selectează o dată ")
            hasError = true
            self.errorMessage = "Selecteaza o dată!"
        } else if startDate.formatDate() > finalDate.formatDate() {
            hasError = true
            self.errorMessage = "Data de început nu poate fi după data de sfârșit!"
        } else if reason.isEmpty {
            hasError = true
            self.errorMessage = "Introduceți un motiv"
        }
        
        self.showErrorToast = hasError
        
        if !hasError {
            addHoliday(holidayType: selectedHoliday, startDate: startDate.formatDate(), finalDate: finalDate.formatDate(), reason: reason)
        }
    }
}
