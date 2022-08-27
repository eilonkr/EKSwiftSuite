
import UIKit

public extension UIImage {
    func isEqual(to image: UIImage) -> Bool {
        return pngData() == image.pngData()
    }
}

