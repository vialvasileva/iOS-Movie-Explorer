import UIKit

extension UIImageView {

    private static var taskKey: UInt8 = 0

    private var currentTaskID: UUID? {
        get {
            objc_getAssociatedObject(self, &Self.taskKey) as? UUID
        }
        set {
            objc_setAssociatedObject(self, &Self.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func load(url: URL?, placeholder: UIImage? = nil) {

        if let currentTaskID {
            ImageLoader.shared.cancelLoad(currentTaskID)
        }

        self.image = placeholder

        guard let url else {
            currentTaskID = nil
            return
        }

        let taskID = ImageLoader.shared.loadImage(from: url) { [weak self] image in
            self?.image = image
        }

        currentTaskID = taskID
    }
}
