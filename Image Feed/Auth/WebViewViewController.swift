import UIKit
import WebKit

//fileprivate let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
        webView.accessibilityIdentifier = "UnsplashWebView"
        //updateProgress()
        
        //        guard var urlComponents = URLComponents(string: unsplashAuthorizeURLString) else { return }
        //        urlComponents.queryItems = [
        //            URLQueryItem(name: "client_id", value: accessKey),
        //            URLQueryItem(name: "redirect_uri", value: redirectURI),
        //            URLQueryItem(name: "response_type", value: "code"),
        //            URLQueryItem(name: "scope", value: accessScope)
        //        ]
        //        guard let url = urlComponents.url else { return }
        //        let request = URLRequest(url: url)
        //        webView.load(request)
        
        //        estimatedProgressObservation = webView.observe(
        //            \.estimatedProgress,
        //             options: [.new],
        //             changeHandler: { [ weak self] wevView, _ in
        //                 self?.updateProgress() })
    }
    
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        //updateProgress()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    //    private func updateProgress() {
    //        let newProgress = Float(webView.estimatedProgress)
    //        progressView.setProgress(newProgress, animated: true)
    //        progressView.isHidden = abs(newProgress - 1.0) <= 0.0001
    //    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    func setProgressValue(_ newValue: Float) {
        _ = Float(webView.estimatedProgress)
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        _ = Float(webView.estimatedProgress)
        progressView.isHidden = isHidden
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let code = code(from: navigationAction) {
                delegate?.webViewViewController(self, didAuthenticateWithCode: code)
                decisionHandler(.cancel)
                // Закрытие WebView, если авторизация прошла успешно
                dismiss(animated: true, completion: nil)
            } else {
                decisionHandler(.allow)
            }
        }
    
    //    private func code(from navigationAction: WKNavigationAction) -> String? {
    //        if
    //            let url = navigationAction.request.url,
    //            let urlComponents = URLComponents(string: url.absoluteString),
    //            urlComponents.path == authorizePathCheck,
    //            let items = urlComponents.queryItems,
    //            let codeItem = items.first(where: { $0.name == "code" })
    //        {
    //            return codeItem.value
    //        } else {
    //            return nil
    //        }
    //    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
    
}

extension WebViewViewController {
    static func clean() {
        // Очищаем все куки из хранилища.
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища.
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища.
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

