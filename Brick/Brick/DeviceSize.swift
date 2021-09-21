import Foundation
import UIKit

public extension UIDevice {
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var frame: CGRect {
        return CGRect(x: 0, y: 0, width: Self.width, height: Self.height)
    }
    
    static var bounds: CGRect {
        return CGRect(x: 0, y: 0, width: Self.width, height: Self.height)
    }
}
