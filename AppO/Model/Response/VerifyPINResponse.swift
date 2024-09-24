//
//  VerifyPINResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 24/09/2024.
//


import Foundation

struct VerifyPINResponse: Codable {
    let status: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
