//
//  NetworkManager.swift
//  Boilerplate
//
//  Created by Aqeel Ahmed on 19/04/2022.
//

import Foundation
import Moya
import Combine

typealias NetworkMangerCompletion<T: Codable> = ((_ response: APIBaseResponse<T>?, _ error: String?) -> Void)

class NetworkManager<APIType: TargetType> {

    private var provider: MoyaProvider<APIType>
    private let cookieStorage = HTTPCookieStorage.shared
    private var cancellables: Set<AnyCancellable> = []

    init(with type: NetworkManagerProviderType<APIType> = .live) {
        self.provider = type.getProvider()
    }
    
    func request<T: Codable>(target: APIType) -> AnyPublisher<APIBaseResponse<T>, NetworkError> {
        return Future<APIBaseResponse<T>, NetworkError> { [weak self] promise in
            // Load stored cookies
            if let cookies = self?.cookieStorage.cookies {
                for cookie in cookies {
                    self?.provider.session.sessionConfiguration.httpCookieStorage?.setCookie(cookie)
                }
            }
            
            self?.provider.request(target) { [weak self] result in
                switch result {
                case .success(let response):
                    
                    // Store received cookies
                    if let httpResponse = response.response,
                        let headers = httpResponse.allHeaderFields as? [String: String],
                        let url = httpResponse.url {
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
                        self?.cookieStorage.setCookies(cookies, for: url, mainDocumentURL: nil)
                    }
                    
                    self?.printResponse(response)
                    
                    // Extract status code
                    if let statusCode = response.response?.statusCode {
                        print("Status Code: \(statusCode)")
                        if statusCode == 401 {
//                            SessionManager.shared.logout()
                            promise(.success(APIBaseResponse.init(success: "401", message: "Kindly re-login", data: nil)))
                            return
                        }
                    }
                    do {
                        let data = try JSONDecoder().decode(APIBaseResponse<T>.self, from: response.data)
                        promise(.success(data))
                    } catch {
                        // Print response data if decoding fails
                        if let jsonString = String(data: response.data, encoding: .utf8) {
                            print("Failed to decode response. JSON data: \(jsonString)")
                        } else {
                            print("Failed to decode response. Unable to convert data to string.")
                        }
                        promise(.failure(.decodingError))
                    }
                case .failure(let error):
                    promise(.failure(.networkError(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func systemAPIRequest<T: Codable>(target: APIType) -> AnyPublisher<SystemAPIBaseResponse<T>, NetworkError> {
        return Future<SystemAPIBaseResponse<T>, NetworkError> { [weak self] promise in
            // Load stored cookies
            if let cookies = self?.cookieStorage.cookies {
                for cookie in cookies {
                    self?.provider.session.sessionConfiguration.httpCookieStorage?.setCookie(cookie)
                }
            }
            
            self?.provider.request(target) { [weak self] result in
                switch result {
                case .success(let response):
                    
                    // Store received cookies
                    if let httpResponse = response.response,
                        let headers = httpResponse.allHeaderFields as? [String: String],
                        let url = httpResponse.url {
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
                        self?.cookieStorage.setCookies(cookies, for: url, mainDocumentURL: nil)
                    }
                    
                    self?.printResponse(response)
                    
                    // Extract status code
                    if let statusCode = response.response?.statusCode {
                        print("Status Code: \(statusCode)")
                        if statusCode == 401 {
//                            SessionManager.shared.logout()
//                            promise(.success(SystemAPIBaseResponse.init(success: "401", message: "Kindly re-login", data: nil)))
                            return
                        }
                    }
                    do {
                        let data = try JSONDecoder().decode(SystemAPIBaseResponse<T>.self, from: response.data)
                        promise(.success(data))
                    } catch {
                        if let jsonString = String(data: response.data, encoding: .utf8) {
                            print("Failed to decode response. JSON data: \(jsonString)")
                        } else {
                            print("Failed to decode response. Unable to convert data to string.")
                        }
                        promise(.failure(.decodingError))
                    }
                case .failure(let error):
                    promise(.failure(.networkError(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func printResponse(_ response: Response) {
        debugPrint("=========================================================")
        print("\(response.request?.url?.absoluteString ?? "") response:")
        do { try print(response.mapJSON(failsOnEmptyData: true))
        } catch let error {
            print("exception => \(error)")
        }
        debugPrint("=========================================================")
    }

    func cancelAllRequest() {
        DefaultAlamofireSession.shared.session.getAllTasks {sessionTasks in
            for task in sessionTasks {
                task.cancel()
            }
        }
    }
}
