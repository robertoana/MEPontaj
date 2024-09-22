//
//  BaseViewModel.swift
//  MEPontaj
//
//  Created by Robert Oană on 08.08.2024.
//

import Combine
import SwiftUI

enum DefaultViewModelEvent {
    case completed(message: String?)
}

struct ErrorData {
    let error: Error
    var retryHandler: (() -> ())?
}

class BaseViewModel<T: Any> {
    
    public let bag = SubscriptionContainer()
    public let errorSubject = PassthroughSubject<ErrorData, Never>()
    public let eventSubject = PassthroughSubject<T, Never>()
    var cancellables: Set<AnyCancellable> = []
    
    @Published var isLoading = false
    
    public func emitError(errorData: ErrorData) {
        DispatchQueue.main.async {
            self.errorSubject.send(errorData)
        }
    }
    
    public func emitError(error: Error, retryHandler: (() -> ())? = nil) {
        DispatchQueue.main.async {
            self.errorSubject.send(ErrorData(error: error, retryHandler: retryHandler))
        }
    }
    
    public func emitEvent(_ event: T) {
        DispatchQueue.main.async {
            self.eventSubject.send(event)
        }
    }
}
