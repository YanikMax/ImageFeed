import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let splashScreenLogoImageName = "splash_screen_logo"
    
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService()
    
    private let splashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash_screen_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addSplashImageView()
        applyConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = OAuth2TokenStorage().token {
            switchToTabBarController()
        } else {
            // Показать экран авторизации
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func addSplashImageView() {
        view.addSubview(splashImageView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashImageView.widthAnchor.constraint(equalToConstant: 200),
            splashImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        // конструкция для проверки условия. Есть ли индикатор активности или нет.
        // Если он видимый, то выходим из функции и ничего не делаем
        guard !UIBlockingProgressHUD.isProgressHUDVisible else { return }
        // вызываем функцию show из класса блокируя пользовательский ввод
        UIBlockingProgressHUD.show()
        
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert(title: "Что-то пошло не так(", message: "Не удалось войти в систему")
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                // Получаем URL изображения профиля, используя полученное имя пользователя (username)
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in
                    // не дожидаемся завершения, чтобы скрыть индикатор активности и переходим к таб бару
                    UIBlockingProgressHUD.dismiss()
                    self.switchToTabBarController()
                }
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert(title: "Что-то пошло не так(", message: "Не удалось загрузить профиль")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default) { _ in
            // Обработка нажатия кнопки "Ок", если требуется
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
