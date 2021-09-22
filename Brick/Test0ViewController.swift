import UIKit

class Test0ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.view.frame)
        self.view.backgroundColor = .white
    
        let v = ScopeLayout()
        v.backgroundColor = .red
        self.view.addSubview(v)
        v.margin = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        v.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        v.scope = .safeArea
        
        let l = LinnerLayout(axie: .horizontal)
        l.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        l.space = 10
        l.backgroundColor = .black
        v.addSubview(l)
        
        l.frame = CGRect.init(x: 0, y: 0, width: 300, height: 200)
        
        for i in 0...0 {
            let label = UILabel(title: "dddaddfaddfdfaddfdfadfadfdddfadkadfkajfkaf\(i)")
            label.numberOfLines = 0
            label.backgroundColor = .yellow
            l.addSubview(label)
            label.padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
//            if i == 2 {
//                label.offset = CGPoint(x: -5, y: 5)
//                label.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//            }
        }
    }
}
