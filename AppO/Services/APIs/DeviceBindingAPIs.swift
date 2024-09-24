//
//  OTP.swift
//  AppO
//
//  Created by Abul Jaleel on 19/09/2024.
//

import Foundation
import Moya

enum DeviceBindingAPIs {
    case bindDevice(parameters: Parameters)
    case rebindDevice(parameters: Parameters)
}

extension DeviceBindingAPIs: TargetType {

    var baseURL: URL {
        let urlString: String = AppEnvironment[.serverOne]
        return URL.init(string: urlString)!
    }

    var path: String {
        switch self {
        case .rebindDevice:
            return "device/reBind"
        case .bindDevice:
            return "device/bind"
        }
    }

    var method: Moya.Method {
        switch self {
        case .rebindDevice, .bindDevice:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .rebindDevice(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .bindDevice(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        return APIHeader.shared.getHeader()
    }
}
