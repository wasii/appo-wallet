//
//  VerifyPINResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 24/09/2024.
//


import Foundation

struct VerifyPINResponse: Codable {
    let lastLoginTime: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case lastLoginTime
        case message
    }
}
