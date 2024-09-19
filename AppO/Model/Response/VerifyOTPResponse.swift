//
//  VerifyOTPResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 19/09/2024.
//

import Foundation

struct VerifyOTPResponse: Codable {
    let status: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
