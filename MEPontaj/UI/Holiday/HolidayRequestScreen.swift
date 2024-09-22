//
//  HolidayRequest.swift
//  MEPontaj
//
//  Created by Robert Oană on 20.08.2024.
//

import SwiftUI
import AlertToast

struct HolidayRequestScreen:View {
    private let navigation = EnvironmentObjects.navigation
    
    @StateObject private var viewModel = HolidayRequestViewModel()
    @State private var selectedHoliday: String = "Selectează concediul"
    @State private var showHolidays = false
    @State private var startDate = Date()
    @State private var finalDate = Date()
    @State private var reason: String = ""
    @State private var errorMessage: String = ""
    
    var reloadData: () -> ()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    navigation?.pop(animated: true)
                } label: {
                    Image(.icBack)
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .leading)
                }.padding(.leading, 12)
                
                
                Text("Creeaza cerere de concediu")
                    .font(.poppinsMedium(size: 20))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(Color.black)
                
                Color.clear
                    .frame(width: 30, height: 30, alignment: .leading)
            }
            
            ScrollView(showsIndicators: false) {
                VStack {
                    VStack(alignment:.leading) {
                        Text("Tip concediu")
                            .font(.poppinsRegular(size: 16))
                            .frame(maxWidth:.infinity,alignment: .leading)
                            .foregroundStyle(Color.black)
                        
                        Button {
                            showHolidays.toggle()
                        } label: {
                            if selectedHoliday.contains("Selectează concediul") {
                            HStack {
                                    Text(selectedHoliday)
                                        .font(.poppinsRegular(size: 14))
                                        .foregroundStyle(Color.gray)
                                    Spacer()
                                    Image(.icDown)
                                        .resizable()
                                        .frame(width: 15, height: 15 )
                                    
                                }.padding(.horizontal, 12)
                            } else {
                                HStack {
                                        Text(selectedHoliday)
                                            .font(.poppinsRegular(size: 14))
                                            .foregroundStyle(Color.black)
                                        Spacer()
                                        Image(.icDown)
                                            .resizable()
                                            .frame(width: 15, height: 15 )
                                        
                                    }.padding(.horizontal, 12)
                            }
                        }.sheet(isPresented: $showHolidays) {
                            VStack {
                                Text("Selectează concediul")
                                    .font(.poppinsBold(size: 20))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth:.infinity,alignment: .leading)
                                    .padding(20)
                                
                                ScrollView(showsIndicators: false) {
                                    
                                    VStack(alignment: .leading, spacing: 16) {
                                        HolidaysReasons(selectedHoliday: $selectedHoliday)
                                    }.background(Color.white)
                                    
                                    
                                }.ignoresSafeArea(.all)
                                    .presentationDetents([.height(430)])
                                    .presentationDragIndicator(.visible)
                                    .padding(.bottom, 20)
                            }
                        }.frame(height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }.padding(20)
                    
                    VStack {
                        Text("Dată început")
                            .font(.poppinsRegular(size: 16))
                            .frame(maxWidth:.infinity,alignment: .leading)
                            .foregroundStyle(Color.black)
                        
                        HStack {
                            
                            Text(startDate.formatDate())
                                .font(.poppinsRegular(size: 14))
                                .foregroundStyle(Color.black)
                            
                            DatePickerView(date: $startDate)
                        }.padding(.all, 8)
                        
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }.padding(.horizontal, 20)
                        .padding(.bottom, 16)
                    
                    VStack {
                        Text("Dată sfârșit")
                            .font(.poppinsRegular(size: 16))
                            .frame(maxWidth:.infinity,alignment: .leading)
                            .foregroundStyle(Color.black)
                        
                        HStack {
                            
                            Text(finalDate.formatDate())
                                .font(.poppinsRegular(size: 14))
                                .foregroundStyle(Color.black)
                            
                            DatePickerView(date: $finalDate)
                        }.padding(.all, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }.padding(.horizontal, 20)
                        .padding(.bottom, 16)
                    
                    VStack {
                        Text("Motiv")
                            .font(.poppinsRegular(size: 16))
                            .frame(maxWidth:.infinity,alignment: .leading)
                            .foregroundStyle(Color.black)
                        
                        TextField("Completează motivul", text: $reason, axis: .vertical)
                            .lineLimit(5...10)
                            .font(.poppinsRegular(size: 14))
                            .foregroundStyle(Color.black)
                            .padding(.horizontal, 20)
                            .frame(height: 150)
                            .textFieldStyle(PlainTextFieldStyle())
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                            .keyboardType(.asciiCapable)
                            .submitLabel(.done)
                            .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    Button("Done") {
                                        UIApplication.shared.endEditing(true)
                                    }.frame(alignment:.leading)
                                }
                            }
                    }.padding(.horizontal, 20)
                    
                    Button {
                        viewModel.submitHoliday(selectedHoliday: selectedHoliday, startDate: startDate, finalDate: finalDate, reason: reason)
                    } label: {
                        Text("Trimite cererea de concediu")
                            .foregroundStyle(Color.white)
                            .font(.poppinsMedium(size: 16))
                            .padding(15)
                    }.frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(40)
                        .padding(20)
                }
            }.onReceive(viewModel.eventSubject, perform: { event in
                    switch event {
                    case .succes(let message):
                        reloadData()
                        navigation?.presentModal(
                            GeneralPopup(
                                title: message ?? "",
                                animationName: "Done",
                                action: {
                                    navigation?.dismissModal(animated: true, completion: nil)
                                    navigation?.pop(animated: true)
                                }
                            ).asDestination(), animated: true)
                    case .error(let error):
                        if let receivedError = error as? ServerError {
                            errorMessage = receivedError.message
                        } else {
                            errorMessage = error.localizedDescription
                        }
                        navigation?.presentModal(GeneralPopup(title: errorMessage, animationName: "Error", action: {
                            navigation?.dismissModal(animated: true, completion: nil)
                        }).asDestination(), animated: true)
                    }
                })
        }.background(Color.white)
        .toast(
            isPresenting: $viewModel.showErrorToast,
            alert: {
                AlertToast(displayMode: .alert, type: .error(Color.red), title: viewModel.errorMessage)
            })
        .overlay{
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
    }
}

struct HolidaysReasons:View {
    
    @Environment(\.dismiss) private var dismiss
    
    let holidays = [
        "De odihnă",
        "Medical",
        "Fără plată",
        "De maternitate",
        "De paternitate",
        "De creștere a copilului",
        "Pentru evenimente familiale deosebite",
        "Pentru formare profesională",
        "De risc maternal",
        "Pentru îngrijirea copilului bolnav"
    ]

    
    @Binding var selectedHoliday: String
    
    var body: some View {
        ForEach(holidays, id:\.self) { holiday in
            Button {
                selectedHoliday = holiday
                dismiss()
            } label: {
                let isSelected = holiday == selectedHoliday
                if isSelected == false {
                    HStack{
                        Text(holiday)
                            .font(.poppinsMedium(size: 16))
                            .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                            .frame(alignment: .leading)
                            .foregroundStyle(Color.black)
                            .padding(.horizontal, 20)
                        Spacer()
                    }
                } else {
                    HStack {
                        Text(holiday)
                            .font(.poppinsBold(size: 16))
                            .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                            .frame(alignment: .leading)
                            .foregroundStyle(Color.black)
                            .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        Image(.icCheckboxSelected)
                            .resizable()
                            .frame(width:20, height: 20)
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        withAnimation(.default) {
            self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

//#Preview {
//    HolidayRequestScreen()
//}
