import UIKit

class Test1ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let label = UILabel()
        label.backgroundColor = .yellow
        label.padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        view.addSubview(label)
        label.text = "对方健康的减肥3u4"
        label.numberOfLines = 0
    }
}
