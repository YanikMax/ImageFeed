import XCTest
@testable import Image_Feed

final class ImagesListTests: XCTestCase {
    
    func testImagesViewControllerCallsViewDidLoad() {
        // Given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let imageListService = ImagesListService()
        let presenter = ImagesListPresenterSpy(imagesListService: imageListService)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testLike() {
        // Given
        let photos: [Photo] = []
        let view = ImageListViewControllerSpy(photos: photos)
        let presenter = ImagesListPresenterSpy(imagesListService: ImagesListService.shared)
        view.presenter = presenter
        presenter.view = view
        
        // When
        view.changeLike()
        
        // Then
        XCTAssertTrue(presenter.didSetLikeCallSuccess)
    }
    
    func testLoadPhotoToTable() {
        // Given
        let tableView = UITableView()
        let tableCell = UITableViewCell()
        let indexPath: IndexPath = IndexPath(row: 2, section: 2)
        let photos: [Photo] = []
        let view = ImageListViewControllerSpy(photos: photos)
        let presenter = ImagesListPresenterSpy(imagesListService: ImagesListService.shared)
        view.presenter = presenter
        presenter.view = view
        
        // When
        view.tableView(tableView, willDisplay: tableCell, forRowAt: indexPath)
        
        // Then
        XCTAssertTrue(presenter.didFetchPhotosCalled)
    }
}
