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
    
    /// 布局内边距,向内为正值向外为负值
    /// 若视图为LayoutLabel及其之类的话该属性设置必须先于(UILabel.text,UILabel.attributedTex,UILabel.font)t进行设置,否则设置不生效
    public var padding: UIEdgeInsets {
        set {
            if (self is UILabel) {
                print("暂未实现UILabel.padding")
            }
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

public extension UIView {    
    enum BoxType {
        /// 计算padding范围大小
        case padding
        /// 计算bounds范围大小,计算包含padding
        case bounds
        /// 计算margin范围大小,计算包含padding和margin
        case margin
    }
    
    func getSize(with: BoxType) -> CGSize {
        switch with {
        case .padding: return CGSize(width: self.frame.width - self.padding.left - self.padding.right, height: self.frame.height - self.padding.top - self.padding.bottom)
        case .bounds: return CGSize(width: self.frame.width + self.padding.left + self.padding.right, height: self.frame.height + self.padding.top + self.padding.bottom)
        case .margin: return CGSize(width: self.frame.width + self.margin.left + self.margin.right + self.padding.left + self.padding.right, height: self.frame.height + self.margin.top + self.margin.bottom + self.padding.top + self.padding.bottom)
        }
    }
    
    func setSize(with: BoxType, size: CGSize) {
        switch with {
        case .padding: self.frame.size = CGSize(width: size.width + self.padding.left + self.padding.right, height: size.height + self.padding.top + self.padding.bottom)
        case .bounds: self.frame.size = size
        case .margin: self.frame.size = CGSize(width: size.width - self.margin.left - self.margin.right, height: size.height - self.margin.top - self.margin.bottom)
        }
    }
    
    func getOrigin(with: BoxType) -> CGPoint {
        switch with {
        case .padding: return CGPoint(x: self.frame.origin.x + self.padding.left, y: self.frame.origin.y + self.padding.top)
        case .bounds: return self.frame.origin
        case .margin: return CGPoint(x: self.frame.origin.x - self.margin.left, y: self.frame.origin.y - self.margin.top)
        }
    }
    
    func setOrigin(with: BoxType, origin: CGPoint) {
        switch with {
        case .padding, .bounds, .margin: self.frame.origin = origin
        }
    }
    
    func getFrame(with: BoxType) -> CGRect {
        switch with {
        case .padding: return CGRect(origin: self.getOrigin(with: .padding), size: self.getSize(with: .padding))
        case .bounds: return CGRect(origin: self.getOrigin(with: .bounds), size: self.getSize(with: .bounds))
        case .margin: return CGRect(origin: self.getOrigin(with: .margin), size: self.getSize(with: .margin))
        }
    }
    
    func setFrame(with: BoxType, rect: CGRect) {
        switch with {
        case .padding: self.frame = CGRect(x: rect.origin.x - self.padding.left, y: rect.origin.y - self.padding.top, width: rect.width + self.padding.left + self.padding.right, height: rect.height + self.padding.top + self.padding.bottom)
        case .bounds: self.frame = rect
        case .margin: self.frame = CGRect(x: rect.origin.x + self.margin.left, y: rect.origin.y + rect.origin.y , width: self.frame.width - self.margin.left - self.margin.right, height: self.frame.height - self.margin.top - self.margin.bottom)
        }
    }
}


extension CGPoint {
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
}
