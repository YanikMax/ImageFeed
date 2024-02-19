import XCTest
@testable import Image_Feed


final class ProfileViewControllerTests: XCTestCase {
    
    func testProfileViewControllerUpdateAvatar() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        viewController.updateAvatar()
        
        // Then
        XCTAssertTrue(viewController.isUpdateAvatarCalled)
    }
    
    func testViewControllerViewDidLoad() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(presenter.isViewDidLoadCalled)
    }
    
    func testProfileViewControllerUpdateProfile() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.isUpdateProfileDetailsCalled = true
        
        // Then
        XCTAssertTrue(presenter.isUpdateProfileDetailsCalled)
    }
}
