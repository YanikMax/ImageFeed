import Foundation

class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    
    var isViewDidLoadCalled = false
    var isDidTapLogoutCalled = false
    var isRemoveObserversCalled = false
    var isUpdateProfileCalled = false
    var isUpdateProfileDetailsCalled = false
    
    weak var view: ProfileView!
    
    func viewDidLoad() {
        isViewDidLoadCalled = true
    }
    
    func didTapLogout() {
        isDidTapLogoutCalled = true
    }
    
    func removeObservers() {
        isRemoveObserversCalled = true
    }
    
    func updateProfileDetails(profile: Profile) {
        isUpdateProfileDetailsCalled = true
    }
}
