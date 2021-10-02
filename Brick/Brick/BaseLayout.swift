import Foundation
import UIKit
import CoreGraphics

open class BaseLayout: UIView {
    /// 布局外边距影响的是试图的位置不影响试图的大小
    /// 向视图内为正值向试图外为负值 会影响其余子试图位置
    public var margin: UIEdgeInsets = .zero
    /// 布局内边距,向内为正值向外为负值
    public var padding: UIEdgeInsets = .zero
    
    public var debug: Bool = true
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.debug {
            guard let context = UIGraphicsGetCurrentContext() else { return }
            context.clear(rect)
            //创建一个矩形，它的所有边都内缩3
            let  drawingRect = self.bounds.insetBy(dx: 0.1, dy: 0.1)
            //创建并设置路径
            let path = CGMutablePath()
            path.addRect(drawingRect)
            //添加路径到图形上下文
            context.addPath(path)
            //设置笔触颜色
            context.setStrokeColor(UIColor.orange.cgColor)
            context.setFillColor(self.backgroundColor?.cgColor ?? UIColor.white.cgColor)
            context.setLineWidth(2 / UIScreen.main.scale)
            let  lengths: [CGFloat] = [4, 4]
            //设置虚线样式
            context.setLineDash(phase: 0, lengths: lengths)
            context.drawPath(using: .fillStroke)
            //绘制路径
            context.strokePath()
            context.restoreGState()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        print(#function)
    }
}

/// 为了解决UILabel的padding问题
//public class LayoutLabel: UILabel {
//    /// 只支持autoSize一种
//    public var wrapper: Wrapper = .autoSize {
//        didSet { self.sizeToFit() }
//    }
//
//    public override var text: String? {
//        didSet { self.sizeToFit() }
//    }
//
//    public override var font: UIFont! {
//        didSet { self.sizeToFit() }
//    }
//
//    public override var attributedText: NSAttributedString? {
//        didSet { self.sizeToFit() }
//    }
//
//    public override var frame: CGRect {
//        set { super.frame = CGRect(origin: newValue.origin, size: self.sizeThatFits(CGSize(width: 0.0, height: 0.0))) }
//        get { return super.frame }
//    }
//
//    public override func drawText(in rect: CGRect) {
//        super.drawText(in: rect.inset(by: self.padding))
//    }
//
//    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
//        let insets = self.padding
//        var rect = super.textRect(forBounds: bounds.inset(by: insets), limitedToNumberOfLines: numberOfLines)
//        rect.origin.x    += insets.left
//        rect.origin.y    += insets.top
//        return rect
//    }
//
//    public override func sizeThatFits(_ size: CGSize) -> CGSize {
//        let size =  super.sizeThatFits(size)
//        return CGSize(width: size.width + self.padding.left + self.padding.right, height: size.height + self.padding.top + self.padding.bottom)
//    }
//}

extension UIColor {
    static func random() -> UIColor {
        let red = CGFloat(arc4random() % 256) / 255.0
        let green = CGFloat(arc4random() % 256) / 255.0
        let blue = CGFloat(arc4random() % 256) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
