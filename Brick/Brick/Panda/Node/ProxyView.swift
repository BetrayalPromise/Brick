
import UIKit

/// ProxyView for ViewNode, forward gesture event to ViewNode
class ProxyView: UIView {
    
    weak var node: ViewNode?
    
    private var inHitTest = false
    
    private var inPointInside = false
    
    open override class var layerClass: Swift.AnyClass {
        return AsyncDisplayLayer.self
    }
    
    init(for node: ViewNode, layerAction: (AsyncDisplayLayer) -> ()) {
        super.init(frame: CGRect.zero)
        self.node = node
        layerAction(layer as! AsyncDisplayLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let node = node else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        return node.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !inHitTest {
            inHitTest = true
            let hitTestView = node?.hitTest(point, with: event)
            inHitTest = false
            return hitTestView
        } else {
            return super.hitTest(point, with: event)
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let node = node else{
            return false
        }
        if !inPointInside {
            inPointInside = true
            let pointInside = node.point(inside:point, with:event)
            inPointInside = false
            return pointInside
        } else {
            return super.point(inside: point, with: event)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        node?.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        node?.touchesMoved(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        node?.touchesCancelled(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        node?.touchesEnded(touches, with: event)
    }
    
    open func forwardGestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    open func forwardTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    open func forwardTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    open func forwardTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    open func forwardTouchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
    }
    
}
