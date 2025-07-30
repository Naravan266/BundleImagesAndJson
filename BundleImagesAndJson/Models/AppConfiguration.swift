//
//  AppConfiguration.swift
//  BundleImagesAndJson
//
//  Created by Naira on 21.07.2025.
//

struct AppConfiguration: Decodable {
    let maxDisplayedImages: Int
    let welcomeMessage: String
    let title: String
    let images: [String]
}
