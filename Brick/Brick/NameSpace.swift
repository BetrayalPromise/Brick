import Foundation
import UIKit

///命名空间

public protocol Wrappable {
    associatedtype WrapperType
    var layout: WrapperType { get }
}

public extension Wrappable {
    var layout: Box<Self> {
        get { return Box(value: self) }
    }
}

public protocol Wrapper {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}

public struct Box<T>: Wrapper {
    public var wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}

extension UIView: Wrappable {}

extension Wrapper where WrappedType: UIView {
    public var left: CGFloat {
        return 0.0
    }
}
