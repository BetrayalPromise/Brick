import Foundation
import UIKit

struct Position {
    
}

struct Size {
    
}

protocol ViewAttribute {
    var left: Position { get }
    var right: Position { get }
    var top: Position { get }
    var bottom: Position { get }
    var centerX: Position { get }
    var centerY: Position { get }
      
    var width: Size { get }
    var height: Size { get }
}

//extension UIView: ViewAttribute {
//    var right: PositionAttribute {
//
//    }
//
//    var top: PositionAttribute {
//
//    }
//
//    var bottom: PositionAttribute {
//
//    }
//
//    var centerX: PositionAttribute {
//
//    }
//
//    var centerY: PositionAttribute {
//
//    }
//
//    var width: SizeAttribute {
//
//    }
//
//    var height: SizeAttribute {
//
//    }
//}

