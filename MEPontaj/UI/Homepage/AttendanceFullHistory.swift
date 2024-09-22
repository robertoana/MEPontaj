//
//  AttendanceFullHistory.swift
//  MEPontaj
//
//  Created by Robert Oană on 26.08.2024.
//

import Foundation
import SwiftUI

struct AttendanceFullHistory: View {
    
    @StateObject private var viewModel = AttendanceFullHistoryViewModel()
    @State private var selectedConstructionSite: String? = nil
    @State private var showConstructionSites = false
    private let navigation = EnvironmentObjects.navigation
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing:0) {
                
                Button {
                    navigation?.pop(animated: true)
                } label: {
                    Image(.icBack)
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .leading)
                }.padding(.leading, 12)
                
                Text("Pontaje")
                    .font(.poppinsMedium(size: 20))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(Color.black)
                
                Color.clear
                    .frame(width: 42, height: 30, alignment: .leading)
            }.frame(maxWidth: .infinity)
                .background(Color.white)
                .padding(.bottom, 8)
            
            VStack(spacing:0) {
                
                Button {
                    showConstructionSites.toggle()
                } label: {
                    Text(selectedConstructionSite ?? "Selectează un șantier")
                        .font(.poppinsRegular(size: 15))
                        .foregroundStyle(Color.black)
                        .frame(alignment:.leading)
                    
                    Image(.icDown)
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .leading)
                        .padding(.trailing, 10)
                    
                }.frame(alignment: .leading)
                    .padding(.leading, 20)
                    .background(Color.white)
                    .sheet(isPresented: $showConstructionSites) {
                        
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .center) {
                                Text("Selectează un șantier")
                                    .font(.poppinsBold(size: 18))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundStyle(Color.black)
                                    .padding(.top, 20)
                                
                                AssignedAttendanceView(selectedConstructionSite: $selectedConstructionSite)
                                    .frame(alignment: .center)
                            }
                        }.ignoresSafeArea(.all)
                            .background(Color.white)
                            .presentationDetents([.height(390)])
                            .presentationDragIndicator(.visible)
                    }.frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                switch viewModel.attendanceState {
                case .loading:
                    HStack {
                        Spacer()
                        LottieViewGeneral(name: "Blue Animation", loopMode: .loop)
                            .scaleEffect(0.5)
                        Spacer()
                    }.frame(maxWidth:.infinity)
                        .background(Color.white)
                    
                case .ready(let attendances):
                    
                    let attendanceFilter = attendances.filter { attendance in
                        selectedConstructionSite == nil ||
                        selectedConstructionSite == attendance.constructionSiteName
                    }
                    
                    ScrollView(showsIndicators: false)  {
                        
                        VStack(spacing: 10) {
                            if attendanceFilter.isEmpty {
                                
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
                                    
                                }
                            } else {
                                
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
                                
                                ForEach(attendanceFilter, id: \.id) { attendance in
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
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12)
                            .padding(.bottom, 12)
                            .background(Color.seasalt)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.all, 14)
                case .failure(let error):
                    Text("Eroare: \(error)")
                }
            }.background(Color.white)
        }.background(Color.white)
    }
}

struct AssignedAttendanceView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = AttendanceFullHistoryViewModel()
    @Binding var selectedConstructionSite: String?
    
    var body: some View {
        VStack {
            switch viewModel.assignedConstructionSiteState {
            case .loading:
                HStack {
                    Spacer()
                    LottieViewGeneral(name: "Blue Animation", loopMode: .loop)
                        .scaleEffect(0.3)
                    Spacer()
                }.frame(maxWidth:.infinity, maxHeight: 100,alignment: .center)
            case .ready(let assignedSites):
                ForEach(assignedSites, id: \.id) { assignedSite in
                    Button {
                        selectedConstructionSite = assignedSite.nume
                        dismiss()
                    } label: {
                        HStack(alignment:.center) {
                            
                            if assignedSite.nume == selectedConstructionSite {
                                
                                Text(assignedSite.nume)
                                    .font(.poppinsBold(size: 14))
                                    .frame(alignment: .center)
                                    .foregroundStyle(Color.black)
                                
                                Image(.icCheckboxSelected)
                                    .resizable()
                                    .frame(width:20, height: 20)
                            } else {
                                Text(assignedSite.nume)
                                    .font(.poppinsRegular(size: 14))
                                    .frame(alignment: .center)
                                    .foregroundStyle(Color.black)
                            }
                        }
                         .padding(12)
                    }
                }.frame(alignment: .center)
                
            case .failure(let error):
                Text("Eroare:\(error)")
            }
        }
    }
}
