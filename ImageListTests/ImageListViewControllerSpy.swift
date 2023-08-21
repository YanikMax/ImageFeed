import UIKit
@testable import Image_Feed

final class ImageListViewControllerSpy: ImagesListViewProtocol {
    var presenter: ImagesListPresenterProtocol?
    var photos: [Image_Feed.Photo]
    
    init(photos: [Photo]) {
        self.photos = photos
    }
    
    func updatePhotos(_ photos: [Photo]) {
        self.photos = photos
    }
    
    func showAlert(title: String, message: String) {
        print("Alert: \(title) - \(message)")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.fetchPhotosNextPage()
    }
    
    func changeLike() {
        presenter?.changeLike(photoId: "some", isLike: true)
    }
    
    func updateTableViewAnimated() {
    }
}
