//
//  Liner4ViewController.swift
//  Brick
//
//  Created by 李阳 on 2/10/2021.
//

import UIKit

class Liner4ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.title = "vertical.autoHeight"
    
        let v = ScopeLayout()
        v.backgroundColor = .red
        self.view.addSubview(v)
        v.margin = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        v.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        v.scope = .safeArea
        
        let l = LinnerLayout(axie: .vertical)
        l.wrapper = .height
        l.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        l.space = 10
        l.frame = CGRect(x: 0, y: 0, width: 170, height: 70)
        l.backgroundColor = .blue
        v.addSubview(l)
        
        for i in 0...2 {
            let label = UILabel()
            label.numberOfLines = 0
            label.backgroundColor = .yellow
            label.text =  ",lkldfadadfadfadfakddfad\(i)"
            l.addSubview(label)
        }
    }
}
