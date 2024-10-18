//
//  Navigator.swift
//  AppO
//
//  Created by Abul Jaleel on 23/08/2024.
//

import Foundation
import SwiftUI

final class Navigator: ObservableObject {

    enum Destination: Hashable, Identifiable {
        var id: Self { self }
        func hash(into hasher: inout Hasher) {
            hasher.combine(0)
        }
        
        static func == (lhs: Destination, rhs: Destination) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
        
        case termsAndConditionView
        case enterMPINView(viewModel: EnterMPINViewModel)
        case phoneNumberVerification(viewModel: PhoneNumberVerificationViewModel)
        case verifyOTP(viewModel: VerifyOTPViewModel)
        case registration(viewModel: RegistrationViewModel)
        case setupMobilePin(viewModel: SetupMobilePinViewModel)
    }
    
    @Published var navPath = NavigationPath()
    @Published var presentedSheetDestination: Destination? // For modals
    @Published var presentedFullScreenDestination: Destination? // For modals
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateBack(to index: Int) {
        navPath.removeLast(navPath.count - index)
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
    
    func presentFullScreen(destination: Destination) {
        presentedFullScreenDestination = destination
    }
    
    func presentSheet(destination: Destination) {
        presentedSheetDestination = destination
    }
    
    func dismissModal() {
        presentedSheetDestination = nil
        presentedFullScreenDestination = nil
    }
}

// MARK: - ViewBuilder
extension Navigator {
    @ViewBuilder func view(for destination: Navigator.Destination) -> some View {
        switch destination {
        case .termsAndConditionView:
            TermAndConditionView()
                .environment(\.sizeCategory, .extraSmall)
        case .enterMPINView(let viewModel):
            EnterMPINView(viewModel: viewModel)
                .environment(\.sizeCategory, .extraSmall)
        case .phoneNumberVerification(let viewModel):
            PhoneNumberVerificationView(viewModel: viewModel)
                .environment(\.sizeCategory, .extraSmall)
        case .verifyOTP(let viewModel):
            VerifyOTPView(viewModel: viewModel)
                .environment(\.sizeCategory, .extraSmall)
        case .registration(let viewModel):
            RegistrationView(viewModel: viewModel)
                .environment(\.sizeCategory, .extraSmall)
        case .setupMobilePin(let viewModel):
            SetupMobilePinView(viewModel: viewModel)
                .environment(\.sizeCategory, .extraSmall)
        }
    }
}
