import UIKit

let QueueLabel = "com.nangezao.AsycDisplayQueue"

private let AsyncDisplayQueue = DispatchQueue(label: QueueLabel, qos: .userInteractive, target: .global())

typealias CancelBlock = () -> Bool

final class AsyncDisplayLayer: CALayer {
    
    typealias AsyncAction = (Bool) -> ()
    typealias ContentAction = (CancelBlock) -> (UIImage?)
    
    var displaysAsynchronously = true
    
    var willDisplayAction: AsyncAction? = nil
    var displayAction: AsyncAction? = nil
    var didDisplayAction: AsyncAction? = nil
    var contentAction: ContentAction? = nil
    
    private var sentinel = Sentinel()
    
    override init() {
        super.init()
        contentsScale = UIScreen.main.scale
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func display() {
        clear()
        displayAsync(displaysAsynchronously)
    }
    
    func cancel() {
        sentinel.increase()
    }
    
    private func displayAsync(_ async: Bool) {
        willDisplayAction?(async)
        let value = sentinel.value
        let isCanceled = {
            return self.sentinel.value != value
        }
        
        if async {
            AsyncDisplayQueue.async {
                if let image = self.contentAction?(isCanceled) {
                    DispatchQueue.main.async {
                        if isCanceled() { return }
                        self.contents = image.cgImage
                        self.didDisplayAction?(async)
                    }
                }
            }
        } else {
            if let image = self.contentAction?(isCanceled) {
                self.contents = image.cgImage
                self.didDisplayAction?(async)
            }
        }
    }
    
    func clear() {
        contents = nil
        cancel()
    }
    
    deinit {
        clear()
    }
}

private class Sentinel {
    var value: Int64 = 0
    
    func increase() {
        OSAtomicIncrement64(&value)
    }
}
