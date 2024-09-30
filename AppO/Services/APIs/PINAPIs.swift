//
//  PINAPIs.swift
//  AppO
//
//  Created by Abul Jaleel on 27/09/2024.
//

import Foundation
import Moya

enum PINAPIs {
    case set_card_pin(parameters: Parameters)
    case update_card_pin(parameters: Parameters)
    case verifyPIN(parameters: Parameters)
    case mini_statement(parameters: Parameters)
}

extension PINAPIs: TargetType {

    var baseURL: URL {
        switch self {
        case .set_card_pin, .update_card_pin, .mini_statement:
            let urlString: String = AppEnvironment[.systemURL]
            return URL.init(string: urlString)!
        case .verifyPIN:
            let urlString: String = AppEnvironment[.serverOne]
            return URL.init(string: urlString)!
        }
        
    }

    var path: String {
        switch self {
        case .set_card_pin:
            return "sem_mapp_set_pin"
        case .update_card_pin:
            return "sem_mapp_pin_change"
        case .verifyPIN:
            return "device/verify-pin"
        case .mini_statement:
            return "mapp_card_mini_stmt"
        }
    }

    var method: Moya.Method {
        switch self {
        case .set_card_pin, .update_card_pin, .verifyPIN, .mini_statement:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .set_card_pin(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .update_card_pin(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .verifyPIN(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .mini_statement(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        return APIHeader.shared.getHeader()
    }
}
