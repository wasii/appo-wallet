//
//  RegistrationModel.swift
//  AppO
//
//  Created by Abul Jaleel on 23/08/2024.
//

import Foundation

// MARK: - Main Request Structure
struct RegistrationRequest: Codable {
    let reqHeaderInfo: ReqHeaderInfo
    let digestInfo: String
    let requestKey: RequestKey
    let requestData: RequestData
    
    enum CodingKeys: String, CodingKey {
        case reqHeaderInfo = "req_header_info"
        case digestInfo = "digest_info"
        case requestKey = "request_key"
        case requestData = "request_data"
    }
}

// MARK: - Request Header Info
struct ReqHeaderInfo: Codable {
    let apiVersion: String
    let title: String
    let deviceAddr: String
    let requestID: String
    let orgDate: String
    let orgTime: String
    let echoMessage: String
    
    enum CodingKeys: String, CodingKey {
        case apiVersion = "api_version"
        case title
        case deviceAddr = "device_addr"
        case requestID = "request_id"
        case orgDate = "org_date"
        case orgTime = "org_time"
        case echoMessage = "echo_message"
    }
}

// MARK: - Request Key
struct RequestKey: Codable {
    let requestID: String
    let requestType: String
    
    enum CodingKeys: String, CodingKey {
        case requestID = "request_id"
        case requestType = "request_type"
    }
}

// MARK: - Request Data
struct RequestData: Codable {
    let instID: String
    let custName: String
    let mobile: String
    let nameOnCard: String
    let email: String
    let address: String
    let dob: String
    let nationalID: String
    let maritalStatus: String
    let bin: String
    let subproductID: String
    let deviceNo: String
    
    enum CodingKeys: String, CodingKey {
        case instID = "inst_id"
        case custName = "cust_name"
        case mobile
        case nameOnCard = "name_on_card"
        case email
        case address
        case dob
        case nationalID = "national_id"
        case maritalStatus = "marital_status"
        case bin
        case subproductID = "subproduct_id"
        case deviceNo = "device_no"
    }
}
