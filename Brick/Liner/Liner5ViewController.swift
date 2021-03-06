import UIKit

class Liner5ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.title = "vertical.autoWidth"
    
        let v = ScopeLayout()
        v.backgroundColor = .red
        self.view.addSubview(v)
        v.margin = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        v.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        v.scope = .safeArea
        
        let l = LinnerLayout(axie: .vertical)
        l.wrapper = .width
        l.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        l.space = 10
        l.frame = CGRect(x: 0, y: 0, width: 170, height: 100)
        l.backgroundColor = .blue
        v.addSubview(l)
        
        for i in 0...5 {
            let label = UILabel()
            label.numberOfLines = 0
            label.backgroundColor = .yellow
            label.text =  ",lklkddfdfadfaad\(i)"
            l.addSubview(label)
        }
    }

}
