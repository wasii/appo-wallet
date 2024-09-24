//
//  VerifyPINRequest.swift
//  AppO
//
//  Created by Abul Jaleel on 24/09/2024.
//

import Foundation

struct VerifyPINRequest: Codable {
    let deviceId: String = AppDefaults.deviceId ?? "23233"
    let mobilePin: String
    
    enum CodingKeys: String, CodingKey {
        case deviceId
        case mobilePin
    }
}
