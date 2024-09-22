//
//  ConfirmScreen.swift
//  MEPontaj
//
//  Created by Robert Oană on 08.08.2024.
//

import Foundation
import SwiftUI
import Lottie

struct GeneralPopup: View {
    @ObservedObject private var cs = ColorSet.instance
    var title: String
    var animationName: String
    var action: () -> ()
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 30) {
                VStack {
                    LottieViewGeneral(name: animationName, loopMode: .playOnce)
                        .frame(width: 100, height: 100, alignment: .center)
                        .scaleEffect(0.4)
                }.padding(.top, 50)
                
                Text(title)
                    .font(.poppinsMedium(size: 20))
                    .foregroundStyle(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(24)
                
                Button {
                    action()
                    cs.color = .whiteProfile
                } label: {
                    Text("Am înțeles!")
                        .font(.poppinsRegular(size: 16))
                        .foregroundStyle(Color.white)
                }.frame(maxWidth: 300, maxHeight: 50, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(40)
                    .padding(.bottom, 24)
            }.background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color.black.opacity(0.6))
            .ignoresSafeArea()
    }
}
