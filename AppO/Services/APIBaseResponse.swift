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
