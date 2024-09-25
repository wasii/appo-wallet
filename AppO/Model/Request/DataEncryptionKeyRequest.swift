//
//  DataEncryptionKeyRequest.swift
//  AppO
//
//  Created by Abul Jaleel on 25/09/2024.
//

import Foundation

// MARK: - Main Request Structure
struct DataEncryptionKeyRequest: Codable {
    let reqHeaderInfo: RequestHeaderInfo
    let digestInfo: String = "NA"
    let requestKey: RequestKey
    let requestData: DataMasterKeyRequestData

    enum CodingKeys: String, CodingKey {
        case reqHeaderInfo = "req_header_info"
        case digestInfo = "digest_info"
        case requestKey = "request_key"
        case requestData = "request_data"
    }
}

// MARK: - RequestData
struct DataEncryptionKeyRequestData: Codable {
    let instId: String
    let mobileNum: String

    enum CodingKeys: String, CodingKey {
        case instId = "inst_id"
        case mobileNum = "mobile_num"
    }
}
