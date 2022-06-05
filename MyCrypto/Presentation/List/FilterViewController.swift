//
//  FilterViewController.swift
//  MyCrypto
//
//  Created by Vitaliy Pavlyuk on 04.06.2022.
//

import UIKit
import RxRelay

class FilterViewController: UITableViewController {

    let sourceSubject: BehaviorRelay<[TickerModel]> = .init(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TickerCell")
        // Do any additional setup after loading the view.
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceSubject.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TickerCell", for: indexPath)
        let model = sourceSubject.value[indexPath.row]
        cell.textLabel?.text = model.name
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
