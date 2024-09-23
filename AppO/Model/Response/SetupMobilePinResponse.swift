//
//  SendOTPResponse 2.swift
//  AppO
//
//  Created by Abul Jaleel on 23/09/2024.
//


import Foundation

struct SetupMobilePinResponse: Codable {
    let status: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
