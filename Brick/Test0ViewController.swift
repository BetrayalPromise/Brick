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
        l.overload = .autoHeight
        l.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        l.space = 10
        l.frame = CGRect(x: 0, y: 0, width: 150, height: 70)
        l.backgroundColor = .blue
        v.addSubview(l)
        
        for i in 0...0 {
            let label = LayoutLabel()
            label.numberOfLines = 0
            label.adaptive = true
            label.backgroundColor = .yellow
            label.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            label.text =  ",lklklk大开发fgfhhgf\(i)"
            l.addSubview(label)
        }
    }
}
