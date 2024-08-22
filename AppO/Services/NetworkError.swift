//
//  NetworkError.swift
//  Boilerplate
//
//  Created by Aqeel Ahmed on 19/04/2022.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case decodingError
    case networkError(Error)
    case sessionFailed(urlError: URLError)
    case requestCreationFailed
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return NSLocalizedString(
                "The response is not valid.",
                comment: "Invalid Response"
            )
        case .requestCreationFailed:
            return NSLocalizedString(
                "Cannot create request",
                comment: "Request creation failed"
            )
        case .sessionFailed(let urlError):
            return "Session failed \(urlError.localizedDescription)"
        default:
            return nil
        }
    }
}
