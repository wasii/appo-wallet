//
//  APIBaseResponse.swift
//  TestCasesDemo
//
//  Created by Aqeel Ahmed on 05/09/2023.
//

import Foundation

typealias Parameters = [String: Any]

typealias ResponseCompletion<T: Codable> = ((_ response: APIBaseResponse<T>?, _ error: String?) -> Void)

struct APIBaseResponse<ResponseData: Codable>: Codable {
    let success: String?
    var message: String?
    let data: ResponseData?
}

struct SystemAPIBaseResponse<ResponseData: Codable>: Codable {
    let respInfo: SystemAPIResponse<ResponseData>?
    
    enum CodingKeys: String, CodingKey {
        case respInfo = "resp_info"
    }
}
struct SystemAPIResponse<ResponseData: Codable>: Codable {
    let appCorrectiveAction: String?
    let appErrDesc: String?
    let rejectCode: String?
    let rejectLongDesc: String?
    let rejectModule: String?
    let rejectModuleType: String?
    let rejectShortDesc: String?
    let respCode: String?
    let respData: ResponseData?
    let respDesc: String?
    let respStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case appCorrectiveAction = "app_corrective_action"
        case appErrDesc = "app_err_desc"
        case rejectCode = "reject_code"
        case rejectLongDesc = "reject_long_desc"
        case rejectModule = "reject_module"
        case rejectModuleType = "reject_module_type"
        case rejectShortDesc = "reject_short_desc"
        case respCode = "resp_code"
        case respData = "resp_data"
        case respDesc = "resp_desc"
        case respStatus = "resp_status"
    }
}
