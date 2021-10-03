import UIKit

public struct TextAttributes: Hashable {
    var attributeString = NSAttributedString()
    var lineBreakMode: NSLineBreakMode = .byCharWrapping
    var maximumNumberOfLines: Int = 0
    var exclusionPaths: [UIBezierPath] = []
    var shadowOffset: CGSize = .zero
    var shadowColor: UIColor = .clear
    var shadowOpacity: CGFloat = 0.0
    var shadowRadius: CGFloat = 0.0
    
    public static func ==(lhs: TextAttributes, rhs: TextAttributes) -> Bool {
        return lhs.lineBreakMode == rhs.lineBreakMode && lhs.maximumNumberOfLines == rhs.maximumNumberOfLines && lhs.shadowOffset == rhs.shadowOffset && lhs.shadowRadius == rhs.shadowRadius && lhs.shadowOpacity == rhs.shadowOpacity && lhs.shadowColor == rhs.shadowColor && lhs.exclusionPaths == rhs.exclusionPaths && lhs.attributeString == rhs.attributeString
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(attributeString)
        hasher.combine(lineBreakMode)
        hasher.combine(maximumNumberOfLines)
        hasher.combine(shadowColor)
        hasher.combine(shadowOpacity)
        hasher.combine(shadowRadius)
    }
}
