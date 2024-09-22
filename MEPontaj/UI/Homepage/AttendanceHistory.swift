//
//  IstoricPontaje.swift
//  MEPontaj
//
//  Created by Robert Oană on 08.08.2024.
//

import Foundation
import SwiftUI

struct AttendanceHistoryScreen: View {
    
    @ObservedObject var viewModel: HomepageViewModel
    private let navigation = EnvironmentObjects.navigation
    
    var body: some View {
            
        switch viewModel.attendanceState {
        case .loading:
            HStack {
                Spacer()
                LottieViewGeneral(name: "Blue Animation", loopMode: .loop)
                    .scaleEffect(0.3)
                Spacer()
            }.frame(maxWidth: 400, maxHeight: 200, alignment: .center)
        case .ready(let attendances):
            VStack {
                
                Text("Istoric pontaje")
                    .font(.poppinsMedium(size: 20))
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 12)
                
                ScrollView {
                    
                    VStack(spacing: 10) {
                        HStack {
                            Text("Data")
                                .font(.poppinsBold(size: 17))
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color.black)
                            
                            Text("Durata")
                                .font(.poppinsBold(size: 17))
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color.black)
                            
                            Text("Șantier")
                                .font(.poppinsBold(size: 17))
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color.black)
                        }.padding(.horizontal)
                            .padding(.vertical, 10)
                        
                        ForEach(attendances.prefix(5), id: \.id) { attendance in
                            
                            HStack {
                                Text(attendance.start ?? "-")
                                    .font(.poppinsRegular(size: 16))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity)
                                
                                Text(attendance.time ?? "-")
                                    .font(.poppinsRegular(size: 16))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity)
                                
                                Text(attendance.constructionSiteName ?? "-")
                                    .font(.poppinsRegular(size: 16))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity)
                            }.padding(.horizontal)
                        }
                        Button {
                            navigation?.push(AttendanceFullHistory().asDestination(), animated: true)
                        } label: {
                            Text("Vezi tot istoricul ->")
                                .font(.poppinsBold(size: 16))
                                .foregroundStyle(Color.black)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(10)
                        }
                    }.frame(maxWidth:.infinity, alignment: .leading)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 12)
                        .background(Color.seasalt)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }.padding(.top, 12)
            }
        case .failure(_):
            VStack(spacing: 8) {
                Text("Istoric pontaje")
                    .font(.poppinsMedium(size: 20))
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 12)
                    .padding(.top, 10)
                
                VStack {
                    Text("Nu există pontaje disponibile!")
                        .font(.poppinsMedium(size: 16))
                        .foregroundStyle(Color.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(10)
                    
                    Image(.icEmpty)
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center )
                        .padding(.bottom, 12)
                    
                }.padding(.horizontal, 12)
                    .padding(.bottom, 12)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.seasalt)
                .clipShape(RoundedRectangle(cornerRadius: 20))
             .padding(.top, 16)
        }
    }
}
