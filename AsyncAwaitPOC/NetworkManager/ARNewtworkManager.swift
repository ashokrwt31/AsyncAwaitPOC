//
//  ARDataManager.swift
//  ARConcurrency
//
//  Created by Ashok Rawat on 09/09/22.
//

import Foundation

public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
    
    var method: String { rawValue.uppercased() }
}

enum ARNetworkError: Error {
    case invalidUrl
    case invalidData
}

struct API {
    static let baseURL = "https://saurav.tech/NewsAPI/"
    static let sourceService = "sources.json"
}

enum ARHTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}


struct ARNetworkManager {
    private var httpMethod: String
    private var param: [String: Any]?
    init(httpMethod: ARHTTPMethod = .GET, _ param: [String: Any] = [String: Any]()) {
        self.httpMethod = httpMethod.rawValue
        self.param = param
    }
    
    private func createRequest(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.networkServiceType = .default
        request.cachePolicy = .reloadRevalidatingCacheData
        request.timeoutInterval = 100
        request.httpShouldHandleCookies = true
        request.httpShouldUsePipelining = false
        request.allowsCellularAccess = true
        if let param = param, param.keys.count > 0 {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: param, options: [])
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        return request
    }
}

// MARK: - Using Closure

extension ARNetworkManager {
    func executeRequest<T: Decodable>(url: URL, completion: ((T?, Error? ) -> Void)?) {
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: self.createRequest(url), completionHandler: { (data, response, error) in
            guard let data = data else {
                completion?(nil, error)
                return
            }
            if let decodedResponse = try? jsonDecoder.decode(T.self, from: data) {
                    completion?(decodedResponse, nil)
            } else {
                completion?(nil, ARNetworkError.invalidData)
            }
        })
        dataTask.resume()
    }
}

// MARK: - Using Async Await

extension ARNetworkManager {
    
    func executeRequestWithAsyncAwait<T: Codable>(url: URL, _ modelType: T.Type) async throws -> Result<T, Error>? {
        do {
            let request = self.createRequest(url)
            let (data, _) = try await URLSession.shared.data(for: request)
            let result = try jsonDecoder.decode(T.self, from: data)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}


let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()

