//
//  PhoneNumberVerificationRequest.swift
//  AppO
//
//  Created by Abul Jaleel on 26/09/2024.
//

import Foundation

// MARK: - Main Request Structure
struct PhoneNumberVerificationRequest: Codable {
    let reqHeaderInfo: RequestHeaderInfo
    let digestInfo: String = "NA"
    let deviceInfo: DeviceInfo
    let requestKey: RequestKey
    let requestData: PhoneNumberVerificationRequesttData

    enum CodingKeys: String, CodingKey {
        case reqHeaderInfo = "req_header_info"
        case digestInfo = "digest_info"
        case deviceInfo = "device_info"
        case requestKey = "request_key"
        case requestData = "request_data"
    }
}

// MARK: - RequestData
struct PhoneNumberVerificationRequesttData: Codable {
    let instID: String
    let mobileNum: String

    enum CodingKeys: String, CodingKey {
        case instID = "inst_id"
        case mobileNum = "mobile_num"
    }
}
