//
//  AppConstants.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/2/24.
//

import Foundation

enum PlistName: String {
    case appValues = "AppValues"
}

enum EndPoint: String {
    case tvShowDetailApi = "/tv"
}

enum BaseUrl: String {
    case dataBaseUrl = "https://api.themoviedb.org/3"
    case imageBaseUrl = "https://image.tmdb.org/t/p/w500"
}

enum VideoUrlContent: String {
    case sampleVideo = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"
}
