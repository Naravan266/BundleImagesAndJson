//
//  AppConfigurationLoader.swift
//  BundleImagesAndJson
//
//  Created by Naira on 30.07.2025.
//

import Foundation

protocol AppConfigurationService {
    func load() -> Result<AppConfiguration,Error>
}

final class AppConfigurationLoader: AppConfigurationService {
    
    func load() -> Result<AppConfiguration, any Error> {
        guard let url = Bundle.main.url(forResource: "config", withExtension: "json") else {
            return .failure(ConfigError.fileNotFound)
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let config = try decoder.decode(AppConfiguration.self, from: data)
            print("Decoded succesfully")
            return .success(config)
        } catch {
            return .failure(error)
        }
    }
}
