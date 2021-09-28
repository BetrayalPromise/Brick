//
//  RootViewController.swift
//  Brick
//
//  Created by 李阳 on 25/9/2021.
//

import UIKit

class RootViewController: UIViewController {
    let controllers: [String] = ["Brick.Test0ViewController", "Brick.Test1ViewController"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        let table = UITableView.init(frame: self.view.frame, style: UITableView.Style.plain)
        self.view.addSubview(table)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        table.delegate = self
        table.dataSource = self
    }
}

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.controllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "\(self.controllers[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let controller: UIViewController.Type = NSClassFromString(controllers[indexPath.row]) as? UIViewController.Type else { return }
        print(controller)
        self.navigationController?.pushViewController(controller.init(), animated: true)
    }
}
