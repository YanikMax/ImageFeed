import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    private var avatarImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var descriptionLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAvatarImageView()
        setupNameLabel()
        setupLogoutButton()
        setupLoginNameLabel()
        setupDescriptionLabel()
    }
    
    private func setupAvatarImageView() {
        avatarImageView = UIImageView()
        avatarImageView?.image = UIImage(named: "avatar")
        avatarImageView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView!)
        
        NSLayoutConstraint.activate([
            avatarImageView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            avatarImageView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView!.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView!.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setupNameLabel() {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView!.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: avatarImageView!.bottomAnchor, constant: 8).isActive = true
        nameLabel.textColor = .white
        self.nameLabel = nameLabel
    }
    
    private func setupLogoutButton() {
        let logoutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        logoutButton.tintColor = .red
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView!.centerYAnchor).isActive = true
    }
    
    private func setupLoginNameLabel() {
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = .gray
        loginNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel!.leadingAnchor).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel!.bottomAnchor, constant: 8).isActive = true
        self.loginNameLabel = loginNameLabel
    }
    
    private func setupDescriptionLabel() {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel!.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel!.bottomAnchor, constant: 8).isActive = true
        self.descriptionLabel = descriptionLabel
    }
    
    @objc
    private func didTapButton() {
        nameLabel?.removeFromSuperview()
        nameLabel = nil
    }
}
