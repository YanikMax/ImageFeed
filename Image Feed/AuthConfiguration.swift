import Foundation

//let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
//let defaultBaseURL = URL(string: "https://api.unsplash.com")!
//let authorizePathCheck = "/oauth/authorize/native"
//
//struct AuthConfiguration {
//    let accessKey = "CrGnzEgtPBgkxTHXzgkRmFYVbe4e7pOKsxyfiUAzMHM"
//    let secretKey = "JjbQCZd3J1MarTVosM_kTtKph3jJAdAZ5RCol8l4e0k"
//    let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
//    let accessScope = "public+read_user+write_likes"
//    let photosBaseURL = "https://api.unsplash.com/photos"
//    let baseURL = "https://api.unsplash.com"
//}

let AccessKey = "CrGnzEgtPBgkxTHXzgkRmFYVbe4e7pOKsxyfiUAzMHM"
let SecretKey = "JjbQCZd3J1MarTVosM_kTtKph3jJAdAZ5RCol8l4e0k"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
let authorizePathCheck = "/oauth/authorize/native"
let photosBaseURL = "https://api.unsplash.com/photos"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 authURLString: UnsplashAuthorizeURLString,
                                 defaultBaseURL: DefaultBaseURL)
    }
}
