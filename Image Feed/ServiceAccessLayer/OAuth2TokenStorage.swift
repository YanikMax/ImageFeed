import UIKit
import WebKit
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    private let tokenKey = "BearerToken"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: tokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            }
        }
    }
}
