import Foundation

/// Результат запроса данных об изображении, отмеченном как понравившееся
struct PhotoLiked: Decodable {
    let photo: PhotoResult
}
