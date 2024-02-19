import UIKit
@testable import Image_Feed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewProtocol?
    var viewDidLoadCalled = false
    var didFetchPhotosCalled: Bool = false
    var didSetLikeCallSuccess: Bool = false
    var imagesListService: Image_Feed.ImagesListService
    
    init(imagesListService: ImagesListService){
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage() {
        didFetchPhotosCalled = true
    }
    
    func changeLike(photoId: String, isLike: Bool) {
        didSetLikeCallSuccess = true
    }
}
