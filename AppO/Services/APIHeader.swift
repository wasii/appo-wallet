//
//  APIHeader.swift
//  TestCasesDemo
//
//  Created by Aqeel Ahmed on 11/09/2023.
//

import Foundation
import UIKit

class APIHeader {

    static let shared = APIHeader()

    private init() { }

    func getHeader() -> [String: String] {
        return [
            "Accept": "application/json",
            "x-api-lang": "en/US",
            "x-api-channel": "web",
            "x-api-version": "1.0.0",
            
        ]
    }
}
