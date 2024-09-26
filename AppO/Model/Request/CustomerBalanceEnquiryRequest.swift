//
//  CustomerBalanceEnquiryRequest.swift
//  AppO
//
//  Created by Abul Jaleel on 26/09/2024.
//


// MARK: - Main Request Structure
struct CustomerBalanceEnquiryRequest: Codable {
    let reqHeaderInfo: RequestHeaderInfo
    let digestInfo: String = "NA"
    let requestKey: RequestKey
    let requestData: CustomerBalanceEnquiryRequestData

    enum CodingKeys: String, CodingKey {
        case reqHeaderInfo = "req_header_info"
        case digestInfo = "digest_info"
        case requestKey = "request_key"
        case requestData = "request_data"
    }
}

// MARK: - RequestData
struct CustomerBalanceEnquiryRequestData: Codable {
    let instId: String
    let cardRefNum: String
    let mobile: String
    let deviceNo: String

    enum CodingKeys: String, CodingKey {
        case instId = "inst_id"
        case cardRefNum = "card_ref_num"
        case mobile = "mobile"
        case deviceNo = "device_no"
    }
}
