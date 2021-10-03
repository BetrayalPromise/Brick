import Foundation
import CoreGraphics

// use tuple as data struct to make it easy to write
// like node.size = (30,30) compare to UIKit node.size = CGSize(width: height: 30)
public typealias Value = CGFloat
public typealias Size = (width: Value, height: Value)
public typealias Point = (x: Value, y: Value)
public typealias Offset = (x: Value, y: Value)
public typealias Insets = (top: Value,left: Value, bottom: Value,right: Value)
public typealias XSideInsets = (left: Value, right: Value)
public typealias YSideInsets = (top: Value, bottom: Value)
public typealias EdgeInsets = (top: Value, left: Value, bottom: Value, right: Value)

//public typealias Rect = (origin: Point, size: Size)
//
public let InvalidIntrinsicMetric: CGFloat = -1
//
public let InvaidIntrinsicSize = CGSize(width: InvalidIntrinsicMetric, height: InvalidIntrinsicMetric)

public let EdgeInsetsZero: EdgeInsets = (0,0,0,0)

//public let RectZero: Rect = ((0,0),(0,0))

public let OffsetZero: Offset = (0,0)

public let SizeZero: Size = (0,0)

public struct LayoutValues {
    public var frame = CGRect.zero
    public var subLayout = [LayoutValues]()
}

