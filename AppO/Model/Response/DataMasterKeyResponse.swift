//
//  DataMasterKeyResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 25/09/2024.
//

import Foundation

struct DataMasterKeyResponse: Codable {
    let dmk: String
    let dmkKcv: String
    
    enum CodingKeys: String, CodingKey {
        case dmk
        case dmkKcv = "dmk_kcv"
    }
}
