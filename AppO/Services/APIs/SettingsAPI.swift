//
//  SettingsAPI.swift
//  AppO
//
//  Created by Abul Jaleel on 02/10/2024.
//

import Foundation
import Moya

enum SettingsAPI {
    case get_card_list(parameters: Parameters)
    case create_new_card(parameters: Parameters)
}

extension SettingsAPI: TargetType {

    var baseURL: URL {
        switch self {
        case .get_card_list, .create_new_card:
            let urlString: String = AppEnvironment[.systemURL]
            return URL.init(string: urlString)!
        }
    }

    var path: String {
        switch self {
        case .get_card_list:
            return "mobile_app_card_product_type"
        case .create_new_card:
            return "sem_mapp_add_on_card"
        }
    }

    var method: Moya.Method {
        switch self {
        case .get_card_list, .create_new_card:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .get_card_list(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .create_new_card(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        return APIHeader.shared.getHeader()
    }
}
