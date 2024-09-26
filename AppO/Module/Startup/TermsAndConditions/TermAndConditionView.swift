//
//  TermAndConditionView.swift
//  AppO
//
//  Created by Abul Jaleel on 15/08/2024.
//

import SwiftUI

struct TermAndConditionView: View {
    
    @State private var isChecked: Bool = false
    @EnvironmentObject var navigator: Navigator
    
    @State private var cameraPermissionGranted = false
    @State private var audioPermissionGranted = false
    @State private var faceIDPermissionGranted = false
    let permissionsService = PermissionServiceManager()
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarView(title: "Terms and Conditions")
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("APPO User Terms of Service Agreement")
                        .font(.headline)
                    
                    Text("Effective Date: December 31, 2023")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Insert the full terms and conditions content here
                    Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
                        .font(.body)
                }
                .padding()
            }
            VStack {
                HStack {
                    Button(action: {
                        mediumHaptic()
                        isChecked.toggle()
                        requestPermissions()
                    }) {
                        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                            .foregroundColor(isChecked ? .appBlue : .gray)
                            .font(.system(size: 25))
                        Text("I have read the terms and conditions")
                            .font(AppFonts.bodySixteenBold)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
                Button {
                    lightHaptic()
                    if cameraPermissionGranted && audioPermissionGranted {
                        AppDefaults.isTermConditionsChecked = true
                        navigator.navigate(to: .enterMPINView(viewModel: .init()))
                    }
                } label: {
                    Text("Next")
                        .font(AppFonts.headline4)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(isChecked ? Color.appBlue : Color.appBlue.opacity(0.4))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .disabled(!isChecked)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color.white)
        }
        .edgesIgnoringSafeArea(.top)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private func requestPermissions() {
        // Check Camera Permission
        permissionsService.checkCameraPermission { granted in
            DispatchQueue.main.async {
                self.cameraPermissionGranted = granted
            }
        }
        
        // Check Audio Permission
        permissionsService.checkAudioPermission { granted in
            DispatchQueue.main.async {
                self.audioPermissionGranted = granted
            }
        }
        
        // Check Face ID Permission
        permissionsService.checkFaceIDPermission { granted in
            DispatchQueue.main.async {
                self.faceIDPermissionGranted = granted
            }
        }
    }
}

#Preview {
    TermAndConditionView()
}
