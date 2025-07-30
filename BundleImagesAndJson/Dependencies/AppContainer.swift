//
//  AppContainer.swift
//  BundleImagesAndJson
//
//  Created by Naira on 30.07.2025.
//

protocol AppContainer {
    func createMainFlow() -> ViewController
}

struct DefaultAppContainer: AppContainer {
    let configurationLoader = AppConfigurationLoader()
    func createMainFlow() -> ViewController {
        return ViewController(configurationLoader: configurationLoader)
    }
}
