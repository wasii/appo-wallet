//
//  DataEncryptionKeyResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 25/09/2024.
//

import Foundation

struct DataEncryptionKeyResponse: Codable {
    let dek: String
    let dekKcv: String
    
    enum CodingKeys: String, CodingKey {
        case dek
        case dekKcv = "dek_kcv"
    }
}
