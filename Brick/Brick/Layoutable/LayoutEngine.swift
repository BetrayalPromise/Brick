import Foundation
import CoreGraphics

final class LayoutEngine {
    static let solverPool = NSMapTable<AnyObject, SimplexSolver>.weakToStrongObjects()
    static func solveFor(_ node: Layoutable) -> SimplexSolver {
        if let solver = solverPool.object(forKey: node) {
            return solver
        } else {
            let solver = SimplexSolver()
            solver.autoSolve = false
            solverPool.setObject(solver, forKey: node)
            return solver
        }
    }
}
