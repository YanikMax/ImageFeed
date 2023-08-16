import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    weak var delegate: ImagesListCellDelegate?
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    } ()
    
    func setupCell(from photo: Photo) {
        
        let url = URL(string: photo.smallImageURL)
        cellImage.kf.indicatorType = .activity
        
        let placeholderImage = UIImage(named: "placeholderImage")
        cellImage.kf.setImage(with: url, placeholder: placeholderImage) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let image):
                self.cellImage.contentMode = .scaleAspectFill
                self.cellImage.image = image.image
            case .failure(let error):
                print("Ошибка загрузки картинки: \(error)")
                self.cellImage.image = UIImage(named: "placeholderImage")
            }
        }
        dateLabel.text = dateFormatter.string(from: photo.createdAt ?? Date())
        setIsLiked(isLiked: photo.isLiked)
    }
    
    func setIsLiked(isLiked:Bool) {
        let likeImage = isLiked ? UIImage(named:"like_button_on") : UIImage(named:"like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }
}

