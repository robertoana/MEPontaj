//
//  HomepageScreen.swift
//  MEPontaj
//
//  Created by Robert Oană on 07.08.2024.
//

import Foundation
import SwiftUI

struct HomepageView: View {
    
    @StateObject var viewModel = HomepageViewModel()
    @ObservedObject private var cs = ColorSet.instance
    private let navigation = EnvironmentObjects.navigation
    
    var body: some View {
        
        switch viewModel.userDataState {
        case .loading:
            LottieViewGeneral(name: "Blue Animation", loopMode: .loop)
                .scaleEffect(0.5)
        case .failure(_):
            ProgressView()
        case .ready(let employee):
            ScrollView(.vertical, showsIndicators: false) {
                VStack (alignment:.leading, spacing: 12) {
                    UserWelcomeScreen(userName: employee.firstName)
                    
                    if viewModel.isReadyToDisplay {
                        if viewModel.initAttendanceDone {
                            
                            GeneralAttendanceDoneView(attendanceType: "Pontaj inițial", attendanceMessage: "Ai pontat astăzi la început cu succes!")
                        } else {
                            GeneralAttendanceView(
                                viewModel: viewModel,
                                attendanceType: .start,
                                attendanceTitle: "Pontaj inițial",
                                attendanceSubtitle: "Nu uita să te pontezi la început de tură!"
                            ) {
                                viewModel.initAttendanceDone = true
                            }
                        }
                        
                        if viewModel.finalAttendanceDone {
                            GeneralAttendanceDoneView(attendanceType: "Pontaj final", attendanceMessage: "Ai pontat astăzi la final cu succes!")
                        } else {
                            GeneralAttendanceView(
                                viewModel: viewModel,
                                attendanceType: .final,
                                attendanceTitle: "Pontaj final",
                                attendanceSubtitle: "Nu uita să te pontezi la final de tură, înainte să pleci."
                            ) {
                                viewModel.finalAttendanceDone = true
                            }
                        }
                        
                        AttendanceHistoryScreen(viewModel: viewModel)
                            .padding(.top, 12)

                    } else {
                        HStack {
                            LottieViewGeneral(name: "Blue Animation", loopMode: .loop)
                                .scaleEffect(0.3)
                        }.frame(maxWidth: 400, maxHeight: .infinity, alignment: .center)
                    }
                }.padding([.horizontal, .top], 10)
                 .toolbar(.hidden)
            }.background(Color.whiteProfile)
             .overlay {
                    if viewModel.showConfirmInitScreen {
                        GeneralPopup(title: "Pontajul inițial a fost realizat cu succes", animationName: "Done") {
                            viewModel.getAttendanceById()
                            viewModel.initAttendanceDone = true
                            viewModel.showConfirmInitScreen = false
                        }.ignoresSafeArea(.all)
                            .transition(.opacity.animation(.default))
                            .onAppear {
                                cs.color = UIColor(Color.black.opacity(0.6))
                            }
                    }
                 
                    if viewModel.showConfirmFinalScreen {
                        GeneralPopup(title: "Pontajul final a fost înregistrat cu succes!", animationName: "Done") {
                            viewModel.getAttendanceById()
                            viewModel.finalAttendanceDone = true
                            viewModel.showConfirmFinalScreen = false
                        }.transition(.opacity.animation(.default))
                            .onAppear {
                                cs.color = UIColor(Color.black.opacity(0.6))
                            }
                    }
                 
                    if viewModel.showErrorScreen {
                        GeneralPopup(title: viewModel.errorMessage, animationName: "Error") {
                            viewModel.showErrorScreen = false
                        }.ignoresSafeArea(.all)
                            .transition(.opacity.animation(.default))
                            .onAppear {
                                cs.color = UIColor(Color.black.opacity(0.6))
                            }
                        
                    }
                    
                    if viewModel.locationManager.isErrorLocation {
                        GeneralPopup(title: viewModel.locationManager.errorLocationMessage, animationName: "Error") {
                            viewModel.locationManager.isErrorLocation = false
                            viewModel.showErrorScreen = false
                        }.ignoresSafeArea(.all)
                            .transition(.opacity.animation(.default))
                            .onAppear {
                                cs.color = UIColor(Color.black.opacity(0.6))
                            }
                    }
            }
        }
    }
}
