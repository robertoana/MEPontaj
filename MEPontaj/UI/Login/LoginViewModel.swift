//
//  LoginViewModel.swift
//  MEPontaj
//
//  Created by Robert Oană on 08.08.2024.
//

import Foundation
import Combine

enum LoginViewModelEvent {
    case completed (message:String?)
    case error(_ error: Error)
}

class LoginViewModel: BaseViewModel<LoginViewModelEvent>, ObservableObject {
    private let userService = UserService.instance
    @Published var isEmailError: Bool = false
    @Published var isPasswordError: Bool = false
    
    func login(email: String, password: String) {
        self.isLoading = true
        userService.login(email: email, password: password)
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
            }, receiveValue: { [weak self] login in
                guard let self else {return}
                self.userService.saveUserToDefaults(employee: login.angajat)
                self.isLoading = false
                self.emitEvent(.completed(message: nil))
            })
            .store(in: bag)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*?[a-z]).{5,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }

    func verifyCredentials(_ email: String, _ password: String) {
        isEmailError = !isValidEmail(email)
        isPasswordError = !validatePassword(password)
    }
}

