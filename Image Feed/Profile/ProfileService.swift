import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName
        case lastName
        case bio
    }
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
    
}

final class ProfileService {
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        // происходит проверка, выполняется ли другая задача, если да, то происходит ее отмена
        if let task = task, task.state == .running {
            task.cancel()
        }
        
        // создание GET запроса с заголовком Authorization
        let url = URL(string: "https://unsplash.com/users")!
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
        let name = "\(profileResult.firstName) \(profileResult.lastName)"
        let loginName = "@\(profileResult.username)"
        return Profile(username: profileResult.username,
                       name: name,
                       loginName: loginName,
                       bio: profileResult.bio)
    }
}

