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
        label.frame = CGRect(x: 100, y: 100, width: 100, height: 200)
    
        print(label.origin(with: .padding))
        print(label.origin(with: .bounds))
        print(label.origin(with: .margin))
        
        print(label.size(with: .padding))
        print(label.size(with: .bounds))
        print(label.size(with: .margin))
        
        print(label.frame(with: .padding))
        print(label.frame(with: .bounds))
        print(label.frame(with: .margin))
    }
}
