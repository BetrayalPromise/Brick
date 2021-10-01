import UIKit

class Liner0ViewController: UIViewController {
    
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
        l.wrapper = .height
        l.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        l.space = 10
        l.frame = CGRect(x: 0, y: 0, width: 170, height: 70)
        l.backgroundColor = .blue
        v.addSubview(l)
        
        for i in 0...1 {
            let label = UILabel()
            label.numberOfLines = 0
            label.backgroundColor = .yellow
//            label.margin = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            label.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            label.text =  ",lklkldfafadfadfadfadfad\(i)"
            label.font = UIFont.systemFont(ofSize: 32)
            l.addSubview(label)
            if i == 1 {
                label.offset = CGPoint(x: 10, y: 10)
                label.compressible = 400
            }
        }
    }
}
