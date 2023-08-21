import Foundation

//fileprivate let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    var authHelper: AuthHelperProtocol
        
        init(authHelper: AuthHelperProtocol) {
            self.authHelper = authHelper
        }
    
    func viewDidLoad() {
//        guard var urlComponents = URLComponents(string: UnsplashAuthorizeURLString) else { return }
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: AccessKey),
//            URLQueryItem(name: "redirect_uri", value: RedirectURI),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: AccessScope)
//        ]
//        guard let url = urlComponents.url else { return }
        //let request = URLRequest(url: url)
        let request = authHelper.authRequest()
        view?.load(request: request)
        didUpdateProgressValue(0)
        
        //webView.load(request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
