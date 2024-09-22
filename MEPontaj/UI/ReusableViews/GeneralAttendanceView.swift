//
//  GeneralAttendanceView.swift
//  MEPontaj
//
//  Created by Robert Oană on 08.08.2024.
//

import Foundation
import SwiftUI

struct GeneralAttendanceView: View {
    
    @StateObject var viewModel: HomepageViewModel
    @ObservedObject private var cs = ColorSet.instance
    let attendanceType: AttendanceType
    let attendanceTitle: String
    let attendanceSubtitle: String
    let actionInitAttendance: () -> ()
    
    var body: some View {
        
        VStack(alignment:.leading, spacing: 10) {
            
            Text(attendanceTitle)
                .font(.poppinsMedium(size: 18))
                .foregroundStyle(Color.black)
                .padding(.top, 20)
            
            Text(attendanceSubtitle)
                .font(.poppinsRegular(size: 13))
                .foregroundStyle(Color.black)
            
            Button {
                viewModel.startAttendance(attendanceType: attendanceType)
                cs.color = UIColor(Color.black.opacity(0.6))
            } label: {
                Text(attendanceTitle)
                    .foregroundStyle(Color.white)
                    .font(.poppinsMedium(size: 16))
                    .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                    .padding(15)
            }
            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
            .background(Color.blue)
            .cornerRadius(40)
            .onReceive(viewModel.eventSubject) { event in
                switch event {
                case .initAttendanceDone:
                    viewModel.showConfirmInitScreen = true
                case .finalAttendanceDone:
                    viewModel.showConfirmFinalScreen = true
                case .error(let error):
                    viewModel.errorMessage = error.localizedDescription
                    viewModel.showErrorScreen = true
                }
            }
            .overlay {
                if viewModel.isLoading {
                    LottieViewGeneral(name: "Blue Animation", loopMode: .loop)
                        .scaleEffect(0.1)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 20)
        .padding(.horizontal, 12)
        .background(Color.seasalt)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

