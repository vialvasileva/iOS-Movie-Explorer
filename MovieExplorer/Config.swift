import Foundation

enum Config {

    static var omdbApiKey: String {

        guard
            let key = Bundle.main.object(forInfoDictionaryKey: "OMDB_API_KEY") as? String,
            !key.isEmpty
        else {
            fatalError("OMDB_API_KEY not found")
        }

        return key
    }
}
