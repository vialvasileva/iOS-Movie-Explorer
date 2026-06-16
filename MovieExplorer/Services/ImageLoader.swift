import UIKit

final class ImageLoader {

    static let shared = ImageLoader()

    private init() {}

    private let cache = NSCache<NSString, UIImage>()

    private var runningRequests: [UUID: URLSessionDataTask] = [:]

    // MARK: - Load Image

    @discardableResult
    func loadImage(
        from url: URL,
        completion: @escaping (UIImage?) -> Void
    ) -> UUID? {

        let cacheKey = NSString(
            string: url.absoluteString
        )

        // Cache

        if let cachedImage = cache.object(
            forKey: cacheKey
        ) {

            DispatchQueue.main.async {
                completion(cachedImage)
            }

            return nil
        }

        let uuid = UUID()

        let task = URLSession.shared.dataTask(
            with: url
        ) { [weak self] data, _, error in

            defer {
                self?.runningRequests.removeValue(
                    forKey: uuid
                )
            }

            guard
                error == nil,
                let data = data,
                let image = UIImage(data: data)
            else {

                DispatchQueue.main.async {
                    completion(nil)
                }

                return
            }

            self?.cache.setObject(
                image,
                forKey: cacheKey
            )

            DispatchQueue.main.async {
                completion(image)
            }
        }

        runningRequests[uuid] = task

        task.resume()

        return uuid
    }

    // MARK: - Cancel

    func cancelLoad(_ uuid: UUID) {

        runningRequests[uuid]?.cancel()

        runningRequests.removeValue(
            forKey: uuid
        )
    }

    // MARK: - Clear Cache

    func clearCache() {

        cache.removeAllObjects()
    }
}
