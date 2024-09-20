//
//  CustomerEnquiryRequest.swift
//  AppO
//
//  Created by Abul Jaleel on 20/09/2024.
//

import Foundation
struct CustomerEnquiryRequest: Codable {
    let reqHeaderInfo: RequestHeaderInfo
    let digestInfo: String = "NA"
    let requestKey: RequestKey
    let requestData: CustomerEnquiryRequestData
    
    enum CodingKeys: String, CodingKey {
        case reqHeaderInfo = "req_header_info"
        case digestInfo = "digest_info"
        case requestKey = "request_key"
        case requestData = "request_data"
    }
}

// MARK: - RequestData
struct CustomerEnquiryRequestData: Codable {
    let instID: String
    let mobile: String
    let deviceNo: String

    enum CodingKeys: String, CodingKey {
        case instID = "inst_id"
        case mobile
        case deviceNo = "device_no"
    }
}
