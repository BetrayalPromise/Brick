import UIKit

public enum StackLayoutAlignment: Int {
    case fill
    case leading
    case firstBaseline // Valid for horizontal axis only
    case center
    case trailing
    case top
    case bottom
    case lastBaseline // Valid for horizontal axis only
}

public enum StackLayoutDistribution {
    case fill
    case fillEqually
    case fillProportionally
    case equalSpacing
    case equalCentering
}


/// Not fully ready yet !!!
open class StackLayoutNode: ViewNode {
    required public init(subnodes:[ViewNode] = []) {
        super.init()
        aligmentArrangment.canvas = self
        distributionArrangement.canvas = self
        subnodes.forEach{ addArrangedSubnode($0) }
    }
    
    public var alignment: StackLayoutAlignment = .leading {
        didSet {
            aligmentArrangment.aligment = alignment
            setNeedUpdateConstraint()
        }
    }
    
    public var distribution: StackLayoutDistribution = .fill {
        didSet {
            distributionArrangement.distribution = distribution
            setNeedUpdateConstraint()
        }
    }
    
    public var space: CGFloat = 4 {
        didSet {
            distributionArrangement.space = space
            setNeedUpdateConstraint()
        }
    }
    
    public var axis: LayoutAxis = .horizontal {
        didSet {
            aligmentArrangment.axis = axis
            distributionArrangement.axis = axis
            setNeedUpdateConstraint()
        }
    }
    
    private let aligmentArrangment = StackLayoutAlignmentArrangement()
    private let distributionArrangement = StackLayoutDistributionArrangement()
    
    private(set) var arrangedSubnodes = [ViewNode]()
    
    private var needUpdateConstraint = false
    
    public func addArrangedSubnode(_ node: ViewNode) {
        arrangedSubnodes.append(node)
        addSubnode(node)
        aligmentArrangment.addItem(node)
        distributionArrangement.addItem(node)
        setNeedUpdateConstraint()
    }
    
    public func addArrangedSubnodes(_ nodes: [ViewNode]) {
        nodes.forEach{ addArrangedSubnode($0) }
    }
    
    public func removeArrangedSubnode(_ node: ViewNode) {
        if let index = arrangedSubnodes.index(of: node) {
            arrangedSubnodes.remove(at: index)
        }
        aligmentArrangment.removeItem(node)
        distributionArrangement.removeItem(node)
        setNeedUpdateConstraint()
    }
    
    private func setNeedUpdateConstraint() {
        needUpdateConstraint = true
    }
    
    override open func updateConstraint() {
        updateConstraintIfNeed()
        super.updateConstraint()
    }
    
    public func updateConstraintIfNeed() {
        if needUpdateConstraint{
            distributionArrangement.updateConstraint()
            aligmentArrangment.updateConstraint()
            needUpdateConstraint = false
        }
    }
    
    func addHiddenObserver(_ node: ViewNode) {
        
    }
}


class StackLayoutArrangement {
    var axis: LayoutAxis = .horizontal
    var items = [ViewNode]()
    var canvasConstraint = [LayoutConstraint]()
    var space: CGFloat = 4
    
    weak var canvas: ViewNode?
    
    var dimensionAttributeForCurrentAxis: LayoutAttribute {
        switch axis {
        case .horizontal: return .height
        case .vertical: return .width
        }
    }
    
    func addItem(_ node: ViewNode) {
        items.append(node)
    }
    
    func removeItem(_ node: ViewNode) {
        if let index = items.index(of: node) {
            items.remove(at: index)
        }
    }
    
    func InvalidIntrinsicContentSizeFor(_ node: ViewNode) {
        
    }
    
    func updateConstraint() {
        updateConstraintIfNeed()
    }
    
    func updateConstraintIfNeed() {
        
    }
}

class StackLayoutAlignmentArrangement: StackLayoutArrangement {
    var aligment: StackLayoutAlignment = .center
    
    var firstAttribute: LayoutAttribute {
        return dimensionAttributeForCurrentAxis
    }
    
    var secondAttribute: LayoutAttribute {
        switch axis {
        case .horizontal:
            switch aligment {
            case .leading,.top: return .top
            case .center: return .centerY
            case .trailing,.bottom: return .bottom
            default: return .bottom
            }
        case .vertical:
            switch aligment {
            case .leading,.top: return .left
            case .center: return .centerX
            case .trailing,.bottom: return .right
            default: return .right
            }
        }
    }
    
    override func updateConstraintIfNeed() {
        canvasConstraint.forEach{ $0.remove() }
        items.forEach { (node) in
            updateFirstAttribute(for: node)
            updateSecondAttribute(for: node)
        }
        
        func updateFirstAttribute(for node: ViewNode) {
            let attribute = firstAttribute
            let anchor = Anchor(item: node, attribute: attribute)
            let anchor2 = Anchor(item: canvas!, attribute: attribute)
            var relation: LayoutRelation = .equal
            switch aligment{
            case .fill: relation = .equal
            default: relation = .lessThanOrEqual
            }
            let constraint = LayoutConstraint(firstAnchor: anchor, secondAnchor: anchor2, relation: relation)
            canvasConstraint.append(constraint)
        }
        
        func updateSecondAttribute(for node: ViewNode) {
            let attribute = secondAttribute
            let anchor = Anchor(item: node, attribute: attribute)
            let anchor2 = Anchor(item: canvas!, attribute: attribute)
            var relation: LayoutRelation = .equal
            switch aligment{
            case .fill: relation = .equal
            case .leading: relation = .greatThanOrEqual
            default: relation = .lessThanOrEqual
            }
            
            let constraint = LayoutConstraint(firstAnchor: anchor, secondAnchor: anchor2, relation: relation)
            canvasConstraint.append(constraint)
        }
        
    }
}

class StackLayoutDistributionArrangement: StackLayoutArrangement {
    typealias ConstraintMapper = NSMapTable<ViewNode, LayoutConstraint>
    
    var distribution: StackLayoutDistribution = .fill
    
    let spaceOrCenterGuide = ConstraintMapper.weakToWeakObjects()
    let edgeToEdgeConstraints = ConstraintMapper.weakToWeakObjects()
    let relatedDimensionConstraints = ConstraintMapper.weakToWeakObjects()
    let hiddingDimensionConstraints = ConstraintMapper.weakToWeakObjects()
    
    var edgeToEdgeRelation: Relation {
        switch distribution {
        case .equalCentering: return .greateThanOrEqual
        default: return .equal
        }
    }
    
    var minAttributeForGapConstraint: LayoutAttribute {
        switch axis {
        case .horizontal: return .left
        case .vertical: return .top
        }
    }
    
    func resetFillEffect() {
        items.traverse { (preNode, currentNode) -> (LayoutConstraint) in
            var multiply: CGFloat = 1
            if distribution == .fillProportionally{
                let size1 = preNode.itemIntrinsicContentSize
                let size2 = currentNode.itemIntrinsicContentSize
                switch axis {
                case .horizontal: multiply = size2.width / size1.width
                case .vertical: multiply = size2.height/size1.height
                }
            }
            
            switch axis {
            case .horizontal: return currentNode.width == preNode.width * multiply
            case .vertical: return currentNode.height == preNode.height * multiply
            }
        }
    }
    
    func resetEquallyEffect() {
        if items.count < 1 {
            return
        }
        
        let guardView = canvas!
        
        if axis == .horizontal {
            items.first!.left == guardView.left
            items.last!.right == guardView.right
            items.space(space,axis:.horizontal)
        } else {
            items.first!.top == guardView.top
            items.last!.bottom == guardView.bottom
            items.space(space,axis:.vertical)
        }
    }
    
    override func updateConstraintIfNeed() {
        resetEquallyEffect()
        switch distribution {
        case .fillEqually,.fillProportionally: resetFillEffect()
        default: break
        }
    }
}
