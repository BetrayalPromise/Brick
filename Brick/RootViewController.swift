import UIKit

class RootViewController: UIViewController {
    let controllers: [String] = ["Brick.Liner0ViewController", "Brick.Liner1ViewController", "Brick.Liner2ViewController", "Brick.Liner3ViewController", "Brick.Liner4ViewController", "Brick.Liner5ViewController", "Brick.Liner6ViewController"]

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
