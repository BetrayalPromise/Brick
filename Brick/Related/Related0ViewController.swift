import UIKit

class Related0ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .random()
        
        let v = RelatedLayout(frame: .zero)
        self.view.addSubview(v)
        v.backgroundColor = .red
        v.scope = .safeArea
        
        let label = UILabel()
        v.addSubview(label)
        label.text = "dfadfadfadfadfad"
        label.sizeToFit()
    
        (label.centerY == self.view.centerY).isActive = true
        (label.centerX == self.view.centerX).isActive = true
    
        print(label.frame)
    }
}
