import Foundation

/// use class will be easy to track the value of Variable
/// but using struct performent better than class type
public struct Variable{
  
  /// Variable type
  private enum VarType: CustomDebugStringConvertible {
    
    /// public variable
    case external
    
    /// public variable whose value will alwalys >= 0
    case restrictedExternal
    
    /// variable used to normalize required equality,like expr = 0 to expr + d1 - d2 = 0
    case dummpy
    
    /// variable for inequality,used to normalize expr like expr <= 0 to expr == slack
    case slack
    
    /// Varable for objective function
    case error
    
    var debugDescription: String{
      switch self {
      case .external: return "v"
      case .restrictedExternal: return "r"
      case .dummpy: return "d"
      case .slack: return "s"
      case .error: return "e"
      }
    }
  }
  
  var isDummy: Bool {
    return self.varType == .dummpy
  }
  
  var isExternal: Bool {
    return varType == .external || varType == .restrictedExternal
  }
  
  var isSlack: Bool{
    return varType == .slack
  }
  
  var isError: Bool{
    return varType == .error
  }
  
  var isPivotable: Bool {
    return varType == .slack || varType == .error
  }
  
  var isRestricted: Bool {
    return varType != .external
  }
  
  public init() {
    self.init(type: .external)
  }
  
  public static func restricted() -> Variable{
    return Variable(type: .restrictedExternal)
  }
  
  private init(type: VarType){
    self.varType = type
    Variable.count += 1
    count = Variable.count
  }
  
  static func slack() -> Variable{
    return Variable(type: .slack)
  }
  
  static func dummpy() -> Variable{
    return Variable(type: .dummpy)
  }
  
  static func error() -> Variable{
    return Variable(type: .error)
  }
  
  /// used for debug print
  fileprivate let count: Int
  private static var count = 0
  private let varType: VarType
}

extension Variable: CustomDebugStringConvertible{
  public var debugDescription: String{
    return "\(varType)" + "\(count)"
  }
}

extension Variable: Hashable{}

