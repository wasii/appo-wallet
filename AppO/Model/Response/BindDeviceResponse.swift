//
//  BindDeviceResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 24/09/2024.
//

import Foundation

struct BindDeviceResponse: Codable {
    let previousDeviceId: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case previousDeviceId
        case message
    }
}
