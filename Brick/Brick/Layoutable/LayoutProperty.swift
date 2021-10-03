import Foundation
import CoreGraphics

final class LayoutProperty {
    let x = Variable()
    let y = Variable()
    let width = Variable.restricted()
    let height = Variable.restricted()
    
    weak var solver: SimplexSolver?
    
    var frame: CGRect {
        guard let solver = solver else {
            return .zero
        }
        let minX = solver.valueFor(x)
        let minY = solver.valueFor(y)
        let w = solver.valueFor(width)
        let h = solver.valueFor(height)
        return CGRect(x: minX ?? 0, y: minY ?? 0, width: w ?? 0, height: h ?? 0)
    }
    
    func expressionFor(attribue: LayoutAttribute) -> Expression {
        switch attribue {
        case .left: return Expression(x)
        case .top: return Expression(y)
        case .right: return x + width
        case .bottom: return  y + height
        case .width: return  Expression(width)
        case .height: return Expression(height)
        case .centerX: return width/2 + x
        case .centerY: return height/2 + y
        }
    }
}

