import Foundation

final class FavoritesManager {

    static let shared = FavoritesManager()

    private init() {}

    private let key = "favorite_movies"

    // MARK: - Get Favorites

    func getFavorites() -> [Movie] {

        guard let data = UserDefaults.standard.data(
            forKey: key
        ) else {
            return []
        }

        do {

            return try JSONDecoder().decode(
                [Movie].self,
                from: data
            )

        } catch {

            print("Failed to decode favorites:", error)

            return []
        }
    }

    // MARK: - Save Favorites

    private func save(_ movies: [Movie]) {

        do {

            let data = try JSONEncoder().encode(
                movies
            )

            UserDefaults.standard.set(
                data,
                forKey: key
            )

        } catch {

            print("Failed to encode favorites:", error)
        }
    }

    // MARK: - Add

    func add(_ movie: Movie) {

        var current = getFavorites()

        guard !current.contains(
            where: { $0.imdbID == movie.imdbID }
        ) else {
            return
        }

        current.append(movie)

        save(current)
    }

    // MARK: - Remove

    func remove(_ movie: Movie) {

        var current = getFavorites()

        current.removeAll {
            $0.imdbID == movie.imdbID
        }

        save(current)
    }

    // MARK: - Check

    func isFavorite(_ movie: Movie) -> Bool {

        getFavorites().contains {
            $0.imdbID == movie.imdbID
        }
    }

    // MARK: - Toggle

    func toggle(_ movie: Movie) {

        if isFavorite(movie) {
            remove(movie)
        } else {
            add(movie)
        }
    }
}
