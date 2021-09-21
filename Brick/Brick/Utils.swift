import Foundation
import UIKit

extension UIView {
    func controller<T>(type: T.Type) -> T? where T: UIViewController {
        var n = self.next
        while n != nil {
            if n is T {
                return n as? T
            }
            n = n?.next
        }
        return nil
    }
}

public extension UILabel {
    convenience init(title: String, frame: CGRect = .zero) {
        self.init(frame: frame)
        self.text = title
        self.sizeToFit()
    }
}


extension UIView {
    private struct AssociatedKey {
        static var flintiness = "UIViewAssociatedObjectKeyFlintiness"
        static var padding = "UIViewAssociatedObjectKeyPadding"
        static var margin = "UIViewAssociatedObjectKeyMargin"
        static var offset = "UIViewAssociatedObjectKeyOffset"
    }
    
    /// 视图坚硬程度类比自动布局抗压抗拉属性
    public var flintiness: CGFloat {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.flintiness, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } get {
            return objc_getAssociatedObject(self, &AssociatedKey.flintiness) as? CGFloat ?? 500
        }
    }
    
    /// 布局内边距
    /// 向内为正值向外为负值
    public var padding: UIEdgeInsets {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.padding, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } get {
            return objc_getAssociatedObject(self, &AssociatedKey.padding) as? UIEdgeInsets ?? .zero
        }
    }
    /// 布局外边距影响的是试图的位置不影响试图的大小
    /// 向视图内为正值向试图外为负值 会影响其余子试图位置
    public var margin: UIEdgeInsets {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.margin, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } get {
            return objc_getAssociatedObject(self, &AssociatedKey.margin) as? UIEdgeInsets ?? .zero
        }
    }
    
    /// 布局外边距 向内为正值向外为负值 不会影响父试图和其余子试图位置
    /// offset.x为正值向右偏移offset.y为正值向左偏移
    /// offset.y为正值向偏移offset.y为正值向下偏移
    public var offset: CGPoint {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.offset, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } get {
            return objc_getAssociatedObject(self, &AssociatedKey.offset) as? CGPoint ?? .zero
        }
    }
}

extension UIView {
    var minX: CGFloat {
        return self.frame.minX
    }
    
    var maxX: CGFloat {
        return self.frame.minX + self.frame.width
    }
    
    var minY: CGFloat {
        return self.frame.minY
    }
    
    var maxY: CGFloat {
        return self.frame.minY + self.frame.height
    }
    
    var width: CGFloat {
        return self.frame.width
    }
    
    var height: CGFloat {
        return self.frame.height
    }
}


public extension UIView {
    var marginOrigin: CGPoint {
        return CGPoint(x: self.frame.origin.x - self.margin.left, y: self.frame.origin.y - self.margin.top)
    }
    
    var paddingSize: CGSize {
        guard let label = self as? UILabel else {
            return CGSize(width: self.width + self.padding.left + self.padding.right, height: self.height + self.padding.top + self.padding.bottom)
        }
        label.textAlignment = .center
        return CGSize(width: self.width + self.padding.left + self.padding.right, height: self.height + self.padding.top + self.padding.bottom)
    }
}
