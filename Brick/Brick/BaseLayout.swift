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
