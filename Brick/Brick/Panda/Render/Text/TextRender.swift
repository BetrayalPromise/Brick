import UIKit
import CoreGraphics

final public class TextRender {
    
    /// we do not use NSCache here. NSCache‘s auto-removal policies is unpredictable
    /// which may degrade performance significantly sometimes
    /// textRender cache only cost small memory,we don't need to clean up even when we have memory issuse
    /// if no long in use ,clean cache manully
    private typealias TextRenderCache = NSMapTable<TextKitRenderKey, TextRender>
    
    private static let cache = TextRenderCache.strongToStrongObjects()
    
    private static var activeCache = cache
    
    private static var cachePool = [String: TextRenderCache]()
    
    public let textAttributes: TextAttributes
    public let textContext: TextContext
    public let constraintSize: CGSize
    
    private(set) var size: CGSize = .zero
    
    init(textAttributes: TextAttributes,constraintSize: CGSize) {
        
        self.textAttributes = textAttributes
        self.constraintSize = constraintSize
        
        textContext = TextContext(attributeText:textAttributes.attributeString, lineBreakMode: textAttributes.lineBreakMode, maxNumberOfLines: textAttributes.maximumNumberOfLines, exclusionPaths: textAttributes.exclusionPaths, constraintSize: constraintSize)
        updateTextSize()
        
    }
    
    public class func render(for attributes: TextAttributes, constrainedSize: CGSize) -> TextRender {
        let key = TextKitRenderKey(attributes: attributes, constrainedSize: constrainedSize)
        if let render = activeCache.object(forKey: key){
            return render
        }
        
        let render =  TextRender(textAttributes: attributes, constraintSize: constrainedSize)
        
        activeCache.setObject(render, forKey: key)
        
        return render
    }
    
    public class func cleanCachePool() {
        cachePool.removeAll()
    }
    
    public class func activeCache(_ identifier: String) {
        if let cache = cachePool[identifier]{
            activeCache = cache
        }else{
            activeCache = createCache()
            cachePool[identifier] = activeCache
        }
    }
    
    public class func cleanCache(_ identifier: String) {
        cachePool[identifier]?.removeAllObjects()
    }
    
    public class func removeCache(_ identifier: String) {
        cachePool.removeValue(forKey: identifier)
    }
    
    private static func createCache() -> TextRenderCache {
        return TextRenderCache.strongToStrongObjects()
    }
    
    private func updateTextSize() {
        textContext.performBlockWithLockedComponent { (layoutManager, textContainer, textStorage) in
            layoutManager.ensureLayout(for: textContainer)
            size = layoutManager.usedRect(for: textContainer).size
        }
    }
    
    public func drawInContext(_ context: CGContext, bounds: CGRect) {
        context.saveGState()
        UIGraphicsPushContext(context)
        
        textContext.performBlockWithLockedComponent { (layoutManager, textContainer, storage) in
            let range = layoutManager.glyphRange(forBoundingRect: bounds, in: textContainer)
            layoutManager.drawBackground(forGlyphRange: range, at: .zero)
            layoutManager.drawGlyphs(forGlyphRange: range, at: .zero)
        }
        
        UIGraphicsPopContext()
        context.restoreGState()
    }
    
}

private class TextKitRenderKey: NSObject {
    let attributes: TextAttributes
    let constrainedSize: CGSize
    var hasherResult = 0
    
    init(attributes: TextAttributes, constrainedSize: CGSize) {
        self.attributes = attributes
        self.constrainedSize = constrainedSize
        
        var hasher = Hasher()
        hasher.combine(attributes)
        hasher.combine(constrainedSize)
        hasherResult = hasher.finalize()
    }
    
    static func ==(lhs: TextKitRenderKey, rhs: TextKitRenderKey) -> Bool {
        return lhs.constrainedSize == rhs.constrainedSize &&
        lhs.attributes == rhs.attributes
    }
    
    override var hash: Int{
        return hasherResult
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let value = object as? TextKitRenderKey else {
            return false
        }
        return self == value
    }
}

extension CGSize: Hashable{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}
