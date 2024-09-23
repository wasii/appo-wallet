//
//  SetupMobilePinRequest.swift
//  AppO
//
//  Created by Abul Jaleel on 23/09/2024.
//

import Foundation

struct SetupMobilePinRequest: Codable {
    let deviceId: String = "23233"
    let mobilePin: String
    
    enum CodingKeys: String, CodingKey {
        case deviceId
        case mobilePin
    }
}
