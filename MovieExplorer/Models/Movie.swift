import Foundation

struct MovieSearchResponse: Codable {

    let search: [Movie]?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}

struct Movie: Codable {

    let imdbID: String
    let title: String
    let year: String
    let poster: String

    enum CodingKeys: String, CodingKey {
        case imdbID
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
    }
}

extension Movie {

    var releaseYear: Int {

        let digits = year.prefix(4)

        return Int(digits) ?? 0
    }
}
