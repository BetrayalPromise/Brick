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
        static var adaptive = "UIViewAssociatedObjectKeyAdaptive"
    }
    
    /// 自动适应
    public var adaptive: Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.adaptive, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } get {
            return objc_getAssociatedObject(self, &AssociatedKey.adaptive) as? Bool ?? false
        }
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
            if (self is UILabel) && !(self is LayoutLabel) {
                print("Label设置padding需要使用PaddingLabel子类")
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

extension UIView {
    var minX: CGFloat {
        return self.frame.minX
    }
    
    var maxX: CGFloat {
        set {
            self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.width + newValue - self.frame.maxX, height: self.frame.size.height))
        } get {
            return self.frame.minX + self.frame.width
        }
    }
    
    var minY: CGFloat {
        return self.frame.minY
    }
    
    var maxY: CGFloat {
        return self.frame.minY + self.frame.height
    }
    
    /// 计算padding
    var width: CGFloat {
        return self.frame.width + self.padding.left + self.padding.right
    }
    
    /// 计算padding
    var height: CGFloat {
        return self.frame.height + self.padding.top + self.padding.bottom
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

/// 为了解决UILabel的padding问题
public class LayoutLabel: UILabel {
    /// 只支持autoSize一种
    public var wrapper: Wrapper = .autoSize {
        didSet { self.sizeToFit() }
    }
    
    public override var text: String? {
        didSet { self.sizeToFit() }
    }
    
    public override var font: UIFont! {
        didSet { self.sizeToFit() }
    }
    
    public override var attributedText: NSAttributedString? {
        didSet { self.sizeToFit() }
    }
    
    public override var frame: CGRect {
        set { super.frame = CGRect(origin: newValue.origin, size: self.sizeThatFits(CGSize(width: 0.0, height: 0.0))) }
        get { return super.frame }
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.padding))
    }

    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = self.padding
        var rect = super.textRect(forBounds: bounds.inset(by: insets), limitedToNumberOfLines: numberOfLines)
        rect.origin.x    += insets.left
        rect.origin.y    += insets.top
        return rect
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size =  super.sizeThatFits(size)
        return CGSize(width: size.width + self.padding.left + self.padding.right, height: size.height + self.padding.top + self.padding.bottom)
    }
}
