import Foundation

/// Результат запроса данных об URL изображений
struct UrlsResult: Decodable {
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
