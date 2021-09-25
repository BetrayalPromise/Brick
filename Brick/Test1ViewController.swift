import UIKit

class Test1ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let label = LayoutLabel()
        label.backgroundColor = .yellow
        label.padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        label.text = "fafakjkfa"
        label.center = view.center
        label.textAlignment = .center
        view.addSubview(label)
    }
}
