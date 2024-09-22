//
//  LoginScreen.swift
//  MEPontaj
//
//  Created by Robert Oană on 02.08.2024.
//

import Foundation
import SwiftUI


struct LoginScreen: View {
    
    @State private var emailFieldText: String = "robertoana47@gmail.com"
    @State private var passwordFieldText: String = "robert"
    @State private var errorMessage: String = ""
    @State private var isSecure: Bool = true
    @StateObject private var viewModel = LoginViewModel()
    private let navigation = EnvironmentObjects.navigation
    
    var body: some View {
        VStack {
            
            Image(.sigla)
                .resizable()
                .frame(width: 200, height: 200, alignment: .center)
                .padding(.top, 50)
            
            ZStack {
                VStack(alignment:.leading) {
                    
                    Text("Email")
                        .font(.poppinsMedium(size: 16))
                        .foregroundStyle(Color.black)
                        .padding(10)
                        .frame(alignment: .leading)
                    
                    VStack(alignment: .leading) {
                        
                        TextField("Email", text: $emailFieldText)
                            .textInputAutocapitalization(.never)
                            .font(.poppinsMedium(size: 16))
                            .foregroundStyle(Color.black)
                            .frame(height: 48)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(viewModel.isEmailError ? Color.red : .zirconiu, lineWidth: 2)
                            }
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                        
                        if viewModel.isEmailError {
                            Text("Eroare, verifica mail-ul")
                                .font(.poppinsRegular(size: 10))
                                .foregroundStyle(Color.red)
                                .frame(alignment: .leading)
                                .padding(.leading, 5)
                                .transition(.asymmetric(insertion: .slide.animation(.default), removal: .identity))
                        }
                    }.padding(.bottom, 40)
                    
                    VStack(alignment: .leading) {
                        
                        Text("Parola")
                            .font(.poppinsMedium(size: 16))
                            .foregroundStyle(Color.black)
                            .padding(10)
                            .frame(alignment: .leading)
                        
                        ZStack(alignment:.trailing) {
                            Group {
                                if isSecure {
                                    SecureField("Parola", text: $passwordFieldText)
                                        .textInputAutocapitalization(.never)
                                        .font(.poppinsMedium(size: 16))
                                        .foregroundStyle(Color.black)
                                        .frame(height: 48)
                                        .padding(.horizontal, 10)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(viewModel.isPasswordError ? Color.red : .zirconiu, lineWidth: 2)
                                        }
                                    
                                } else {
                                    
                                    TextField("Parola", text: $passwordFieldText)
                                        .textInputAutocapitalization(.never)
                                        .font(.poppinsMedium(size: 16))
                                        .foregroundStyle(Color.black)
                                        .frame(height: 48)
                                        .padding(.horizontal, 10)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(viewModel.isPasswordError ? Color.red : .zirconiu, lineWidth: 2)
                                        }
                                }
                            }
                            .textContentType(.password)
                            .keyboardType(.asciiCapable)
                            
                            Button {
                                isSecure.toggle()
                            } label: {
                                Image(systemName: isSecure ? "eye" : "eye.slash")
                                    .foregroundColor(.gray)
                                    .padding(10)
                            }
                        }
                        
                        if viewModel.isPasswordError {
                            Text("Parola invalida")
                                .font(.poppinsRegular(size: 10))
                                .foregroundStyle(Color.red)
                                .frame(alignment: .leading)
                                .padding(.leading, 5)
                                .transition(.slide.animation(.default))
                                .transition(.asymmetric(insertion: .slide.animation(.default), removal: .identity))
                        }
                    }.padding(.bottom, 50)
                    
                    Button {
                        withAnimation(.default) {
                            viewModel.verifyCredentials(emailFieldText, passwordFieldText)
                            if !viewModel.isEmailError && !viewModel.isPasswordError {
                                viewModel.login(email: emailFieldText, password: passwordFieldText)
                            }
                        }
                    } label: {
                        Text("Login")
                            .foregroundStyle(Color.white)
                            .font(.poppinsMedium(size: 16))
                            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                            .background(Color.blue)
                            .cornerRadius(40)
                    }
                    .padding(.bottom, 50)
                }.padding(20)
            }.background(Color.zirconiu)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(20)
        }
        .ignoresSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.white)
        .overlay {
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    LottieViewGeneral(name: "Blue Animation", loopMode: .loop)
                        .scaleEffect(0.4)
                    Spacer()
                }.background(Color.black.opacity(0.3))
                    .transition(.opacity.animation(.default))
            }
        }
        .onReceive(viewModel.eventSubject) { event in
            switch event {
            case .completed(message: _):
                navigation?.setRoot(MainView().asDestination(), animated: true)
            case .error(let error):
                if let receivedError = error as? ServerError {
                    errorMessage = receivedError.message
                } else {
                    errorMessage = error.localizedDescription
                }
                navigation?.presentModal(GeneralPopup(title: errorMessage, animationName: "Error", action: {
                    navigation?.dismissModal(animated: true, completion: {})
                }).asDestination(), animated: true)
            }
        }
    }
}
