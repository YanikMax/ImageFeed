import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile {
    let username: String
    let name: String?
    let loginName: String
    let bio: String?
    
    init(username: String, name: String?, loginName: String, bio: String?) {
        self.username = username
        self.name = name ?? ""
        self.loginName = loginName
        self.bio = bio ?? ""
    }
}

final class ProfileService {
    // Создание общего экземпляра ProfileService как синглтон
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    var profile: Profile?
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        // происходит проверка, выполняется ли другая задача, если да, то происходит ее отмена
        if let task = task, task.state == .running {
            task.cancel()
        }
        
        // создание GET запроса с заголовком Authorization
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            DispatchQueue.main.sync {
                completion(.failure(NetworkError.invalidURL))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profileResult):
                let profile = self?.mapProfileResultToProfile(profileResult)
                self?.profile = profile
                DispatchQueue.main.async {
                    if let profile = profile {
                        completion(.success(profile))
                    } else {
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
    
    private func mapProfileResultToProfile(_ profileResult: ProfileResult) -> Profile {
        let name = "\(profileResult.firstName) \(profileResult.lastName ?? "")"
        let loginName = "@\(profileResult.username)"
        let bio = profileResult.bio ?? ""
        
        return Profile(username: profileResult.username,
                       name: name,
                       loginName: loginName,
                       bio: bio)
    }
}

