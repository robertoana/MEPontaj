//
//  HolidayScreen.swift
//  MEPontaj
//
//  Created by Robert Oană on 19.08.2024.
//

import SwiftUI
import Lottie

struct HolidayScreen: View {
    
    @StateObject var viewModel = HolidayViewModel()
    private let navigation = EnvironmentObjects.navigation
    
    var body: some View {
        
        VStack {
            Text("Cerere concediu")
                .font(.poppinsMedium(size: 20))
                .foregroundStyle(Color.black)
                .frame(maxWidth:.infinity, alignment: .top)
            
            Spacer()
            
            switch viewModel.holidayState {
            case .loading:
                LottieViewGeneral(name: "Blue Animation", loopMode: .loop)
                    .scaleEffect(0.5)
            case .ready(let holidays):
                ScrollView(showsIndicators: false) {
                    ForEach(holidays, id:\.id) { holiday in
                        
                        VStack(alignment:.leading, spacing: 10) {
                            
                            Text(holiday.holidayType)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.poppinsMedium(size: 18))
                                .foregroundStyle(Color.black)
                            
                            HStack {
                                Text(holiday.startDate)
                                    .frame(alignment: .leading)
                                    .font(.poppinsMedium(size: 17))
                                    .foregroundStyle(Color.black)
                                
                                Text("→")
                                    .frame(alignment: .leading)
                                    .font(.poppinsMedium(size: 17))
                                    .foregroundStyle(Color.black)
                                
                                Text(holiday.finalDate)
                                    .frame(alignment: .leading)
                                    .font(.poppinsMedium(size: 17))
                                    .foregroundStyle(Color.black)
                            }
                            
                            Text(holiday.reason)
                                .frame(alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .font(.poppinsMedium(size: 17))
                                .foregroundStyle(Color.black)
                            
                            Text(holiday.status)
                                .padding(.horizontal)
                                .frame(height: 30, alignment: .leading)
                                .font(.poppinsRegular(size: 17))
                                .foregroundStyle(getColorBackgroundByText(status: holiday.status).textColor)
                                .background(getColorBackgroundByText(status: holiday.status).bgColor)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }.frame(maxWidth:.infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 20)
                            .background(Color.seasalt)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
            case .failure(_):
                VStack(spacing: 10) {
                    Image(.icEmpty2)
                        .resizable()
                        .frame(width: 150, height: 150, alignment: .center)
                    
                    Text("Nu au fost găsite cereri de concedii!")
                        .font(.poppinsMedium(size: 18))
                        .foregroundStyle(Color.black)
                        .frame(maxWidth:.infinity, alignment: .center)
                    
                    Text("Pentru a crea prima ta cerere de concediu in aplicatie, apasa pe butonul de mai jos.")
                        .font(.poppinsRegular(size: 14))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.black)
                        .frame(width: 300, height: 100, alignment: .center)
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            
            Spacer()
            
            Button {
                navigation?.push(HolidayRequestScreen(
                    reloadData: {
                        viewModel.getHolidaysById()
                    }).asDestination(), animated: true)
            } label: {
                Text("Cerere de concediu")
                    .foregroundStyle(Color.white)
                    .font(.poppinsMedium(size: 16))
                    .padding(15)
            }.frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                .background(Color.blue)
                .cornerRadius(40)

        }.padding(.all, 10)
            .background(Color.whiteProfile)
            .refreshable{
                 viewModel.getHolidaysById()
            }
    }
    
    fileprivate func getColorBackgroundByText(status: String) -> (textColor: Color, bgColor: Color) {
        switch status {
        case "Acceptat":
            return (Color.darkGreen, Color.lightGreen)
        case "Respins":
            return (Color.darkRed, Color.lightRed)
        case "În așteptare":
            return (Color.darkYellow, Color.lightYellow)
        default:
            return (Color.darkYellow, Color.lightYellow)
        }
    }
}


