//
//  Liner3ViewController.swift
//  Brick
//
//  Created by 李阳 on 2/10/2021.
//

import UIKit

class Liner3ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.title = "vertical.autoSize"
    
        let v = ScopeLayout()
        v.backgroundColor = .red
        self.view.addSubview(v)
        v.margin = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        v.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        v.scope = .safeArea
        
        let l = LinnerLayout(axie: .vertical)
        l.wrapper = .size
        l.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        l.space = 10
        l.frame = CGRect(x: 0, y: 0, width: 170, height: 70)
        l.backgroundColor = .blue
        v.addSubview(l)
        
        for i in 0...2 {
            let label = UILabel()
            label.numberOfLines = 0
            label.backgroundColor = .yellow
            label.text =  ",lklkddfad\(i)"
            l.addSubview(label)
//            if i == 1 {
//                label.offset(value: CGPoint(x: 0, y: 10), effect: true)
//                label.compressible = 400
//            }
        }
    }

}
