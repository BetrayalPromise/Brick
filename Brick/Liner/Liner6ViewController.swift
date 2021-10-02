import UIKit

class Liner6ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let s = ScopeLayout()
        s.backgroundColor = .red
        self.view.addSubview(s)
        s.margin = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        s.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        s.scope = .safeArea
        
        
        let liner = LinnerLayout(axie: .vertical)
        liner.wrapper = .size
        liner.space = 15
        liner.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        liner.backgroundColor = UIColor.random()
        s.addSubview(liner)
        
        for i in 0...10 {
            let label = UILabel(frame: .zero)
            liner.addSubview(label)
            label.text = "dfadfkdka\(i)"
        }
    }
}
