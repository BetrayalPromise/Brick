import Foundation

func synchronized(lock: Any, closure: () -> ()) {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    closure()
}

protocol RunloopObserver: Hashable {
    func runLoopDidUpdate()
}

final class Transaction {
    private static var observerSet = Set<ViewNode>()
    class func addObserver(_ observer: ViewNode) {
        /// runloop observer is only meaningful in main thread
        if Thread.isMainThread {
            StartObserver
            observerSet.insert(observer)
        }
    }
    
    /// just a meaningless static var to make this piece of code run only once
    private static let StartObserver: () = {
        let runLoop = RunLoop.main.getCFRunLoop()
        let activity: CFRunLoopActivity = [.beforeWaiting,.exit]
        var context = CFRunLoopObserverContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        let observer =  CFRunLoopObserverCreate(kCFAllocatorDefault, activity.rawValue, true, 0, { (observer, activity, _) in
            synchronized(lock: Transaction.observerSet) {
                if Transaction.observerSet.count == 0{
                    return
                }
                let transactionSet = Transaction.observerSet
                Transaction.observerSet = Set<ViewNode>()
                transactionSet.forEach {
                    $0.runLoopDidUpdate()
                }
            }
        }, &context)
        CFRunLoopAddObserver(runLoop, observer, .commonModes)
    }()
}


