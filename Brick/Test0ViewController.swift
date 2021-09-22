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
        l.backgroundColor = .blue
        v.addSubview(l)
        
        l.frame = CGRect.init(x: 0, y: 0, width: 300, height: 200)
        
        for i in 0...5 {
//            let label = UILabel(title: "dddaddfaddfdfaddfdfadfadfdddfadkadfkajfkaf\(i)")
            let label = UILabel(title: "\(i)")
            label.numberOfLines = 0
            label.backgroundColor = .yellow
            label.padding = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
            print(label.padding)
            l.addSubview(label)
        }
    }
}
