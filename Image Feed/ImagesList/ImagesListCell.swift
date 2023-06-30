import UIKit

struct ImagesListCellModel {
    let image: UIImage?
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    
    func configure(with model: ImagesListCellModel) {
        cellImage.image = model.image
    }
    
    func setImage(_ image: UIImage?) {
        cellImage.image = image
    }
    
    func setDate(_ date: String) {
        dateLabel.text = date
    }
    
    func setLikeButtonImage(_ image: UIImage?, for state: UIControl.State) {
        likeButton.setImage(image, for: state)
    }
}

