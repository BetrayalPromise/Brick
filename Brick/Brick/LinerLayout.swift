import Foundation
import CoreGraphics
import UIKit

/// 主轴向
public enum MainAxie {
    /// 水平排列子视图
    case horizontal
    /// 垂直排列子视图
    case vertical
}

public enum OverloadStrategy {
    /// 包裹
    case wrapItems
    /// 前切超出部分
    case cutItems
    
    case compress
}

public enum Orientation {
    /// 主轴线为水平时为从左到右 主轴线为垂直时为从上到下
    case forward
    /// 主轴线为水平时为从右到左 主轴线为垂直时为从下到上
    case reverse
}

open class LinnerLayout: BaseLayout {
    public var axie: MainAxie = .horizontal
    public var orientation: Orientation = .forward
    /// 子试图间距
    public var space: CGFloat = 0
    private var handles: [UIView] = []
    
    public var overload: OverloadStrategy = .compress
    
    public convenience init(axie: MainAxie) {
        self.init()
        self.axie = axie
    }
    
    open override func addSubview(_ view: UIView) {
        guard let label = view as? UILabel else {
            super.addSubview(view)
            self.handles.append(view);
            return
        }
        let box = PaddingLabel(label: label)
        super.addSubview(box)
        self.handles.append(box)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.handles.count <= 0 {
            self.frame = CGRect(origin: self.frame.origin, size: CGSize.zero)
            return
        }
    
        switch self.axie {
        case .horizontal: self.horizontal()
        case .vertical: self.vertical()
        }
    }
    
    func horizontal() {
        switch self.overload {
        case .wrapItems: self.hWrapper()
        case .cutItems: self.clipsToBounds = true
        case .compress: self.compress()
        }
    }
    
    func vertical() {
        var svs = self.handles
        switch self.orientation {
        case .forward: svs = self.handles
        case .reverse: svs = self.handles.reversed()
        }
        let startX: CGFloat = self.padding.left
        var startY: CGFloat = self.padding.top
        for item in svs {
            item.frame = CGRect.zero
            item.sizeToFit()
            
            let origin = CGPoint(x: startX - item.margin.left + item.margin.right + item.offset.x, y: startY - item.margin.top + item.margin.bottom - item.offset.y)
            item.frame = CGRect(origin: origin, size: item.paddingSize)
            
            if item.offset != .zero && item.margin != .zero {
                fatalError("UIView.offset和UIView.margin二者只能设置一个")
            } else if item.offset != .zero && item.padding == .zero {
                startY +=  item.height  + self.space
            } else {
                startY +=  item.height  + self.space - item.margin.top + item.margin.bottom
            }
        }
        let height: CGFloat = (svs.last?.maxY ?? 0.0) + (svs.last?.margin.bottom ?? 0.0) + self.padding.bottom
        var width: CGFloat = 0.0
        for item in svs {
            if item.maxX + item.margin.right + self.padding.right > width {
                width = item.maxX + item.margin.right + self.padding.right
            }
        }
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: width, height: height))
    }
}

extension LinnerLayout {
    func hWrapper() {
        var svs = self.handles
        switch self.orientation {
        case .forward: svs = self.handles
        case .reverse: svs = self.handles.reversed()
        }
        var startX: CGFloat = self.padding.left
        let startY: CGFloat = self.padding.top
        for item in svs {
            item.frame = CGRect.zero
            item.sizeToFit()
            
            let origin = CGPoint(x: startX - item.margin.left + item.margin.right + item.offset.x, y: startY - item.margin.top + item.margin.bottom - item.offset.y)
            item.frame = CGRect(origin: origin, size: item.paddingSize)
            
            if item.offset != .zero && item.margin != .zero {
                fatalError("UIView.offset和UIView.margin二者只能设置一个")
            } else if item.offset != .zero && item.padding == .zero {
                startX +=  item.width  + self.space
            } else {
                startX +=  item.width  + self.space - item.margin.left + item.margin.right
            }
        }
        let width: CGFloat = (svs.last?.maxX ?? 0.0) + (svs.last?.margin.right ?? 0.0) + self.padding.right
        var height: CGFloat = 0.0
        for item in svs {
            if item.maxY + self.padding.bottom > height {
                height = item.maxY + self.padding.bottom
            }
        }
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: width, height: height))
    }
    
    func compress() {
        var svs = self.handles
        switch self.orientation {
        case .forward: svs = self.handles
        case .reverse: svs = self.handles.reversed()
        }
       
        for item in svs {
            item.frame = CGRect.zero
            item.sizeToFit()
            print(item.frame)
        }
    }
}

