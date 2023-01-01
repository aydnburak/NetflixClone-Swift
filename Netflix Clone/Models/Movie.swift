//
//  Movie.swift
//  Netflix Clone
//
//  Created by Burak on 26.12.2022.
//

import Foundation

struct MovieResponse: Codable{
    let results: [Movie]
}

// MARK: - Movie
struct Movie: Codable {
    let adult: Bool?
    let backdropPath: String?
    let id: Int
    let title, originalLanguage, originalTitle, overview: String?
    let posterPath, mediaType: String?
    let genreIDS: [Int]?
    let popularity: Double?
    let releaseDate: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
