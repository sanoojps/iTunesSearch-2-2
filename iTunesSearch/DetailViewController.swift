//
//  DetailViewController.swift
//  iTunesSearch
//
//  Created by Maddiee on 18/08/18.
//  Copyright © 2018 Maddiee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var intialStateLabel: UILabel!
    @IBOutlet var headerView: DetailsHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedModel: [DetailsViewModel]?
    
    var imageURL: NSString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.applyInitialUIConfigurations()
    }

    fileprivate func applyInitialUIConfigurations() {
        
        self.tableView.isHidden = true
        self.view.backgroundColor = UIColor.darkGray
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = headerView
        headerView.imageView.image = Utils.imageCache.object(forKey: imageURL ?? "")
        
        self.title = kDetailsNavBarTitle.localized
        
        self.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = self.selectedModel?.count else {return 0}
        tableView.isHidden = !(count > 0)
        return count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifer.detailCell, for: indexPath) as? DetailsTableViewCell else {
            fatalError("Search cell not found")
        }
        guard let model = self.selectedModel?[indexPath.row] else {return UITableViewCell()}
        cell.configureCell(model: model)
        return cell
    }
    
    
}
