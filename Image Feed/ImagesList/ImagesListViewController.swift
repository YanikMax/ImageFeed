import UIKit
import Foundation

class ImagesListViewController: UIViewController {
    var photos: [Photo] = []
    internal var presenter: ImagesListPresenterProtocol?
    internal let showSingleImageSegueIdentifier = "ShowSingleImage"
    internal var imagesListServiceObserver: NSObjectProtocol?
    internal let imagesListService = ImagesListService.shared
    
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
    
    internal func updateTableViewWithBatchUpdates(indexPaths: [IndexPath]) {
        tableView.performBatchUpdates({
            self.tableView.insertRows(at: indexPaths, with: .fade)
        }, completion: nil)
    }
    
    func updateTableViewData() {
        tableView.reloadData()
    }
    
    func indexPath(for cell: ImagesListCell) -> IndexPath? {
        return tableView.indexPath(for: cell)
    }
}
