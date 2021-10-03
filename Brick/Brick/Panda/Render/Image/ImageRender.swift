import UIKit

final class ImageRender {
    typealias ImageCache = NSCache<ImageKey, UIImage>
    
    /// just a temporary cache,most of the time,user should adjust image to the right size and manager cache using library like Kingfisher or SDWebImage
    static var cache: ImageCache = {
        let cache = ImageCache()
        cache.countLimit = 50
        return cache
    }()
    
    class func imageForKey(_ key: ImageKey, isCancelled: CancelBlock) -> UIImage? {
        if let image = cache.object(forKey: key) {
            return image
        }
        if let image = contentForKey(key, isCancelled) {
            cache.setObject(image, forKey: key)
            return image
        }
        
        return nil;
    }
    
    class func contentForKey(_ key: ImageKey, _ isCancelled: CancelBlock)->UIImage? {
        if isCancelled(){ return nil }
        
        UIGraphicsBeginImageContextWithOptions(key.size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        
        var size: CGSize = .zero
        switch key.contentMode {
        case .scaleAspectToFit: size = key.image.size.fitted(to: key.size)
        case .scaleAspectToFill: size = key.image.size.filling(with: key.size)
        case .scaleToFill: size = key.size
        }
        let origin = size.inset(to: key.size)
        
        if isCancelled() { return nil }
        
        key.image.draw(in: CGRect(origin: origin, size: size))
        
        if isCancelled(){ return nil }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        if let processor = key.processor,let image = image {
            return processor.process(image: image)
        }
        return image
    }
    
}

final class ImageKey: NSObject {
    let image: UIImage
    let size: CGSize
    let contentMode: ContentMode
    
    var processor: ImageProcessor? = nil
    let hashCache: Int
    
    init(image: UIImage, size: CGSize, contentMode: ContentMode = .scaleAspectToFill ,processor: ImageProcessor? = nil) {
        self.image = image
        self.size = size
        self.processor = processor
        self.contentMode = contentMode
        
        var hasher = Hasher()
        hasher.combine(image)
        hasher.combine(size)
        hasher.combine(contentMode)
        hashCache = hasher.finalize()
    }
    
    override var hash: Int {
        return hashCache
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? ImageKey else{
            return false
        }
        return size == object.size && image == object.image
    }
}
