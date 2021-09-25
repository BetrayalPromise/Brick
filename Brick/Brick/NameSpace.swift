import Foundation
import UIKit

///命名空间

public protocol Boxable {
    associatedtype WrapperType
    var layout: WrapperType { get }
}

public extension Boxable {
    var layout: Box<Self> {
        get { return Box(value: self) }
    }
}

public protocol Boxer {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}

public struct Box<T>: Boxer {
    public var wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}

extension UIView: Boxable {}

extension Boxer where WrappedType: UIView {
    public var left: CGFloat {
        return 0.0
    }
}
