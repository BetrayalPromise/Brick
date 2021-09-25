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

/// 包裹类型
public struct Wrapper: OptionSet {
    public let rawValue: UInt8

    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    static let none = Wrapper(rawValue: 0)
    static let autoSize = Wrapper(rawValue: 1 << 0)
    static let autoWidth = Wrapper(rawValue: 1 << 1)
    static let autoHeight = Wrapper(rawValue: 1 << 2)
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
    
    public var wrapper: Wrapper = .autoSize
    
    public convenience init(axie: MainAxie) {
        self.init()
        self.axie = axie
    }
    
    open override func addSubview(_ view: UIView) {
        super.addSubview(view)
        self.handles.append(view)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.handles.count <= 0 {
            self.frame = CGRect(origin: self.frame.origin, size: CGSize.zero)
            return
        }
    
        switch self.wrapper {
        case .autoSize: self.autoSize()
        case .autoWidth: self.autoWidth()
        case .autoHeight: self.autoHeight()
        default: break
        }
    }
}

extension LinnerLayout {
    func autoSize() {
        var svs = self.handles
        switch self.orientation {
        case .forward: svs = self.handles
        case .reverse: svs = self.handles.reversed()
        }
        var startX: CGFloat = self.padding.left
        var startY: CGFloat = self.padding.top
        for item in svs {
            item.frame = CGRect.zero
            item.sizeToFit()
            
            let origin = CGPoint(x: startX - item.margin.left + item.margin.right + item.offset.x, y: startY - item.margin.top + item.margin.bottom - item.offset.y)
            item.frame = CGRect(origin: origin, size: item.size(with: .bounds))
            
            switch self.axie {
            case .horizontal:
                if item.offset != .zero && item.margin != .zero {
                    fatalError("UIView.offset和UIView.margin二者只能设置一个")
                } else if item.offset != .zero && item.padding == .zero {
                    startX +=  item.frame.width  + self.space
                } else {
                    startX +=  item.frame.width  + self.space - item.margin.left + item.margin.right
                }
            case .vertical:
                if item.offset != .zero && item.margin != .zero {
                    fatalError("UIView.offset和UIView.margin二者只能设置一个")
                } else if item.offset != .zero && item.padding == .zero {
                    startY += item.frame.height + self.space
                } else {
                    startY += item.frame.height + self.space - item.margin.top + item.margin.bottom
                }
            }
        }
        
        switch self.axie {
        case .horizontal:
            let width: CGFloat = (svs.last?.frame.maxX ?? 0.0) + (svs.last?.margin.right ?? 0.0) + self.padding.right
            var height: CGFloat = 0.0
            for item in svs {
                if item.frame.maxY + self.padding.bottom > height {
                    height = item.frame.maxY + self.padding.bottom
                }
            }
            self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: width, height: height))
        case .vertical:
            let height: CGFloat = (svs.last?.frame.maxY ?? 0.0) + (svs.last?.margin.bottom ?? 0.0) + self.padding.bottom
            var width: CGFloat = 0.0
            for item in svs {
                if item.frame.maxX + item.margin.right + self.padding.right > width {
                    width = item.frame.maxX + item.margin.right + self.padding.right
                }
            }
            self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: width, height: height))
        }
    }
    
    func autoWidth() {
        var svs = self.handles
        switch self.orientation {
        case .forward: svs = self.handles
        case .reverse: svs = self.handles.reversed()
        }
        var startX: CGFloat = self.padding.left
        var startY: CGFloat = self.padding.top
        for item in svs {
            item.frame = CGRect.zero
            item.sizeToFit()
            
            let origin = CGPoint(x: startX - item.margin.left + item.margin.right + item.offset.x, y: startY - item.margin.top + item.margin.bottom - item.offset.y)
            item.frame = CGRect(origin: origin, size: item.size(with: .bounds))
            
            switch self.axie {
            case .horizontal:
                if item.offset != .zero && item.margin != .zero {
                    fatalError("UIView.offset和UIView.margin二者只能设置一个")
                } else if item.offset != .zero && item.padding == .zero {
                    startX +=  item.frame.width  + self.space
                } else {
                    startX +=  item.frame.width + self.space - item.margin.left + item.margin.right
                }
            case .vertical:
                if item.offset != .zero && item.margin != .zero {
                    fatalError("UIView.offset和UIView.margin二者只能设置一个")
                } else if item.offset != .zero && item.padding == .zero {
                    startY += item.frame.height + self.space
                } else {
                    startY += item.frame.height + self.space - item.margin.top + item.margin.bottom
                }
            }
        }
        
        switch self.axie {
        case .horizontal:
            let width: CGFloat = (svs.last?.frame.maxX ?? 0.0) + (svs.last?.margin.right ?? 0.0) + self.padding.right
            var height: CGFloat = 0.0
            for item in svs {
                if item.frame.maxY + self.padding.bottom > height {
                    height = item.frame.maxY + self.padding.bottom
                }
            }
            self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: width, height: self.frame.height))
        case .vertical:
            var width: CGFloat = 0.0
            for item in svs {
                if item.frame.maxX + item.margin.right + self.padding.right > width {
                    width = item.frame.maxX + item.margin.right + self.padding.right
                }
            }
            self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: width, height: self.frame.height))
        }
    }
    
    func autoHeight() {
        var svs = self.handles
        switch self.orientation {
        case .forward: svs = self.handles
        case .reverse: svs = self.handles.reversed()
        }
        var startX: CGFloat = self.padding.left
        var startY: CGFloat = self.padding.top
        
        for item in svs {
            if item is UILabel {
                /// 解决中英文混排换行问题
                (item as? UILabel)?.lineBreakMode = .byCharWrapping
            }
            item.frame = CGRect.zero
            item.sizeToFit()
            if item.adaptive == false && item.size(with: .margin).width > self.frame.width - self.padding.left - self.padding.right {
                fatalError("布局计算错误")
            }
            if item.adaptive == true {
                
            }
        }
    }
}

