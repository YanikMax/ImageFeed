import UIKit
import Foundation

class ProfileViewControllerSpy: ProfileView {
    
    var isUpdateAvatarCalled = false
    var isUpdateProfileDetailsCalled = false
    
    var presenter: ProfileViewPresenterProtocol!
    
    func updateAvatar() {
        isUpdateAvatarCalled = true
    }
    
    func updateProfileDetails(_ profile: Profile) {
    }
}
