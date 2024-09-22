//
//  DateFormat.swift
//  MEPontaj
//
//  Created by Robert Oană on 21.08.2024.
//

import SwiftUI

extension Date {
    
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: self)
    }
}
