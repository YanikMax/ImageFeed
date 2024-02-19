import Foundation

protocol ImagesListViewProtocol: AnyObject {
    func updatePhotos(_ photos: [Photo])
    func showAlert(title: String, message: String)
}

protocol ImagesListPresenterProtocol {
    func viewDidLoad()
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool)
}

class ImagesListPresenter: ImagesListPresenterProtocol {
    private weak var view: ImagesListViewProtocol?
    private let imagesListService: ImagesListService
    
    init(view: ImagesListViewProtocol, imagesListService: ImagesListService) {
        self.view = view
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func changeLike(photoId: String, isLike: Bool) {
        imagesListService.changeLike(photoId: photoId, isLike: isLike) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.fetchPhotosNextPage()
                case .failure(let error):
                    self?.view?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    func checkCompletedList(_ indexPath: IndexPath) {
        if imagesListService.photos.isEmpty || (indexPath.row + 1 == imagesListService.photos.count) {
            fetchPhotosNextPage()
        }
    }
}
