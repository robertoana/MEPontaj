//
//  PopupLogout.swift
//  MEPontaj
//
//  Created by Robert Oană on 28.08.2024.
//

import SwiftUI

struct PopupLogout: View {
    @Environment(\.dismiss) private var dismiss
    let actionLogout: () -> ()
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 16) {
                
                Image(.icCorrect)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding(.top, 32)
                
                Text("Esti sigur ca vrei sa te deconectezi?")
                    .font(.poppinsMedium(size: 20))
                    .foregroundStyle(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(16)
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("Nu")
                            .font(.poppinsRegular(size: 20))
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.blue)
                        
                    }.frame(maxWidth: 180, maxHeight: 50, alignment: .center)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 20,
                                style: .continuous
                            )
                            .stroke(.blue, lineWidth: 2)
                        )
                    
                    
                    Spacer()
                    
                    Button {
                        actionLogout()
                    } label: {
                        Text("Da")
                            .font(.poppinsRegular(size: 20))
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.white)
                    }.frame(maxWidth: 180, maxHeight: 50, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(40)
                }.padding(.bottom, 40)
                    .padding(.horizontal, 20)
            }.background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 10)
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.horizontal, 20)
            .background(Color.black.opacity(0.6))
            .ignoresSafeArea()
    }
}
