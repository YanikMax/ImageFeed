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
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        // Если уже выполняется запрос на получение токена с другим кодом, отменяем его
        if let lastCode = lastCode, lastCode != code {
            task?.cancel()
        }
        
        // Если уже выполняется запрос на получение токена с тем же кодом, ничего не делаем
        if task != nil {
            return
        }
        
        // Новый запрос на получение токена
        lastCode = code
        let request = authTokenRequest(code: code)
        let task = urlSession.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let responseBody):
                let authToken = responseBody.accessToken
                // Сохраняем Bearer Token в User Defaults
                UserDefaults.standard.set(authToken, forKey: "BearerToken")
                DispatchQueue.main.async {
                    completion(.success(authToken))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        let parameters: [String: Any] = [
            "client_id": accessKey,
            "client_secret": secretKey,
            "redirect_uri": redirectURI,
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

func makeGenericError() -> Error {
    return NSError(domain: "com.unsplash.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "An unknown error occurred."])
}


// MARK: - HTTP Request

extension OAuth2Service {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let data = data, let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) {
                do {
                    let result = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(NetworkError.urlSessionError))
            }
        }
        task.resume()
        return task
    }
}

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = defaultBaseURL
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
    case unauthorized
    case invalidURL
    case missingData
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data, let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    fulfillCompletionOnMainThread(.success(result))
                } catch {
                    fulfillCompletionOnMainThread(.failure(error))
                }
            } else if let error = error {
                fulfillCompletionOnMainThread(.failure(error))
            } else {
                fulfillCompletionOnMainThread(.failure(makeGenericError()))
            }
        }
        return task
    }
}


