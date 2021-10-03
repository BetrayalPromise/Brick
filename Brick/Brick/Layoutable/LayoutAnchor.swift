import Foundation
import CoreGraphics

public protocol AnchorType: AnyObject, CustomDebugStringConvertible {
    var item: Layoutable! { get set }
    var attribute: LayoutAttribute { get }
}

extension AnchorType {
    func expression() -> Expression {
        return item.layoutManager.variable.expressionFor(attribue: attribute)
    }
    
    func expression(in node: Layoutable?) -> Expression {
        let expr = expression()
        guard let node = node else { return expr }
        
        expr.earse(node.layoutManager.variable.x)
        expr.earse(node.layoutManager.variable.y)
        
        if node === item {
            return expr
        }
        
        assert(item.superItem != nil)
        var superItem = item.superItem!
        let xExpr = Expression()
        let yExpr = Expression()
        while !(superItem === node)  {
            xExpr += superItem.layoutManager.variable.x
            yExpr += superItem.layoutManager.variable.y
            assert(superItem.superItem != nil)
            superItem = superItem.superItem!
        }
        let coffeeX = expr.coefficient(for: item.layoutManager.variable.x)
        let coffeeY = expr.coefficient(for: item.layoutManager.variable.y)
        expr += coffeeX * xExpr
        expr += coffeeY * yExpr
        return expr
    }
}

extension AnchorType {
    @discardableResult
    public func constraint(to anchor: Self? = nil,relation: LayoutRelation, constant: Value = 0) -> LayoutConstraint{
        return LayoutConstraint(firstAnchor: self , secondAnchor: anchor, relation: relation, constant:constant)
    }
    
    // These methods return a constraint of the form thisAnchor = otherAnchor + constant.
    @discardableResult
    public func equalTo(_ anchor: Self? = nil, constant: Value = 0) -> LayoutConstraint{
        return constraint(to: anchor, relation: .equal, constant: constant)
    }
    
    @discardableResult
    public func greaterThanOrEqualTo(_ anchor: Self? = nil, constant: Value = 0) -> LayoutConstraint{
        return constraint(to: anchor, relation: .greatThanOrEqual, constant: constant)
    }
    
    @discardableResult
    public func lessThanOrEqualTo(_ anchor: Self? = nil, constant: Value = 0) -> LayoutConstraint{
        return constraint(to: anchor, relation: .lessThanOrEqual, constant: constant)
    }
    
    @discardableResult
    static public func == (lhs: Self, rhs: Self) -> LayoutConstraint{
        return lhs.equalTo(rhs)
    }
    
    @discardableResult
    static public func <= (lhs: Self, rhs: Self) -> LayoutConstraint{
        return lhs.lessThanOrEqualTo(rhs)
    }
    
    @discardableResult
    static public func >= (lhs: Self,rhs: Self) -> LayoutConstraint{
        return lhs.greaterThanOrEqualTo(rhs)
    }
    
    @discardableResult
    static public func == (lhs: Self, rhs: Value) -> LayoutConstraint{
        return lhs.equalTo(constant: rhs)
    }
    
    @discardableResult
    static public func <= (lhs: Self, rhs: Value) -> LayoutConstraint{
        return lhs.lessThanOrEqualTo(constant: rhs)
    }
    
    @discardableResult
    static public func >= (lhs: Self,rhs: Value) -> LayoutConstraint{
        return lhs.greaterThanOrEqualTo(constant: rhs)
    }
}

public class Anchor: AnchorType {
    public weak var item: Layoutable!
    public let attribute: LayoutAttribute
    public init(item: Layoutable, attribute: LayoutAttribute) {
        self.item = item
        self.attribute = attribute
    }
    
    public var debugDescription: String{
        let identifier = ObjectIdentifier(item).pure
        return "\(String(describing: item!))(\(identifier)).\(attribute)"
    }
}

/// Axis-specific subclasses for location anchors: top/bottom, left/right, etc.
final public class XAxisAnchor : Anchor {}

final public  class YAxisAnchor : Anchor {}

/// This layout anchor subclass is used for sizes (width & height).
final public class DimensionAnchor : Anchor {
    
    ///  These methods return a constraint of the form
    ///  thisAnchor = otherAnchor * multiplier + constant.
    @discardableResult
    final public func equalTo(_ anchor: DimensionAnchor? = nil, multiplier m: Value = 1, constant: Value = 0) -> LayoutConstraint{
        return LayoutConstraint(firstAnchor: self, secondAnchor: anchor, relation: .equal, multiplier: m, constant: constant)
    }
    
    @discardableResult
    final public func greaterThanOrEqualTo(_ anchor: DimensionAnchor? = nil, multiplier m: Value = 1, constant: Value = 0 ) -> LayoutConstraint{
        return LayoutConstraint(firstAnchor:self, secondAnchor: anchor, relation:.greatThanOrEqual ,multiplier:m, constant:constant )
    }
    
    @discardableResult
    final public func lessThanOrEqualTo(_ anchor: DimensionAnchor? = nil, multiplier m: Value = 1, constant: Value = 0) -> LayoutConstraint{
        return LayoutConstraint(firstAnchor:self, secondAnchor: anchor,relation:.lessThanOrEqual ,multiplier:m, constant:constant )
    }
}

final public class LayoutExpression<AnchorType: Anchor>{
    var anchor: AnchorType
    var value: Value
    var multiplier: Value = 1
    
    init(anchor: AnchorType, multiplier: Value = 1, offset: Value = 0) {
        self.anchor = anchor
        self.multiplier = multiplier
        self.value = offset
    }
}

@discardableResult
public func + <AnchorType: Anchor>(lhs: AnchorType, rhs: Value) -> LayoutExpression<AnchorType>{
    return LayoutExpression(anchor: lhs, offset: rhs)
}

@discardableResult
public func - <AnchorType: Anchor>(lhs: AnchorType, rhs: Value) -> LayoutExpression<AnchorType>{
    return lhs + (-rhs)
}

@discardableResult
public func == <AnchorType: Anchor>(lhs: AnchorType, rhs: LayoutExpression<AnchorType>) -> LayoutConstraint{
    return lhs.equalTo(rhs.anchor, constant: rhs.value)
}

@discardableResult
public func >= <AnchorType: Anchor>(lhs: AnchorType, rhs: LayoutExpression<AnchorType>) -> LayoutConstraint{
    return lhs.greaterThanOrEqualTo(rhs.anchor, constant: rhs.value)
}

@discardableResult
public func <= <AnchorType: Anchor>(lhs: AnchorType, rhs: LayoutExpression<AnchorType>) -> LayoutConstraint{
    return lhs.lessThanOrEqualTo(rhs.anchor, constant: rhs.value)
}

/// LayoutDimession
@discardableResult
public func + <AnchorType: Anchor>(lhs: LayoutExpression<AnchorType>, rhs: Value) -> LayoutExpression<AnchorType>{
    lhs.value += rhs
    return lhs
}

@discardableResult
public func - (lhs: LayoutExpression<DimensionAnchor>, rhs: Value) -> LayoutExpression<DimensionAnchor>{
    return lhs + (-rhs)
}

@discardableResult
public func * (lhs: DimensionAnchor, rhs: Value) -> LayoutExpression<DimensionAnchor>{
    return LayoutExpression(anchor: lhs, multiplier: rhs)
}

@discardableResult
public func / (lhs: DimensionAnchor, rhs: Value) -> LayoutExpression<DimensionAnchor>{
    return lhs * (1/rhs)
}

@discardableResult
public func == (lhs: DimensionAnchor, rhs: LayoutExpression<DimensionAnchor>) -> LayoutConstraint{
    return lhs.equalTo(rhs.anchor, multiplier: rhs.multiplier, constant: rhs.value)
}

@discardableResult
public func >= (lhs: DimensionAnchor, rhs: LayoutExpression<DimensionAnchor>) -> LayoutConstraint{
    return lhs.greaterThanOrEqualTo(rhs.anchor, multiplier: rhs.multiplier, constant: rhs.value)
}

@discardableResult
public func <= (lhs: DimensionAnchor, rhs: LayoutExpression<DimensionAnchor>) -> LayoutConstraint{
    return lhs.lessThanOrEqualTo( rhs.anchor, multiplier: rhs.multiplier, constant: rhs.value)
}

extension ObjectIdentifier {
    var pure: String {
        return String(debugDescription.split(separator: "(")[1].split(separator: ")")[0])
    }
}
