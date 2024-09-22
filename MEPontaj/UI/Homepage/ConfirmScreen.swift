//
//  ConfirmScreen.swift
//  MEPontaj
//
//  Created by Robert Oană on 08.08.2024.
//

import Foundation
import SwiftUI

struct ConfirmInitScreen: View {
    let onCancelTap: () -> ()
    
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.6)
            VStack(spacing: 30) {
                
                Image(.icCorrect)
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                    .padding(.top, 32)
                
                Text("Pontajul initial a fost inregistrat cu succes!")
                    .font(.poppinsMedium(size: 20))
                    .foregroundStyle(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(24)
                
                Button {
                    onCancelTap()
                } label: {
                    Text("Ok!")
                        .font(.poppinsRegular(size: 20))
                        .foregroundStyle(Color.white)
                }.frame(maxWidth: 300, maxHeight: 50, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(40)
                    .padding(.bottom, 24)
            }.background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
