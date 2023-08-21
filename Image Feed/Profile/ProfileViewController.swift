import UIKit
import Kingfisher

//final class ProfileViewController: UIViewController {
//    private var profileImageServiceObserver: NSObjectProtocol?
//
//    private let avatarImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "avatar")
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//    private var nameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Екатерина Новикова"
//        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
//        label.textColor = .white
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let logoutButton: UIButton = {
//        let button = UIButton.systemButton(
//            with: UIImage(systemName: "ipad.and.arrow.forward")!,
//            target: self,
//            action: #selector(didTapButton)
//        )
//        button.tintColor = .red
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    private let loginNameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "@ekaterina_nov"
//        label.textColor = .gray
//        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Hello, world!"
//        label.textColor = .white
//        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        addSubViews()
//        applyConstraints()
//        fetchProfileAndUpdateUI()
//
//        profileImageServiceObserver = NotificationCenter.default
//            .addObserver(
//                forName: ProfileImageService.didChangeNotification,
//                object: nil,
//                queue: .main
//            ) { [weak self] _ in
//                guard let self = self else { return }
//                self.updateAvatar()
//            }
//        updateAvatar()
//        avatarImageView.layer.cornerRadius = 35
//        avatarImageView.clipsToBounds = true
//    }
//
//    private func updateAvatar() {
//        guard
//            let profileImageURL = ProfileImageService.shared.avatarURL,
//            let url = URL(string: profileImageURL)
//        else { return }
//
//        let processor = RoundCornerImageProcessor(cornerRadius: avatarImageView.frame.width / 2)
//        avatarImageView.kf.indicatorType = .activity
//
//        // Загрузка аватарки с помощью Kingfisher
//        avatarImageView.kf.setImage(
//            with: url,
//            placeholder: UIImage(named: "avatar"),
//            options: [
//                .processor(processor),
//                .cacheOriginalImage
//            ],
//            completionHandler: { result in
//                switch result {
//                case .success(let value):
//                    print("Аватарка успешно загружена")
//                    // Можно получить доступ к загруженному изображению через `value.image`.
//                case .failure(let error):
//                    print("Ошибка загрузки аватарки: \(error.localizedDescription)")
//                }
//            }
//        )
//    }
//
//    private func checkAndFetchProfile() {
//        if let profile = ProfileService.shared.profile {
//            // Профиль уже загружен, отображаем его
//            updateProfileDetails(profile: profile)
//        } else {
//            // Профиль не загружен, выполняем загрузку
//            fetchProfileAndUpdateUI()
//        }
//    }
//
//    private func fetchProfileAndUpdateUI() {
//        guard let token = OAuth2TokenStorage().token else {
//            return
//        }
//
//        ProfileService.shared.fetchProfile(token) { [weak self] result in
//            switch result {
//            case .success(let profile):
//                // Сохранение профиля в общем экземпляре
//                ProfileService.shared.profile = profile
//
//                // Обновление пользовательскего интерфейса с использованием сохраненного профиля
//                self?.updateProfileDetails(profile: profile)
//            case .failure(let error):
//                print("Ошибка получения профиля: \(error)")
//            }
//        }
//    }
//
//    private func updateProfileDetails(profile: Profile) {
//        nameLabel.text = profile.name
//        loginNameLabel.text = profile.loginName
//        descriptionLabel.text = profile.bio
//    }
//
//    private func updateUI(with profile: Profile) {
//        nameLabel.text = profile.name
//        loginNameLabel.text = profile.loginName
//        descriptionLabel.text = profile.bio
//    }
//
//    private func addSubViews() {
//        view.addSubview(avatarImageView)
//        view.addSubview(nameLabel)
//        view.addSubview(logoutButton)
//        view.addSubview(loginNameLabel)
//        view.addSubview(descriptionLabel)
//    }
//
//    private func applyConstraints() {
//        NSLayoutConstraint.activate([
//            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
//            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
//            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
//
//            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
//            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
//            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//
//            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
//            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
//
//            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
//            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
//            loginNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//
//            descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
//            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
//            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
//        ])
//    }
//
//    @objc private func didTapButton() {
//        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
//
//        let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
//            OAuth2TokenStorage.shared.clean()
//            WebViewViewController.clean()
//            CacheManager.clean()
//
//            guard let window = UIApplication.shared.windows.first else {
//                assertionFailure("invalid configuration")
//                return
//            }
//            window.rootViewController = SplashViewController()
//            window.makeKeyAndVisible()
//        }
//
//        let noAction = UIAlertAction(title: "Нет", style: .default) { _ in
//            alert.dismiss(animated: true)
//        }
//        alert.addAction(yesAction)
//        alert.addAction(noAction)
//        present(alert, animated: true)
//    }
//
//    deinit {
//        if let observer = profileImageServiceObserver {
//            NotificationCenter.default.removeObserver(observer)
//        }
//    }
//}


protocol ProfileView: AnyObject {
    func updateProfileDetails(_ profile: Profile)
    func updateAvatar()
}

protocol ProfileViewPresenterProtocol {
    func viewDidLoad()
    func didTapLogout()
    func removeObservers()
}

class ProfileViewController: UIViewController, ProfileView {
    var presenter: ProfileViewPresenterProtocol!
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - UI Elements
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loginNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkAndFetchProfile()
        //presenter.viewDidLoad()
        setupProfileImageServiceObserver()
        addSubViews()
        applyConstraints()
        fetchProfileAndUpdateUI()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    // MARK: - ProfileView Methods
    
    func updateProfileDetails(_ profile: Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        let processor = RoundCornerImageProcessor(cornerRadius: avatarImageView.frame.width / 2)
        avatarImageView.kf.indicatorType = .activity
        
        // Загрузка аватарки с помощью Kingfisher
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "avatar"),
            options: [
                .processor(processor),
                .cacheOriginalImage
            ],
            completionHandler: { result in
                switch result {
                case .success(let value):
                    print("Аватарка успешно загружена")
                    // Можно получить доступ к загруженному изображению через `value.image`.
                case .failure(let error):
                    print("Ошибка загрузки аватарки: \(error.localizedDescription)")
                }
            }
        )
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        addSubViews()
        applyConstraints()
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.clipsToBounds = true
    }
    
    private func setupProfileImageServiceObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
    
    private func checkAndFetchProfile() {
        if let profile = ProfileService.shared.profile {
            // Профиль уже загружен, отображаем его
            updateProfileDetails(profile: profile)
        } else {
            // Профиль не загружен, выполняем загрузку
            fetchProfileAndUpdateUI()
        }
    }
    
    private func fetchProfileAndUpdateUI() {
        guard let token = OAuth2TokenStorage().token else {
            return
        }
        
        ProfileService.shared.fetchProfile(token) { [weak self] result in
            switch result {
            case .success(let profile):
                // Сохранение профиля в общем экземпляре
                ProfileService.shared.profile = profile
                
                // Обновление пользовательскего интерфейса с использованием сохраненного профиля
                self?.updateProfileDetails(profile: profile)
            case .failure(let error):
                print("Ошибка получения профиля: \(error)")
            }
        }
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func updateUI(with profile: Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func applyConstraints() {
        // Настройка констрейнтов для UI элементов
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func addSubViews() {
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(logoutButton)
        view.addSubview(loginNameLabel)
        view.addSubview(descriptionLabel)
    }
    
    @objc internal func didTapButton() {
        // Обработка нажатия на кнопку выхода
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
            OAuth2TokenStorage.shared.clean()
            WebViewViewController.clean()
            CacheManager.clean()
            
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("invalid configuration")
                return
            }
            window.rootViewController = SplashViewController()
            window.makeKeyAndVisible()
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
