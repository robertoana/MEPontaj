//
//  UserWelcomeView.swift
//  MEPontaj
//
//  Created by Robert Oană on 08.08.2024.
//

import Foundation
import SwiftUI

struct UserWelcomeScreen: View {
    let userName: String
    
    var body: some View {
        HStack {
            LottieViewGeneral(name: "Worker", loopMode: .loop)
                .frame(width: 100, height: 100)
                .scaleEffect(0.1)
                .padding(10)
            
            VStack(alignment: .leading, spacing: 10) {
                
                Text("Bine ai venit, \(userName)!")
                    .foregroundStyle(Color.black)
                    .font(.poppinsMedium(size: 20))
                
                Text("Succes la muncă!")
                    .foregroundStyle(Color.black)
                    .font(.poppinsRegular(size: 15))
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
            
        }.frame(maxWidth:.infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .background(Color.seasalt)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
