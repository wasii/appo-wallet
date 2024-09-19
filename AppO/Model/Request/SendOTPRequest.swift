//
//  OTPRequest.swift
//  AppO
//
//  Created by Abul Jaleel on 19/09/2024.
//

import Foundation

struct SendOTPRequest: Codable {
    let mobileNumber: String
    let hashKey: String // = "3w0pkWn2S4N"
    let phoneCode: String
}
