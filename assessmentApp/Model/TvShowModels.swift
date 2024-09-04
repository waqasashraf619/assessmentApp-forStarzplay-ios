//
//  TvShowModels.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/2/24.
//

import Foundation

struct GeneralResponse: Codable {
    let statusCode: Int?
    let statusMessage: String?
    let success: Bool?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case success
    }
    
}

// MARK: - ShowDetailResponse
struct ShowDetailResponse: Codable {
    let adult: Bool?
    let backdropPath: String?
    let createdBy: [CreatedByModel]?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let genres: [GenreModel]?
    let homepage: String?
    let id: Int?
    let inProduction: Bool?
    let languages: [String]?
    let lastAirDate: String?
    let lastEpisodeToAir: LastEpisodeToAirModel?
    let name: String?
    let networks: [ShowNetworkModel]?
    let numberOfEpisodes, numberOfSeasons: Int?
    let originCountry: [String]?
    let originalLanguage, originalName, overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ShowNetworkModel]?
    let productionCountries: [ProductionCountryModel]?
    var seasons: [SeasonModel]?
    let spokenLanguages: [SpokenLanguageModel]?
    let status, tagline, type: String?
    let voteAverage: Double?
    let voteCount: Int?
    var showStatInfoString: String {
        let firstAirDate = DateManager.convertStringToStringDate(inputDate: firstAirDate ?? "", outputDateFormat: "yyyy")
        let adultString = adult == true ? "  |  R" : ""
        let seasonsString = (numberOfSeasons ?? 0) >= 1 ? "  |  \(numberOfSeasons ?? 1) Seasons" : ""
        return "\(firstAirDate)\(seasonsString)\(adultString)"
    }

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres, homepage, id
        case inProduction = "in_production"
        case languages
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case name, networks
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case seasons
        case spokenLanguages = "spoken_languages"
        case status, tagline, type
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - CreatedBy
struct CreatedByModel: Codable {
    let id: Int?
    let creditID, name, originalName: String?
    let gender: Int?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case creditID = "credit_id"
        case name
        case originalName = "original_name"
        case gender
        case profilePath = "profile_path"
    }
}

// MARK: - Genre
struct GenreModel: Codable {
    let id: Int?
    let name: String?
}

// MARK: - LastEpisodeToAir
struct LastEpisodeToAirModel: Codable {
    let id: Int?
    let name, overview: String?
    let voteCount: Int?
    let voteAverage: Double?
    let airDate: String?
    let episodeNumber: Int?
    let episodeType, productionCode: String?
    let runtime, seasonNumber, showID: Int?
    let stillPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case episodeType = "episode_type"
        case productionCode = "production_code"
        case runtime
        case seasonNumber = "season_number"
        case showID = "show_id"
        case stillPath = "still_path"
    }
}

// MARK: - Network
struct ShowNetworkModel: Codable {
    let id: Int?
    let logoPath, name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountry
struct ProductionCountryModel: Codable {
    let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

// MARK: - SeasonModel
struct SeasonModel: Codable {
    let airDate: String?
    let episodes: [EpisodeModel]?
    let episodeCount, id: Int?
    let name, overview, posterPath: String?
    let seasonNumber: Int?
    let voteAverage: Double?
    var isSelected: Bool?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id, name, overview, episodes
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
        case voteAverage = "vote_average"
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguageModel: Codable {
    let englishName, iso639_1, name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

// MARK: - EpisodeModel
struct EpisodeModel: Codable {
    let airDate: String?
    let episodeNumber: Int?
    let episodeType: String?
    let id: Int?
    let name, overview, productionCode: String?
    let runtime, seasonNumber, showID: Int?
    let stillPath: String?
    let voteAverage: Double?
    let voteCount: Int?
    var titleDisplay: String {
        var title: String = ""
        if let episodeNumber, let name {
            title = "E\(episodeNumber) - \(name)"
        }
        return title
    }

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case episodeType = "episode_type"
        case id, name, overview
        case productionCode = "production_code"
        case runtime
        case seasonNumber = "season_number"
        case showID = "show_id"
        case stillPath = "still_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum EpisodeType: String, Codable {
    case finale = "finale"
    case standard = "standard"
}
