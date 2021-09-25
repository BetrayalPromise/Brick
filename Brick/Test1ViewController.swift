import UIKit

class Test1ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let label = LayoutLabel()
        label.backgroundColor = .yellow
        label.padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        view.addSubview(label)
        label.text = "对方健康的减肥3u4"
        label.frame = CGRect(x: 100, y: 100, width: 100, height: 200)
    
        print(label.getOrigin(with: .padding))
        print(label.getOrigin(with: .bounds))
        print(label.getOrigin(with: .margin))
        
        print(label.getSize(with: .padding))
        print(label.getSize(with: .bounds))
        print(label.getSize(with: .margin))
        
        print(label.getFrame(with: .padding))
        print(label.getFrame(with: .bounds))
        print(label.getFrame(with: .margin))
    }
}
