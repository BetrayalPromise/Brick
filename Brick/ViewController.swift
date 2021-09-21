import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = BaseLayout(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        layout.backgroundColor = .red
        self.view.addSubview(layout)
    }
}

