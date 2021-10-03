import UIKit

public typealias TextTapAction = (NSRange) -> ()

@dynamicMemberLookup
open class TextNode: ControlNode, TextRenderable {
    
    public private(set) lazy var textHolder = TextAttributesHolder(self)
    
    public func attributeUpdate(affectSize: Bool) {
        if affectSize {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        } else {
            setNeedsDisplay()
        }
    }
    
    override open var itemIntrinsicContentSize: CGSize {
        return textHolder.itemIntrinsicContentSize
    }
    
    override open func contentSizeFor(maxWidth: CGFloat) -> CGSize {
        if self.numberOfLines == 1{ return InvaidIntrinsicSize }
        
        return textHolder.sizeFor(maxWidth: maxWidth)
    }
    
    override open func drawContent(in context: CGContext) {
        textHolder.render(for: bounds).drawInContext(context, bounds: bounds)
    }
}

extension TextNode{
    public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<TextAttributesHolder, T>) -> T {
        get{ textHolder[keyPath: keyPath] }
        set { textHolder[keyPath: keyPath] = newValue }
    }
}
