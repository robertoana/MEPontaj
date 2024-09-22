//
//  ColorSet.swift
//  MEPontaj
//
//  Created by Robert Oană on 03.09.2024.
//

import SwiftUI

class ColorSet: ObservableObject {
    
    static let instance = ColorSet()
    private init() {}
    @Published var color: UIColor = .white
    
}
