//
//  WithdrawLimitView.swift
//  AppO
//
//  Created by Abul Jaleel on 12/09/2024.
//

import SwiftUI

struct WithdrawLimitView: View {
    @Binding var withdrawLimit: Double
    var title: String
    
    var body: some View {
        HStack {
            HStack {
                Image("dollar-sign-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .foregroundColor(.white)
                Text(title)
                    .font(AppFonts.bodyFourteenBold)
                    .foregroundColor(.appBlue)
            }
            
            Spacer()

            // Right side slider with text
            VStack(alignment: .leading) {
                HStack {
                    Text("Set Daily \(title)")
                        .font(AppFonts.regularTwelve)
                        .foregroundColor(.black)

                    Spacer()
                    
                    HStack(spacing: 2) {
                        Text("$")
                            .font(AppFonts.bodyTwelveBold)
                        Text("\(Int(withdrawLimit))")
                            .font(AppFonts.regularTwelve)
                    }
                }
                
                // Slider
                Slider(value: $withdrawLimit, in: 100...9999)
                    .accentColor(.appBlue)
                
                // Min and Max labels
                HStack {
                    Text("$100")
                    Spacer()
                    Text("$9999")
                }
                .font(AppFonts.bodyTwelveBold)
            }
            .frame(width: 200)
        }
    }
}

struct WithdrawLimitView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawLimitView(withdrawLimit: .constant(0), title: "Withdrawal Limit")
    }
}
