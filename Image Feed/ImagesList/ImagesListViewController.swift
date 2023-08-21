import UIKit

final class ImagesListViewController: UIViewController {
    var photos: [Photo] = []
    internal var presenter: ImagesListPresenterProtocol?
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imagesListServiceObserver: NSObjectProtocol?
    private let imagesListService = ImagesListService.shared
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        setupTableView()
        imagesListService.fetchPhotosNextPage()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        addNotifications()
    }
    
    deinit {
        removeNotifications()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showSingleImageSegueIdentifier,
              let viewController = segue.destination as? SingleImageViewController,
              let indexPath = sender as? IndexPath else {
            super.prepare(for: segue, sender: sender)
            return
        }
        
        let photo = photos[indexPath.row].largeImageURL
        let largeImageURL = URL(string: photo)
        viewController.image = largeImageURL
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        
        let photo = photos[indexPath.row]
        imageListCell.setupCell(from: photo)
        return imageListCell
    }
}

//MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = photos[safe: indexPath.row] else {
            // Если фотографии по индексу не существует, вернуть высоту по умолчанию
            return UITableView.automaticDimension
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

// MARK: TableViewAnimated

extension ImagesListViewController {
    // Метод, который будет вызываться при получении обновления
    @objc func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        // Проверьте, изменилось ли количество элементов в массиве photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                // Создайте indexPaths для добавления новых элементов
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .fade)
            } completion: { _ in
            }
        }
    }
}

// MARK: Notification

extension ImagesListViewController{
    private func addNotifications() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [ weak self ] _ in
                self?.updateTableViewAnimated()
            }
    }
    
    private func removeNotifications() {
        if let observer = imagesListServiceObserver {
            NotificationCenter.default.removeObserver(observer)
            imagesListServiceObserver = nil
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension ImagesListViewController: ImagesListViewProtocol {
    func updatePhotos(_ photos: [Photo]) {
        self.photos = photos
        tableView.reloadData()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: "Что-то пошло не так")
                print(error.localizedDescription)
            }
            
            UIBlockingProgressHUD.dismiss()
        }
    }
}

// MARK: - DateFormatter

extension DateFormatter {
    static var customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}
