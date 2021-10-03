import UIKit

public typealias ControlAction = (ControlNode,UIControl.Event) -> ()

open class ControlNode: ViewNode {
    open var enabled = true
    open var tracking = false
    open var touchInside = false
    
    // use this property to expand hitTest size.
    // it is useful to expand hit size
    open var hitTestSlop = UIEdgeInsets.zero
    
    open var highlighted = false
    
    // used by subclass such as button,it may affact appearance
    open var selected = false
    
    private lazy var eventActionTable = [UIControl.Event: ControlAction]()
    
    private var hitRect: CGRect {
        // As mentioned in AsyncDisplayKit,UIControl has extra space when touch moving
        return bounds.inset(by: hitTestSlop).insetBy(dx: -70, dy: -70)
    }
    
    public override init() {
        super.init()
        userInteractionEnabled = false
    }
    
    // subclass override point.determin where to start track touch
    open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return true
    }
    
    open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return true
    }
    
    // touch is sometimes nil if cancelTracking calls through to this.
    open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
    }
    
    // event may be nil if cancelled for non-event reasons, e.g. removed from window
    open func cancelTracking(with event: UIEvent?) {
        touchCancelTracking(with: event)
    }
    
    open func addAction(for controlEvents: UIControl.Event, action: @escaping ControlAction) {
        let events: [UIControl.Event] = [.touchDown,.touchCancel,.touchUpInside,.touchUpOutside,.touchDragInside,.touchDragOutside]
        for event in events {
            if controlEvents.contains(event) {
                eventActionTable[event] = action
            }
        }
        updateUserInteraction()
    }
    
    open func removeAction(for controlEvents: UIControl.Event) {
        let events: [UIControl.Event] = [.touchDown,.touchCancel,.touchUpInside,.touchUpOutside,.touchDragInside,.touchDragOutside]
        for event in events {
            if controlEvents.contains(event){
                eventActionTable.removeValue(forKey: event)
            }
        }
        updateUserInteraction()
    }
    
    // send all actions associated with events
    open func sendActions(for controlEvents: UIControl.Event, with event:UIEvent? = nil) {
        eventActionTable[controlEvents]?(self,controlEvents)
    }
    
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !enabled {
            return
        }
        
        if let touch = touches.first {
            if !beginTracking(touch, with: event){
                return
            }
        }
        
        if touches.count > 1 && tracking {
            touchCancelTracking(with: event)
        } else {
            tracking = true
            highlighted = true
            touchInside = true
            sendActions(for: .touchDown, with: event)
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !enabled {
            return
        }
        
        guard let touch = touches.first else {
            tracking = false
            return
        }
        if !tracking || !continueTracking(touch, with: event) {
            tracking = false
            return
        }
        let location = touch.location(in: self.view)
        
        let inside = hitRect.contains(location)
        sendActions(for: inside ? .touchDragInside : .touchDragOutside , with: event)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !enabled {
            return
        }
        
        if !tracking {
            return
        }
        
        tracking = false
        highlighted = false
        touchInside = false
        
        guard let touch = touches.first else {
            return
        }
        
        endTracking(touch, with: event)
        let location = touch.location(in: view)
        
        let inside = hitRect.contains(location)
        sendActions(for: inside ? .touchUpInside : .touchUpOutside, with: event)
        
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !enabled {
            return
        }
        cancelTracking(with: event)
    }
    
    private func touchCancelTracking(with event:UIEvent?) {
        tracking = false
        highlighted = false
        touchInside = false
        sendActions(for: .touchCancel, with: event)
    }
    
    private func updateUserInteraction() {
        userInteractionEnabled = eventActionTable.count > 0
    }
}

extension UIControl.Event: Hashable{}
