import Foundation
import WebKit

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Swift.Result<String, Error>) -> Void
    ) {
        let request = authTokenRequest(code: code)
        let task = urlSession.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.urlSessionError))
                }
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            if 200..<300 ~= statusCode {
                if let data = data {
                    do {
                        let responseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        let authToken = responseBody.accessToken
                        
                        // Сохраняем Bearer Token в User Defaults
                        UserDefaults.standard.set(authToken, forKey: "BearerToken")
                        
                        DispatchQueue.main.async {
                            completion(.success(authToken))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.urlSessionError))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            }
        }
        
        task.resume()
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        let parameters: [String: Any] = [
            "client_id": "CrGnzEgtPBgkxTHXzgkRmFYVbe4e7pOKsxyfiUAzMHM",
            "client_secret": "JjbQCZd3J1MarTVosM_kTtKph3jJAdAZ5RCol8l4e0k",
            "redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
            "code": code,
            "grant_type": "authorization_code"
        ]
        
        let url = URL(string: "https://unsplash.com/oauth/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        return request
    }
}

// MARK: - HTTP Request

extension OAuth2Service {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
}

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}

// MARK: - Network Connection

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletion(.success(data))
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
}
