//
//  ProfileScreen.swift
//  MEPontaj
//
//  Created by Robert Oană on 08.08.2024.
//

import SwiftUI

struct ProfileScreen: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @State private var changeColor = false
    private let navigation = EnvironmentObjects.navigation
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Profil")
                    .foregroundStyle(Color.black)
                    .font(.poppinsMedium(size: 20))
                    .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                    .padding(.top, 14)
                
                LottieViewGeneral(name: "WorkerProfile", loopMode: .loop)
                    .frame(width: 100, height: 100, alignment: .center)
                    .scaleEffect(0.3)
                
                Text(viewModel.getUserName())
                    .foregroundStyle(Color.black)
                    .font(.poppinsMedium(size: 17))
                    .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                
                Text("Angajat din: \(viewModel.getEmploymentDate())")
                    .foregroundStyle(Color.gray)
                    .font(.poppinsMedium(size: 17))
                    .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)

                VStack(spacing: 16) {
                    Button {
                        navigation?.presentModal(PopupLogout() {
                            viewModel.deleteFromUserDefaults()
                            navigation?.setRoot(LoginScreen().asDestination(), animated: true)
                            navigation?.dismissModal(animated: true, completion: {})
                        }.asDestination(), animated: true)
                    } label: {
                        Text("Deconectare")
                            .foregroundStyle(Color.black)
                            .font(.poppinsMedium(size: 17))
                            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                        
                        Image(.icExit)
                            .resizable()
                            .frame(width:20, height:20)
                    }
                
                    Button {
                        navigation?.push(WebViewScreen().asDestination(), animated: true)
                    } label: {
                        HStack {
                            Text("Documente legale")
                                .foregroundStyle(Color.black)
                                .font(.poppinsMedium(size: 17))
                                .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                            
                            Image(systemName: "arrow.up.right.square")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.black)
                        }
                    }
                    
                    Toggle("Tema aplicatie", isOn: $changeColor)
                        .foregroundStyle(Color.black)
                        .font(.poppinsMedium(size: 17))
                        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                        .toggleStyle(SwitchToggleStyle(tint: .gray))
                    
                }.padding(.horizontal, 30)
                 .padding(.top, 12)
            }
        }.background(Color.whiteProfile)
            .onChange(of: changeColor) { newValue in
                if newValue {
                    viewModel.applyThemeBasedOnPreference(theme: .dark)
                } else {
                    viewModel.applyThemeBasedOnPreference(theme: .light)
                }
            }
    }
}
