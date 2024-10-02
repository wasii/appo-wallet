//
//  TransactionsAPI.swift
//  AppO
//
//  Created by Abul Jaleel on 02/10/2024.
//

import Foundation
import Moya

enum TransactionsAPI {
    case card_to_card(parameters: Parameters)
}

extension TransactionsAPI: TargetType {

    var baseURL: URL {
        switch self {
        case .card_to_card:
            let urlString: String = AppEnvironment[.systemURL]
            return URL.init(string: urlString)!
        }
    }

    var path: String {
        switch self {
        case .card_to_card:
            return "mapp_card_cardtocard"
        }
    }

    var method: Moya.Method {
        switch self {
        case .card_to_card:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .card_to_card(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        return APIHeader.shared.getHeader()
    }
}
