//
//  RootView.swift
//  MEPontaj
//
//  Created by Robert Oană on 08.08.2024.
//

import SwiftUI

struct RootView: View {
    
    @StateObject var viewModel = RootViewModel()
    let navigation: Navigation
    private let userService = UserService.instance
    
    var body: some View {
        if((userService.getUserId()) != nil) {
            VStack {
                NavigationHostView(navigation: navigation)
                    .ignoresSafeArea()
                    .onAppear {
                        navigation.setRoot(MainView().asDestination(), animated: false)
                    }
            }.background(Color.white)
        } else {
            VStack {
                NavigationHostView(navigation: navigation)
                    .ignoresSafeArea()
                    .onAppear {
                        navigation.setRoot(LoginScreen().asDestination(), animated: false)
                    }
            }.background(Color.white)
        }
    }
}

class RootViewModel: ObservableObject {
    
    private let userService = UserService.instance
    
    init() {
        applyTheme()
    }
    
    func applyTheme() {

            if let themeString = userService.getValue(),
               let theme = SchemeType(rawValue: themeString) {
                switch theme {
                case .light:
                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
                case .dark:
                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
                case .system:
                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
                }
            } else {
                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
            }
        }
}
