//
//  GeneralAttendanceDoneView.swift
//  MEPontaj
//
//  Created by Robert Oană on 26.08.2024.
//

import Foundation
import SwiftUI

struct GeneralAttendanceDoneView: View {

    let attendanceType: String
    let attendanceMessage: String
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 10) {
                
                Text(attendanceType)
                    .font(.poppinsMedium(size: 18))
                    .foregroundStyle(Color.black)
                    .padding(.top, 20)
                
                Text(attendanceMessage)
                    .foregroundStyle(Color.black)
                    .font(.poppinsRegular(size: 13))
            }
            
            Spacer()
            
            Image(.icCorrect)
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.top, 10)
            
        }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 20)
            .padding(.horizontal, 12)
            .background(Color.lightGreen)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
