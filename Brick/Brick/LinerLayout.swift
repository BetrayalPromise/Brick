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
    static let none = Wrapper([])
    static let size = Wrapper(rawValue: 1 << 0)
    static let width = Wrapper(rawValue: 1 << 1)
    static let height = Wrapper(rawValue: 1 << 2)
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
    
    public var wrapper: Wrapper = .size
    
    public convenience init(axie: MainAxie) {
        self.init()
        self.axie = axie
    }
    
    deinit {
        print(#function)
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
        case .size: self.size()
        case .width: self.width()
        case .height: self.height()
        default: break
        }
    }
}

extension LinnerLayout {
    func size() {
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
    
    func width() {
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
    
    func height() {
        var svs = self.handles
        switch self.orientation {
        case .forward: svs = self.handles
        case .reverse: svs = self.handles.reversed()
        }

        
        let layoutScopeWidth: CGFloat = self.frame.width - self.padding.left - self.padding.right
        var totalSubviewsWidth: CGFloat = 0.0
        
        for item in svs {
            if item is UILabel {
                /// 解决中英文混排换行问题
                (item as? UILabel)?.lineBreakMode = .byCharWrapping
            }
            item.frame = CGRect.zero
            item.sizeToFit()
            totalSubviewsWidth += item.size(with: .margin).width + self.space
        }
        totalSubviewsWidth -= self.space
        
        if totalSubviewsWidth < layoutScopeWidth {
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
        } else {
            let grouped = svs.sorted { $0.compressible > $1.compressible }.reduce([[UIView]]()) { (result, v) -> [[UIView]] in
                var result: [[UIView]] = result
                if result.count == 0 {
                    result.append([v])
                } else {
                    if result.last?.last?.compressible == v.compressible {
                        var last = result.last
                        last?.append(v)
                        result.removeLast()
                        result.append(last ?? [UIView]())
                    } else {
                        result.append([v])
                    }
                }
                return result
            }
            
            var widths = 0.0
            var index: Int = 0
            for (i, items) in grouped.enumerated() {
                let width: CGFloat = items.totalWidth()
                widths += width
                if widths > layoutScopeWidth {
                    widths -= width
                    index = i; break
                }
            }
            if index < grouped.count - 1 {
                for i in (index + 1)...(grouped.count - 1) {
                    for item in grouped[i] {
                        item.frame = .zero
                    }
                }
            }
            
            let remainViews: [UIView] = svs.filter { $0.compressible == grouped[index].last?.compressible ?? 500 }
            let layoutViews: [UIView] = svs.filter { $0.compressible >= grouped[index].last?.compressible ?? 500 }
            let remainWidths: CGFloat = (layoutScopeWidth - widths - self.space * CGFloat(layoutViews.count - 1)) / Double(grouped[index].count)
            
            if remainWidths < 0.0 {
                print("!!!警告!!!: 布局计算异常, 布局不生效")
                return
            }
            
            switch self.axie {
            case .horizontal:
                for item in remainViews {
                    let size = item.sizeThatFits(CGSize(width: remainWidths, height: 0.0))
                    item.frame = CGRect(origin: item.frame.origin, size: CGSize(width: remainWidths, height: size.height))
                }
                
                var startX: CGFloat = self.padding.left
                let startY: CGFloat = self.padding.top
                for item in layoutViews {
                    item.frame = CGRect(origin: CGPoint(x: startX + item.margin.left, y: startY + item.margin.top), size: CGSize(width: item.frame.size.width, height: item.frame.size.height))
                    startX += self.space + item.size(with: .margin).width
                }
                let width: CGFloat = (svs.last?.frame.maxX ?? 0.0) + (svs.last?.margin.right ?? 0.0) + self.padding.right
                var height: CGFloat = 0.0
                for item in svs {
                    if item.frame.maxY + self.padding.bottom > height {
                        height = item.frame.maxY + self.padding.bottom
                    }
                }
                self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: width, height: height + self.padding.bottom))
            case .vertical:
                let startX: CGFloat = self.padding.left
                var startY: CGFloat = self.padding.top
                for item in svs {
                    if item.frame.size.width > self.frame.size.width - self.padding.left - self.padding.right - item.margin.left - item.margin.right {
                        let size = item.sizeThatFits(CGSize(width: self.frame.size.width - self.padding.left - self.padding.right - item.margin.left - item.margin.right, height: 0.0))
                        item.frame = CGRect(origin: CGPoint(x: startX + item.margin.left, y: startY + item.margin.top), size: CGSize(width: self.frame.size.width - self.padding.left - self.padding.right - item.margin.left - item.margin.right, height: size.height))
                        startY += self.space + size.height + item.margin.bottom
                    } else {
                        let size = item.sizeThatFits(CGSize(width: self.frame.size.width - self.padding.left - self.padding.right - item.margin.left - item.margin.right, height: 0.0))
                        item.frame = CGRect(origin: CGPoint(x: startX + item.margin.left, y: startY + item.margin.top), size: CGSize(width: self.frame.size.width - self.padding.left - self.padding.right - item.margin.left - item.margin.right, height: size.height))
                        startY += self.space + size.height + item.margin.bottom
                    }
                }
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
    }
}


extension Array where Element == UIView {
    func totalWidth() -> CGFloat {
        return self.reduce(0.0) { x, y in
            return x + y.size(with: .margin).width
        }
    }
}
