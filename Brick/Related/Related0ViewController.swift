import UIKit

class Related0ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .random()
        
        let label = UILabel(frame: .zero)

        self.view
    }
}

extension UIView: Layoutable {
    struct Associated {
        static var layoutManager = "UIViewLayoutableLayoutManager"
        static var subItems = "UIViewLayoutableLayoutSubItems"
        
    }
    
    public var layoutManager: LayoutManager {
        set {
            objc_setAssociatedObject(self, &Associated.layoutManager, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } get {
            return objc_getAssociatedObject(self, &Associated.layoutManager) as? LayoutManager ?? LayoutManager(self)
        }
    }
    
    public var superItem: Layoutable? {
        return self.superview
    }
    
    public var subItems: [Layoutable] {
        set {
            objc_setAssociatedObject(self, &Associated.subItems, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } get {
            return objc_getAssociatedObject(self, &Associated.subItems) as? [Layoutable] ?? []
        }
    }
    
    public var layoutRect: CGRect {
        get {
            return .zero
        }
        set {
            
        }
    }
    
    public func layoutSubItems() {
        
    }
    
    public func updateConstraint() {
        
    }
    
    public var itemIntrinsicContentSize: CGSize {
        return CGSize(width: InvalidIntrinsicMetric, height: InvalidIntrinsicMetric)
    }
    
    public func contentSizeFor(maxWidth: Value) -> CGSize {
        return InvaidIntrinsicSize
    }
    

}
