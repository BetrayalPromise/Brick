import Foundation
import CoreGraphics
import UIKit

public protocol TextRenderable: AnyObject {
    var textHolder: TextAttributesHolder { get }
    func attributeUpdate(affectSize : Bool)
}

public class TextAttributesHolder{
    weak var render: TextRenderable?
    init(_ render: TextRenderable) {
        self.render = render
    }
    
    public var text: String = "" {
        didSet{
            useAttributedText = false
            if text != oldValue{
                render?.attributeUpdate(affectSize: true)
            }
        }
    }
    
    public var attributeText: NSAttributedString? {
        didSet {
            useAttributedText = true
            if attributeText != oldValue{
                render?.attributeUpdate(affectSize: true)
            }
        }
    }
    
    public var textColor = UIColor.black {
        didSet{
            if oldValue != textColor{
                render?.attributeUpdate(affectSize: false)
            }
        }
    }
    
    public var font = UIFont.systemFont(ofSize: 17) {
        didSet {
            if oldValue != font {
                render?.attributeUpdate(affectSize: true)
            }
        }
    }
    
    public var numberOfLines = 1 {
        didSet {
            if oldValue != numberOfLines {
                render?.attributeUpdate(affectSize: true)
            }
        }
    }
    
    public var lineSpace: CGFloat? {
        didSet {
            if oldValue != lineSpace {
                render?.attributeUpdate(affectSize: true)
            }
        }
    }
    
    public var truncationMode: NSLineBreakMode = .byTruncatingTail {
        didSet {
            if oldValue != truncationMode {
                render?.attributeUpdate(affectSize: true)
            }
        }
    }
    
    public var useAttributedText = false
    
    public var itemIntrinsicContentSize: CGSize {
        if textAttributes.attributeString.length == 0 {
            return .zero
        }
        let maxWidth = CGFloat.infinity
        let size = CGSize(width: maxWidth, height: .infinity)
        
        return render(for: CGRect(origin: .zero, size: size)).size
    }
    
    func sizeFor(maxWidth: CGFloat) -> CGSize {
        if textAttributes.attributeString.length == 0 {
            return .zero
        }
        let size = CGSize(width: maxWidth, height: .infinity)
        return render(for: CGRect(origin: .zero, size: size)).size
    }
    
    func render(for bounds: CGRect) -> TextRender {
        return TextRender.render(for: textAttributes, constrainedSize: bounds.size)
    }
    
    public var textAttributes: TextAttributes {
        var usedAttributeText: NSAttributedString
        
        if let attributeText = attributeText,useAttributedText {
            usedAttributeText = attributeText
        } else {
            let attributes:[NSAttributedString.Key: Any] = [.font: font, .foregroundColor: textColor]
            usedAttributeText = NSAttributedString(string: text as String, attributes: attributes)
        }
        
        if let lineSpace = lineSpace {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpace
            let attributedText = NSMutableAttributedString(attributedString: usedAttributeText)
            attributedText.addAttributes([.paragraphStyle: style], range: attributedText.range)
            usedAttributeText = attributedText
        }
        
        var attributes = TextAttributes()
        attributes.attributeString = usedAttributeText
        attributes.maximumNumberOfLines = numberOfLines
        attributes.lineBreakMode = truncationMode
        
        return attributes
    }
}

extension NSAttributedString {
    var range: NSRange {
        return NSRange(location: 0, length: length)
    }
}
