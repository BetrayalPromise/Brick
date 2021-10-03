import Foundation

public enum Relation: CustomDebugStringConvertible {
    case equal
    case lessThanOrEqual
    case greateThanOrEqual
    
    public var debugDescription: String {
        switch self {
        case .equal: return "=="
        case .greateThanOrEqual: return ">="
        case .lessThanOrEqual: return "<="
        }
    }
}

public struct Strength: RawRepresentable,ExpressibleByFloatLiteral,Equatable {
    public typealias RawValue = Double
    
    public typealias FloatLiteralType = Double
    
    public var rawValue: Double
    
    public init(floatLiteral value: Double) {
        self.init(rawValue: value)
    }
    
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    public static let required: Strength = 1000.0
    public static let strong: Strength = 750.0
    public static let medium: Strength = 250.0
    public static let weak: Strength = 10.0
}

final public class Constraint{
    
    public weak var owner: AnyObject?
    
    public private(set) var expr: Expression
    
    public private(set) var relation: Relation = .equal
    
    public var strength: Strength
    
    init(expr: Expression = Expression(), strength: Strength = .required) {
        self.expr = expr
        self.strength = strength
    }
    
    init(lhs: Variable, op: Relation, expr: Expression, strength: Strength = .required) {
        switch op {
        case .greateThanOrEqual: expr *= -1 ; expr += lhs
        case .lessThanOrEqual: expr -= lhs
        case .equal: expr -= lhs
        }
        
        self.expr = expr
        self.strength = strength
        self.relation = op
    }
    
    init(lhs: Expression, op: Relation, rhs: Expression, strength: Strength = .required) {
        self.expr = rhs
        self.strength = strength
        self.relation = op
        switch op {
        case .greateThanOrEqual:
            expr *= -1
            expr += lhs
        case .lessThanOrEqual:
            expr -= lhs
        case .equal:
            expr -= lhs
        }
    }
    
    func updateConstant(to constant:Double) {
        expression.constant = relation == .lessThanOrEqual ? constant : -constant
    }
    
    var expression: Expression {
        return expr
    }
    
    var isInequality: Bool {
        return relation != .equal
    }
    
    var isRequired: Bool {
        return strength.rawValue >= Strength.required.rawValue
    }
    
    var weight: Double {
        return strength.rawValue
    }
    
    // temporary use, may be changed lately
    private var hashCache: Int?
}

extension Constraint: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(expression.debugDescription) \(relation.debugDescription) 0"
    }
}

extension Constraint: Hashable {
    public static func ==(lhs: Constraint, rhs: Constraint) -> Bool {
        return lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        let hash = hashCache ?? ObjectIdentifier(self).hashValue
        hashCache = hash
        hasher.combine(hash)
    }
}

public func == (lhs: Expression, rhs: Expression) -> Constraint {
    return Constraint(expr: lhs - rhs)
}

public func == (lhs: Expression, rhs: Variable) -> Constraint {
    return Constraint(expr: lhs - rhs)
}

public func == (lhs: Variable, rhs: Expression) -> Constraint {
    return rhs == lhs
}

public func == (lhs: Expression, rhs: Double) -> Constraint {
    return Constraint(expr: lhs - rhs)
}

public func == (lhs: Variable, rhs: Variable) -> Constraint {
    return Constraint(expr: Expression(lhs) - rhs)
}

public func == (lhs: Variable, rhs: Double) -> Constraint {
    return Constraint(expr: Expression(lhs, multiply: 1, constant: -rhs))
}


public func <= (lhs: Expression, rhs: Expression) -> Constraint {
    return Constraint(lhs: lhs, op: .lessThanOrEqual, rhs: rhs)
}

public func >= (lhs: Expression, rhs: Expression) -> Constraint {
    return Constraint(lhs: lhs, op: .greateThanOrEqual, rhs: rhs)
}

public func <= (lhs: Expression, rhs: Double) -> Constraint {
    return Constraint(lhs: lhs, op: .lessThanOrEqual, rhs: Expression(constant: rhs))
}

public func >= (lhs: Expression, rhs: Double) -> Constraint {
    return Constraint(lhs: lhs, op: .greateThanOrEqual, rhs: Expression(constant: rhs))
}

public func <= (lhs: Variable, rhs: Expression) -> Constraint {
    return Constraint(lhs: lhs, op: .lessThanOrEqual, expr: rhs)
}

public func >= (lhs: Variable, rhs: Expression) -> Constraint {
    return Constraint(lhs: lhs, op: .greateThanOrEqual, expr: rhs)
}

public func <= (lhs: Variable, rhs: Variable) -> Constraint {
    return Constraint(lhs: lhs, op: .lessThanOrEqual, expr: Expression(rhs))
}

public func >= (lhs: Variable, rhs: Variable) -> Constraint {
    return Constraint(lhs: lhs, op: .greateThanOrEqual, expr: Expression(rhs))
}

public func <= (lhs: Variable, rhs: Double) -> Constraint {
    return Expression(lhs) <= Expression( constant: rhs)
}

public func >= (lhs: Variable, rhs: Double) -> Constraint {
    return Expression(lhs) >= Expression( constant: rhs)
}
