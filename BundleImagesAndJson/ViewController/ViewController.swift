//
//  ViewController.swift
//  BundleImagesAndJson
//
//  Created by Naira on 21.07.2025.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        loadConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppActivation),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Set View and Constraints
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        // Loading indicator
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content StackView
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: Configuration
    private func loadConfiguration() {
        activityIndicator.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let config = self.loadConfigurationFromFile() else {
                DispatchQueue.main.async {
                    self.showErrorAlert(message: "Не удалось загрузить конфигурацию")
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.applyConfiguration(config)
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func loadConfigurationFromFile() -> AppConfiguration? {
        guard let url = Bundle.main.url(forResource: "config", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(AppConfiguration.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            return nil
        }
    }
    
    private func applyConfiguration(_ config: AppConfiguration) {
        clearContentStack()
        
        title = config.title
        messageLabel.text = config.welcomeMessage
        contentStackView.addArrangedSubview(messageLabel)
        
        loadImages(maxCount: config.maxDisplayedImages)
    }
    
    // MARK: Content Handling
    private func clearContentStack() {
        contentStackView.arrangedSubviews.forEach {
            contentStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    private func loadImages(maxCount: Int) {
        let imageNames = ["Salmon", "Shrimps", "Steak", "Steak2", "Steak3"]
        
        for (index, name) in imageNames.enumerated() {
            guard index < maxCount else { break }
            
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.accessibilityLabel = "Food image \(index + 1)"
            
            container.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: container.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 180),
                imageView.widthAnchor.constraint(lessThanOrEqualTo: container.widthAnchor)
            ])
            
            contentStackView.addArrangedSubview(container)
            
            // Async image load
            loadImageAsync(named: name, for: imageView)
        }
    }
    
    private func loadImageAsync(named: String, for imageView: UIImageView) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let image = UIImage(named: named) {
                DispatchQueue.main.async {
                    imageView.image = image
                    
                    // Appearance animation
                    UIView.animate(withDuration: 0.3) {
                        imageView.alpha = 1
                    }
                }
            }
        }
    }
    
    // MARK: Error Handling
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        alert.addAction(UIAlertAction(title: "Try again", style: .default) { _ in
            self.loadConfiguration()
        })
        
        present(alert, animated: true)
    }
    
    // MARK: Notifications
    @objc private func handleAppActivation() {
        // Reload configuration when return to App
        loadConfiguration()
    }
}
