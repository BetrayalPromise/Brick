import UIKit

public struct TextContext {
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer()
    let textStorage = NSTextStorage()
    let constraintSize: CGSize
    
    public typealias TextKitLockedBlock = (NSLayoutManager,NSTextContainer, NSTextStorage)->()
    
    init(attributeText: NSAttributedString, lineBreakMode: NSLineBreakMode, maxNumberOfLines: Int, exclusionPaths: [UIBezierPath], constraintSize: CGSize) {
        
        // remove extra white space
        layoutManager.usesFontLeading = false
        textStorage.addLayoutManager(layoutManager)
        textStorage.setAttributedString(attributeText)
        
        textContainer.size = constraintSize
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = maxNumberOfLines
        textContainer.exclusionPaths = exclusionPaths
        layoutManager.addTextContainer(textContainer)
        self.constraintSize = constraintSize
    }
    
    public func performBlockWithLockedComponent(_ block: TextKitLockedBlock) {
        block(layoutManager,textContainer,textStorage)
    }
    
}
