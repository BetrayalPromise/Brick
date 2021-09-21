import Foundation

/// 布局尺寸处理
public enum LayoutScope {
    case safeArea
    case bounds
}

open class ScopeLayout: BaseLayout {
    public var scope: LayoutScope = .safeArea {
        didSet {
            if #available(iOS 11, *) {
                guard let v = self.superview else { return }
                v.addObserver(self, forKeyPath: "safeAreaInsets", options: [.new], context: nil)
            } else {
                print("不支持之前的UIViewController.topLayoutGuide和UIViewController.bottomLayoutGuide")
            }
        }
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let sv = self.superview else { return }
        switch self.scope {
        case .bounds: self.frame = sv.bounds
        case .safeArea:
            if #available(iOS 11.0, *) {
                self.frame = CGRect(x: sv.safeAreaInsets.left + self.margin.left, y: sv.safeAreaInsets.top + self.margin.top, width: sv.bounds.width - sv.safeAreaInsets.left - sv.safeAreaInsets.right - self.margin.top - self.margin.bottom, height: sv.bounds.height - sv.safeAreaInsets.top - sv.safeAreaInsets.bottom - self.margin.top - self.margin.bottom)
            } else {
                print("不支持之前的UIViewController.topLayoutGuide和UIViewController.bottomLayoutGuide")
            }
        }
    }
}
