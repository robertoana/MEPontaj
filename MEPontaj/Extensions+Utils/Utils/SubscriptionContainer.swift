//
//  SubscriptionContainer.swift
//  MEPontaj
//
//  Created by Robert Oană on 08.08.2024.
//

import Foundation
import Combine

extension AnyCancellable {
    func store(in container: SubscriptionContainer) {
        container.add(cancellable: self)
    }
}

final class SubscriptionContainer {

    private var bag = Set<AnyCancellable>()

    public func add(cancellable: AnyCancellable) {
        bag.insert(cancellable)
    }
    
    func add<SuccessType, FailureType>(task: Task<SuccessType, FailureType>) {
        add(cancellable: AnyCancellable(task.cancel))
    }
    
    func cancelAll() {
        bag.forEach {$0.cancel()}
        bag.removeAll()
    }
}
