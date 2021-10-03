import UIKit

// used as a placeholder node for view
open class LayoutNode<T: UIView>: ViewNode {
    
    public typealias ViewGenerator = ()->(T)
    public typealias SizeGenerator = () -> CGSize
    public typealias Action = () -> ()
    
    public init(viewGenerator: @escaping ViewGenerator) {
        self.viewGenerator = viewGenerator
        super.init()
    }
    
    private let viewGenerator: ViewGenerator
    private(set) lazy var viewHolder = self.viewGenerator()
    
    public override var view: UIView {
        return viewHolder
    }
    
    public var sizeGenerator: SizeGenerator = {
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
    
    // this action will be called in main thread after view.frame is set
    public var action: Action? = nil {
        didSet {
            if action != nil {
                commitUpdate()
            }
        }
    }
    
    open override var itemIntrinsicContentSize: CGSize {
        return sizeGenerator()
    }
    
    override func updateIfNeed() {
        super.updateIfNeed()
        action?()
    }
}
