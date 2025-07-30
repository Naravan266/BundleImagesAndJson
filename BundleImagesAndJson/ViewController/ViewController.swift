//
//  ViewController.swift
//  BundleImagesAndJson
//
//  Created by Naira on 21.07.2025.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: Constants for content
    enum Constants {
        static let imageHeight: CGFloat = 180
        static let contentPadding: CGFloat = 20
        static let fadeDuration: TimeInterval = 0.3
    }
    
    // MARK: Properties
    private let configurationLoader: AppConfigurationLoader
    private var configurationLoaded = false
    
    init(configurationLoader: AppConfigurationLoader) {
        self.configurationLoader = configurationLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Elements
    private var scrollView = UIComponentsFactory.makeScrollView()
    private var contentStack = UIComponentsFactory.makeContentStackView()
    private var messageLabel = UIComponentsFactory.makeMessageLabel()
    private var activityIndicator = UIComponentsFactory.makeActivityIndicator()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !configurationLoaded {
            loadConfiguration()
            configurationLoaded = true
        }
    }
    
    // MARK: Configuration
    private func loadConfiguration() {
        activityIndicator.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {
            let result = self.configurationLoader.load()
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                switch result {
                case .success(let config):
                    self.applyConfiguration(config)
                case .failure(let error):
                    self.showErrorAlert(error)
                }
            }
        }
    }
    
    private func applyConfiguration(_ config: AppConfiguration) {
        clearContentStack()
        
        title = config.title
        messageLabel.text = config.welcomeMessage
        contentStack.addArrangedSubview(messageLabel)
        
        let imagesToDisplay = Array(config.images.prefix(config.maxDisplayedImages))
        addImagesToStack(names: imagesToDisplay)
    }
    
    // MARK: Set View and Constraints
    private func setView() {
        view.backgroundColor = .systemBackground
        [scrollView, activityIndicator].forEach { view.addSubview($0) }
        scrollView.addSubview(contentStack)
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.contentPadding),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.contentPadding),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Constants.contentPadding),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Constants.contentPadding),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * Constants.contentPadding),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: Content Management
    private func clearContentStack() {
        contentStack.arrangedSubviews.forEach {
            contentStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    private func addImagesToStack(names: [String]) {
        for name in names {
            let imageView = UIComponentsFactory.makeImageView(for: name)
            contentStack.addArrangedSubview(imageView)
            configureImageView(imageView, with: name)
        }
    }
    
    private func configureImageView(_ imageView: UIImageView, with name: String) {
        if let image = UIImage(named: name) {
            imageView.image = image
        } else {
            let placeholder = UIComponentsFactory.makePlaceholder(for: name)
            imageView.addSubview(placeholder)
            placeholder.frame = imageView.bounds
        }
        
        UIView.animate(withDuration: Constants.fadeDuration) {
            imageView.alpha = 1
        }
    }
    
    // MARK: Error Handling
    private func showErrorAlert(_ error: Error) {
        guard isViewLoaded && view.window != nil else { return }
        
        let alert = UIAlertController(
            title: "Configuration Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
            self.loadConfiguration()
        })
        
        present(alert, animated: true)
    }
}
