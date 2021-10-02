import UIKit

class Test1ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let label = UILabel()
        label.backgroundColor = .yellow
        view.addSubview(label)
        label.text = "对方健康的减肥3u4"
        label.numberOfLines = 0
        label.frame = CGRect(x: 100, y: 100, width: 0.0, height: 0.0)
        
//        let style = NSMutableParagraphStyle()
//        style.alignment = .left
//        style.lineBreakMode = .byCharWrapping
//        style.firstLineHeadIndent = 10
//        style.headIndent = -10
//        style.tailIndent = -20
//
//        let string = NSAttributedString(string: "string", attributes: [NSAttributedString.Key.paragraphStyle : style])
//        label.attributedText = string
//        label.sizeToFit()
//        label.frame.size = CGSize(width: label.frame.size.width + 10, height: label.frame.size.height)
    }
}
