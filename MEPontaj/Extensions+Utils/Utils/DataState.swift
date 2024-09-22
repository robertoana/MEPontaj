//
//  DataState.swift
//  MEPontaj
//
//  Created by Robert Oană on 08.08.2024.
//

import Foundation
import Combine

public enum DataState<T> {
    case loading
    case ready(T)
    case failure(Error)
    public var value: T? {
        if case let .ready(t) = self {
            return t
        }
        return nil
    }
    public var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    public var error: Error? {
        if case let .failure(error) = self {
            return error
        }
        return nil
    }
}
