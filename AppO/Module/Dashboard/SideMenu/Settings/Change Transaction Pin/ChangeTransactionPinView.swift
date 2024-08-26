//
//  ChangeTransactionPinView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct ChangeTransactionPinView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "Change Transaction Pin")
            
            Text("do not share your pin with anyone and keep it in a safe place.")
                .textCase(.uppercase)
                .foregroundStyle(Color.appOrange)
                .font(.title3)
                .fontWeight(.regular)
            
            VStack {
                HStack {
                    Text("Old Pin")
                    Spacer()
                    Text("Old Pin")
                }
                .padding(.top, 30)
                
                
            }
            .frame(width: 250)
            .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
        }
        .padding()
        .background(Color.appBackground)
    }
}

#Preview {
    ChangeTransactionPinView()
}
