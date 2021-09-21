import UIKit
import FrameLayoutKit

class Test1ViewController: UIViewController {
//    let layout = LinnerLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
//        layout.backgroundColor = .red
//        self.view.addSubview(layout)
//        layout.layoutSize = .safeArea
        
        let label = UILabel(title: "dfkajdkfakldfjakd")
        label.backgroundColor = .yellow
        view.addSubview(label)
        label.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        label.center = view.center
        print(label.bounds)
        print(label.paddingSize)
        label.frame = CGRect(origin: CGPoint(x: 0, y: 0), size:  label.paddingSize)
        label.textAlignment = .center
    }
}
