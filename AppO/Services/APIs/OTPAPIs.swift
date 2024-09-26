//
//  OTP.swift
//  AppO
//
//  Created by Abul Jaleel on 19/09/2024.
//

import Foundation
import Moya

enum OTPAPIs {
    case phoneNumberVerification(parameters: Parameters)
    case sendOTP(parameters: Parameters)
    case validateOTP(number:String, otp:String)
    case savePIN(parameters: Parameters)
}

extension OTPAPIs: TargetType {

    var baseURL: URL {
        switch self {
        case .phoneNumberVerification:
            let urlString: String = AppEnvironment[.systemURL]
            return URL.init(string: urlString)!
        default:
            let urlString: String = AppEnvironment[.serverOne]
            return URL.init(string: urlString)!
        }
        
    }

    var path: String {
        switch self {
        case .phoneNumberVerification:
            return "mobile_app_cust_validation"
        case .sendOTP:
            return "twilio/sendOTP"
        case .validateOTP(let number, let otp):
            return "twilio/validateOTP/\(number)/\(otp)"
        case .savePIN:
            return "device/save-pin"
        }
    }

    var method: Moya.Method {
        switch self {
        case .phoneNumberVerification, .sendOTP, .savePIN:
            return .post
        case .validateOTP(_, _):
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .phoneNumberVerification(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .sendOTP(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .validateOTP(_, _):
            return .requestPlain
        case .savePIN(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        return APIHeader.shared.getHeader()
    }
}
