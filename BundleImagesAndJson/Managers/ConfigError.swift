//
//  ConfigError.swift
//  BundleImagesAndJson
//
//  Created by Naira on 30.07.2025.
//

import Foundation

// Decided to create enum with errors for the AppConfigurationLoader. Considering that I made a class easier
// to test and interchangeable with other implementation, decided also to create a custom enum ConfigError,
// so that it is also easier to add other error cases if necessary.
// Made it also confirm to Equatable for unit testing purposes.

enum ConfigError: Error, Equatable {
    case fileNotFound
    
    var description: String? {
        switch self {
        case .fileNotFound:
            return "Configuration file not found. Please ensure that json file exists in the app bundle."
        }
    }
}
