//
//  ViewController+UIFabric.swift
//  BundleImagesAndJson
//
//  Created by Naira on 30.07.2025.
//

import UIKit

enum UIComponentsFactory {
    static func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    static func makeContentStackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    static func makeMessageLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }
    
    static func makeActivityIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }
    
    static func makeImageView(for name: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityLabel = "Food image: \(name)"
        imageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        imageView.alpha = 0
        return imageView
    }
    
    static func makePlaceholder(for name: String) -> UILabel {
        let label = UILabel()
        label.text = "⚠️ Missing: \(name)"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.backgroundColor = .systemGray5
        return label
    }
}
