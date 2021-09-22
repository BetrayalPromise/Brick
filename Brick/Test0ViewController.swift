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
        
        let l = LinnerLayout(axie: .vertical)
        l.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        l.space = 10
        l.backgroundColor = .blue
        v.addSubview(l)
        
        for i in 0...5 {
            let label = UILabel(title: "\(i)")
            label.numberOfLines = 0
            label.backgroundColor = .yellow
            if i == 2 {
                label.padding = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
            }
            l.addSubview(label)
        }
    }
}
