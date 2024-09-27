//
//  ChangeCardStatusRequest.swift
//  AppO
//
//  Created by Abul Jaleel on 27/09/2024.
//

import Foundation
// MARK: - Main Request Structure
struct ChangeCardStatusRequest: Codable {
    let reqHeaderInfo: RequestHeaderInfo
    let digestInfo: String = "NA"
    let deviceInfo: DeviceInfo
    let requestKey: RequestKey
    let requestData: ChangeCardStatusRequestData

    enum CodingKeys: String, CodingKey {
        case reqHeaderInfo = "req_header_info"
        case digestInfo = "digest_info"
        case deviceInfo = "device_info"
        case requestKey = "request_key"
        case requestData = "request_data"
    }
}

// MARK: - RequestData
struct ChangeCardStatusRequestData: Codable {
    let instId: String
    let cardRefNum: String
    let cardStatus: String
    let mobileNo: String
    

    enum CodingKeys: String, CodingKey {
        case instId = "inst_id"
        case cardRefNum = "card_ref_num"
        case cardStatus = "card_status"
        case mobileNo = "mobile_no"
    }
}
