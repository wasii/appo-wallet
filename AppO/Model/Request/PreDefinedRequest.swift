//
//  PreDefinedRequest.swift
//  AppO
//
//  Created by Abul Jaleel on 20/09/2024.
//

import Foundation
import UIKit

struct RequestHeaderInfo: Codable {
    let apiVersion: String = "1.1"
    let title: String = "sem_app"
    let deviceAddr: String = "192.168.0.100"
    let requestID: String = UUID().uuidString
    let orgDate: String = "20092004"
    let orgTime: String = "221505"
    let echoMessage: String = "test_message"
    let checkSum: String = UUID().uuidString
    
    enum CodingKeys: String, CodingKey {
        case apiVersion = "api_version"
        case title
        case deviceAddr = "device_addr"
        case requestID = "request_id"
        case orgDate = "org_date"
        case orgTime = "org_time"
        case echoMessage = "echo_message"
        case checkSum = "check_sum"
    }
}

// MARK: - RequestKey
struct RequestKey: Codable {
    let requestType: String
    let requestID: String = "NA"
    
    enum CodingKeys: String, CodingKey {
        case requestType = "request_type"
        case requestID = "request_id"
    }
}

// MARK: - DeviceInfo
struct DeviceInfo: Codable {
    let name: String
    let manufacturer: String
    let model: String
    let version: String
    let os: String

    // Custom initializer to populate the values
    init() {
        self.name = UIDevice.current.name
        self.model = DeviceInfo.getDeviceIdentifier()
        self.manufacturer = "Apple"
        self.version = UIDevice.current.systemVersion
        self.os = UIDevice.current.systemName
    }

    // Function to get the device model identifier
    static func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
