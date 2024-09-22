//
//  MainView.swift
//  MEPontaj
//
//  Created by Robert Oană on 07.08.2024.
//

import SwiftUI

enum TabBar {
    case attendance
    case constructionSite
    case holiday
    case profile
}

struct MainView: View {
    
    private let colorSet = ColorSet.instance
    @State var tabBarSelected = TabBar.attendance
    @State private var backgroundColor: Color = .whiteProfile
    @ObservedObject private var cs = ColorSet.instance
    
    var body: some View {
        VStack(spacing:0) {
            GeometryReader { proxy in
                LazyHStack {
                    Group {
                        switch tabBarSelected {
                        case .attendance:
                            HomepageView()
                        case .constructionSite:
                            ContentView()
                        case .holiday:
                            HolidayScreen()
                        case .profile:
                            ProfileScreen()
                        }
                    }.frame(width: proxy.size.width, height: proxy.size.height)
                }
            }
            
            Divider()
            
            HStack {
                
                Spacer()
                
                Button {
                    tabBarSelected = .attendance
                } label: {
                    
                    if tabBarSelected == .attendance {
                        VStack {
                            Image("icAttendance")
                                .resizable()
                                .renderingMode(.template)
                                .tint(Color.blue)
                                .frame(width: 25, height: 25, alignment: .center)
                            
                            Text("Pontaje")
                                .font(.poppinsRegular(size: 14))
                                .foregroundStyle(Color.blue)
                        }
                    } else {
                        VStack {
                            Image("icAttendance")
                                .resizable()
                                .frame(width: 25, height: 25, alignment: .center)
                            Text("Pontaje")
                                .font(.poppinsRegular(size: 14))
                                .foregroundStyle(Color.black)
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    tabBarSelected = .constructionSite
                } label: {
                    VStack {
                        if tabBarSelected == .constructionSite {
                            Image("icConstructionSite")
                                .resizable()
                                .renderingMode(.template)
                                .tint(Color.blue)
                                .frame(width: 25, height: 25, alignment: .center)
                            
                            Text("Santier")
                                .font(.poppinsRegular(size: 14))
                                .foregroundStyle(Color.blue)
                        } else {
                            Image("icConstructionSite")
                                .resizable()
                                .frame(width: 25, height: 25, alignment: .center)
                            
                            Text("Santier")
                                .font(.poppinsRegular(size: 14))
                                .foregroundStyle(Color.black)
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    tabBarSelected = .holiday
                } label: {
                    VStack {
                        
                        if tabBarSelected == .holiday {
                            Image("icCalendar")
                                .resizable()
                                .renderingMode(.template)
                                .tint(Color.blue)
                                .frame(width: 25, height: 25, alignment: .center)
                            
                            Text("Concedii")
                                .font(.poppinsRegular(size: 14))
                                .foregroundStyle(Color.blue)
                        } else {
                            Image("icCalendar")
                                .resizable()
                                .frame(width: 25, height: 25, alignment: .center)
                            
                            Text("Concedii")
                                .font(.poppinsRegular(size: 14))
                                .foregroundStyle(Color.black)
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    tabBarSelected = .profile
                } label: {
                    VStack {
                        
                        if tabBarSelected == .profile {
                            Image("icProfile")
                                .resizable()
                                .renderingMode(.template)
                                .tint(Color.blue)
                                .frame(width: 25, height: 25, alignment: .center)
                            
                            Text("Profil")
                                .font(.poppinsRegular(size: 14))
                                .foregroundStyle(Color.blue)
                        } else {
                            Image("icProfile")
                                .resizable()
                                .frame(width: 25, height: 25, alignment: .center)
                            
                            Text("Profil")
                                .font(.poppinsRegular(size: 14))
                                .foregroundStyle(Color.black)
                        }
                    }
                }
                
                Spacer()
                
            }.padding(.top, 10)
             .background(backgroundColor)
        }
        .tint(Color.blue)
        .onChange(of: cs.color, perform: { value in
            //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.default) {
                self.backgroundColor = Color(value)
            }
            //                }
        })
        .presentationCornerRadius(20)
    }
}

