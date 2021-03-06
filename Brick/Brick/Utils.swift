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
        static var compressible = "UIViewAssociatedObjectKeyCompressible"
        static var stretchable = "UIViewAssociatedObjectKeyStretchable"
        static var offset = "UIViewAssociatedObjectKeyOffset"
        static var effect = "UIViewAssociatedObjectKeyEffect"
    }
    
    /// 视图坚硬程度类比自动布局抗压抗拉属性
    /// 压缩优先级 数值越大越难以压缩 数值越小越容易压缩
    public var compressible: CGFloat {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.compressible, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } get {
            return objc_getAssociatedObject(self, &AssociatedKey.compressible) as? CGFloat ?? 500
        }
    }
    
    /// 视图坚硬程度类比自动布局抗压拉伸属性
    /// 压缩优先级 数值越大越难以拉伸 数值越小越容易拉伸
    public var stretchable: CGFloat {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.stretchable, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } get {
            return objc_getAssociatedObject(self, &AssociatedKey.stretchable) as? CGFloat ?? 500
        }
    }
    
    /// 布局外边距 向内为正值向外为负值 不会影响父试图和其余子试图位置
    /// offset.x为正值向右偏移offset.y为正值向左偏移
    /// offset.y为正值向偏移offset.y为正值向下偏移
    internal var offset: CGPoint {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.offset, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } get {
            return objc_getAssociatedObject(self, &AssociatedKey.offset) as? CGPoint ?? .zero
        }
    }
    
    internal var effect: Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.effect, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } get {
            return objc_getAssociatedObject(self, &AssociatedKey.effect) as? Bool ?? false
        }
    }
    
    /// 位置偏移
    /// - Parameters:
    ///   - value: 偏移值
    ///   - effect: 是否影响其他子视图的位置,不会影响父级视图的位置和大小
    public func offset(value: CGPoint, effect: Bool = false) {
        self.offset = value
        self.effect = effect
    }
}

public extension BaseLayout {
    enum BoxType {
        /// 计算padding范围大小
        case padding
        /// 计算bounds范围大小,计算包含padding
        case bounds
        /// 计算margin范围大小,计算包含padding和margin
        case margin
    }
    
    func size(with: BoxType) -> CGSize {
        switch with {
        case .padding: return CGSize(width: self.frame.width - self.padding.left - self.padding.right, height: self.frame.height - self.padding.top - self.padding.bottom)
        case .bounds: return CGSize(width: self.frame.width + self.padding.left + self.padding.right, height: self.frame.height + self.padding.top + self.padding.bottom)
        case .margin: return CGSize(width: self.frame.width + self.margin.left + self.margin.right + self.padding.left + self.padding.right, height: self.frame.height + self.margin.top + self.margin.bottom + self.padding.top + self.padding.bottom)
        }
    }
    
    func origin(with: BoxType) -> CGPoint {
        switch with {
        case .padding: return CGPoint(x: self.frame.origin.x + self.padding.left, y: self.frame.origin.y + self.padding.top)
        case .bounds: return self.frame.origin
        case .margin: return CGPoint(x: self.frame.origin.x - self.margin.left, y: self.frame.origin.y - self.margin.top)
        }
    }
    
    func frame(with: BoxType) -> CGRect {
        switch with {
        case .padding: return CGRect(origin: self.origin(with: .padding), size: self.size(with: .padding))
        case .bounds: return CGRect(origin: self.origin(with: .bounds), size: self.size(with: .bounds))
        case .margin: return CGRect(origin: self.origin(with: .margin), size: self.size(with: .margin))
        }
    }
}

extension Array where Element == UIView {
    func totalWidth() -> CGFloat {
        return self.reduce(0.0) { x, y in
            return x + y.frame.size.width
        }
    }
    
    func totalHeight() -> CGFloat {
        return self.reduce(0.0) { x, y in
            return x + y.frame.size.height
        }
    }
    
    func minWidth() -> CGFloat {
        return self.reduce(0.0) { x, y in
            if x == 0.0 { return y.frame.width }
            return  x < y.frame.width ? y.frame.width : x
        }
    }
    
    func maxWidth() -> CGFloat {
        return self.reduce(0.0) { x, y in
            return x > y.frame.width ? x : y.frame.width
        }
    }
    
    func minHeight() -> CGFloat {
        return self.reduce(0.0) { x, y in
            if x == 0.0 { return y.frame.height }
            return  x < y.frame.height ? y.frame.height : x
        }
    }
    
    func maxHeight() -> CGFloat {
        return self.reduce(0.0) { x, y in
            return x > y.frame.height ? x : y.frame.height
        }
    }
    
    func maxY() -> CGFloat {
        return self.reduce(0.0) { x, y in
            if x == 0.0 { return x + y.frame.maxY }
            return x > y.frame.maxY ? x : y.frame.maxY
        }
    }
    
    func minY() -> CGFloat {
        return self.reduce(0.0) { x, y in
            if x == 0.0 { return x + y.frame.minY }
            return x < y.frame.minY ? x : y.frame.minY
        }
    }
    
    func maxX() -> CGFloat {
        return self.reduce(0.0) { x, y in
            if x == 0.0 { return x + y.frame.maxX }
            return x > y.frame.maxX ? x : y.frame.maxX
        }
    }
    
    func minX() -> CGFloat {
        return self.reduce(0.0) { x, y in
            if x == 0.0 { return x + y.frame.minX }
            return x < y.frame.minX ? x : y.frame.minX
        }
    }
}
