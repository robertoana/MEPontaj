//
//  DatePickerView.swift
//  MEPontaj
//
//  Created by Robert Oană on 21.08.2024.
//

import SwiftUI

struct DatePickerView:View {
    
    @Binding var date: Date
    
    var body: some View {
        DatePicker(
            "",
            selection: $date,
            displayedComponents: .date)
        .datePickerStyle(.compact)
        .colorScheme(.light)
        .labelsHidden()
        .opacity(0.011)
        .frame(maxWidth: .infinity)
        .scaleEffect(CGSize(width: 4, height: 1))
        .colorInvert()
        .tint(.blue)
        
    }
}
