import Foundation

enum UnsplashConfig {
    static let accessKey = "CrGnzEgtPBgkxTHXzgkRmFYVbe4e7pOKsxyfiUAzMHM"
    static let secretKey = "JjbQCZd3J1MarTVosM_kTtKph3jJAdAZ5RCol8l4e0k"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let authorizePathCheck = "/oauth/authorize/native"
    static let photosBaseURL = "https://api.unsplash.com/photos"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String,
         secretKey: String,
         redirectURI: String,
         accessScope: String,
         authURLString: String,
         defaultBaseURL: URL
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: UnsplashConfig.accessKey,
                                 secretKey: UnsplashConfig.secretKey,
                                 redirectURI: UnsplashConfig.redirectURI,
                                 accessScope: UnsplashConfig.accessScope,
                                 authURLString: UnsplashConfig.unsplashAuthorizeURLString,
                                 defaultBaseURL: UnsplashConfig.defaultBaseURL)
    }
}
