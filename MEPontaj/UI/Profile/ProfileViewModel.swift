//
//  ProfileViewModel.swift
//  MEPontaj
//
//  Created by Robert Oană on 27.08.2024.
//

import Foundation
import UIKit

enum SchemeType: String, CaseIterable {
    case light
    case dark
    case system
}

class ProfileViewModel: BaseViewModel<DefaultViewModelEvent>, ObservableObject {
    
    @Published var isLightModeSelected: Bool?
    @Published var isDarkModeSelected: Bool?
    
    private let userService = UserService.instance
    
    override init() {
        super.init()
        loadThemePreference()
    }
    
    func getUserName() -> String {
        return userService.getUserName() ?? "Utilizator necunoscut"
    }
    
    func getEmploymentDate() -> String {
        return userService.getEmploymentDate() ?? "Data indisponibila"
    }
    
    func deleteFromUserDefaults() {
        userService.removeUserFromDefaults()
    }
    
    func loadThemePreference() {
        let storedTheme = userService.getValue()
        
        self.isLightModeSelected = storedTheme == "light"
        self.isDarkModeSelected = storedTheme == "dark"
        
        if let storedTheme = storedTheme, let themeType = SchemeType(rawValue: storedTheme) {
            applyThemeBasedOnPreference(theme: themeType)
        } else {
            applyThemeBasedOnPreference(theme: .system)
        }
    }
    
    func applyThemeBasedOnPreference(theme: SchemeType) {
        
        switch theme {
        case .light:
            userService.setValue(value: "light")
            self.isLightModeSelected = true
            self.isDarkModeSelected = false
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        case .dark:
            userService.setValue(value: "dark")
            self.isLightModeSelected = false
            self.isDarkModeSelected = true
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        case .system:
            userService.setValue(value: "system")
            self.isLightModeSelected = false
            self.isDarkModeSelected = false
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
        }
    }
}
