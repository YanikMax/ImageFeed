import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    private let tokenStorage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    
    public private(set) var avatarURL: String?
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        // происходит проверка, выполняется ли другая задача, если да, то происходит ее отмена
        if let task = task, task.state == .running {
            task.cancel()
        }
        
        // Получаем токен из хранилища
        guard let token = tokenStorage.token else {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.unauthorized))
            }
            return
        }
        
        // Создаем GET запрос с заголовком Authorization
        let urlString = "https://api.unsplash.com/users/\(username)"
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.invalidURL))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let userResult):
                if let avatarURL = userResult.profileImage.small {
                    self?.avatarURL = avatarURL
                    DispatchQueue.main.async {
                        completion(.success(avatarURL))
                        NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.missingData))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task?.resume()
    }
}

extension ProfileImageService {
    static let didChangeNotification = Notification.Name("ProfileImageServiceDidChangeNotification")
}

