//
//  ReBindDeviceRequest.swift
//  AppO
//
//  Created by Abul Jaleel on 24/09/2024.
//

struct ReBindDeviceRequest: Codable {
    let mobileNo: String
    let deviceId: String
    
    enum CodingKeys: String, CodingKey {
        case mobileNo
        case deviceId
    }
}
