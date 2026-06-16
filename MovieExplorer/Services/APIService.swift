import Foundation

final class APIService {

    static let shared = APIService()

    private init() {}

    private let apiKey = Config.omdbApiKey
    private let baseURL = "https://www.omdbapi.com/"

    // MARK: - Search Movies

    func searchMovies(query: String) async throws -> [Movie] {

        let encodedQuery = query.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? ""

        guard let url = URL(
            string: "\(baseURL)?apikey=\(apiKey)&s=\(encodedQuery)"
        ) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        try validate(response: response)

        let result = try JSONDecoder().decode(MovieSearchResponse.self, from: data)

        return result.search ?? []
    }

    // MARK: - Movie Details

    func fetchMovie(imdbID: String) async throws -> MovieDetail {

        guard let url = URL(
            string: "\(baseURL)?apikey=\(apiKey)&i=\(imdbID)&plot=full"
        ) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        try validate(response: response)

        return try JSONDecoder().decode(MovieDetail.self, from: data)
    }

    // MARK: - Poster URL

    func posterURL(from poster: String?) -> URL? {

        guard
            let poster,
            poster != "N/A"
        else {
            return nil
        }

        return URL(string: poster)
    }

    // MARK: - Validation

    private func validate(response: URLResponse) throws {

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard 200...299 ~= httpResponse.statusCode else {
            throw APIError.serverError(httpResponse.statusCode)
        }
    }
}

// MARK: - Errors

enum APIError: Error {

    case invalidURL
    case invalidResponse
    case serverError(Int)
}
