//
//  MasterViewController.swift
//  iTunesSearch
//
//  Created by Maddiee on 18/08/18.
//  Copyright © 2018 Maddiee. All rights reserved.
//

import UIKit
enum Identifer {
    static let masterCell = "MasterCell"
    static let detailCell = "DetailCell"
    static let masterCellRight = "MasterCellRight"
    static let masterCellAltRight = "MasterCellAltRight"
    static let masterCellAltLeft = "MasterCellAltLeft"
    static let msterCellAltRight1 = "MasterCellAltRight1"
}

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects: Base?
    
    // lazy loading
    
    var slice: [Results] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var offset: Int = 0
    let increment: Int = 10
    var isUpdating: Bool = false
    
    var searchController = UISearchController(searchResultsController: nil)
    var filterString: String? {
        didSet{
            invokeSearch()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.configureSearchbar()
        self.configureDetailViewController()
        self.title = kMainNavbarTitle.localized
        self.tableView?.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.searchController.isActive = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let controller = (segue.destination as? UINavigationController)?.topViewController as? DetailViewController else {return}
               let object = slice[indexPath.row]
                controller.selectedModel = Utils.getDetailModelFromMasterModel(object)
                controller.imageURL = (object.artworkUrl100 ?? "") as NSString
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slice.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // even
        var cell: SearchResultsTableViewCell? = nil
        
        if indexPath.row % 2 == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: Identifer.msterCellAltRight1, for: indexPath) as? SearchResultsTableViewCell
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: Identifer.msterCellAltRight1, for: indexPath) as? SearchResultsTableViewCell
        }
    
        let object = slice[indexPath.row]
        cell?.configureCell(model: object)
        
        return cell ?? UITableViewCell()
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if self.isUpdating
        {
            return
        }
        
        guard let results = self.objects?.results else
        {
            return
        }
        
        let sliceCount = self.offset + self.increment
        
        guard sliceCount <= (self.objects?.results ?? []).count else
        {
            return
        }
        
        let indexPaths: [IndexPath] =
            (offset..<sliceCount).map { (index:Int) -> IndexPath in
                let indexPath =
                IndexPath.init(item: index, section: 0)
                
                return indexPath
        }
        
        self.slice =
            Array<Results>(results[0..<sliceCount])
        
        self.offset = sliceCount
        
        self.tableView?.beginUpdates()
        
        self.isUpdating = true
        
        self.tableView?.insertRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        
        self.isUpdating = false
        
        self.tableView.endUpdates()
        
        //self.tableView.reloadData()
    }
}

//MARK: Prefetching
extension MasterViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("prefetchRowsAt \(indexPaths)")
        
        for indexpath:IndexPath in indexPaths {
            let cell: SearchResultsTableViewCell? =
            (tableView.cellForRow(at: indexpath)) as? SearchResultsTableViewCell
            
            if (self.slice).count > indexpath.row {
                let model: Results = self.slice[indexpath.row]
                
                    cell?.fetchImage(model, andSetToImageview: cell?.albumArtImageView)
                
            }
        }        
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("cancelPrefetchingForRowsAt \(indexPaths)")
        
        for indexpath:IndexPath in indexPaths
        {
            if (self.slice).count > indexpath.row
            {
                let model: Results =
                    self.slice[indexpath.row]
                
                    NetworkManager.shared.cancelDownloadingImage(forURL: model.artworkUrl100 ?? "")
                
            }
        }
    }
}

//MARK: View Configurations
fileprivate extension MasterViewController
{
    fileprivate func configureSearchbar()
    {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
            self.tableView.tableHeaderView = searchController.searchBar
        }
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.searchBar.tintColor = UIColor.white
        tableView.prefetchDataSource = self
        
    }
    
    fileprivate func configureDetailViewController() {
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
}

//MARK: Invoke Search
fileprivate extension MasterViewController
{
    fileprivate func invokeSearch() {
        guard let searchQuery = filterString, filterString != "" else { slice.removeAll(); self.objects = nil ; return }
        NetworkManager.shared.getSearchResults(searchTerm: searchQuery) { [weak self] (response, Error) in
            

            guard let strongSelf = self else
            {
                return
            }
            
            // reset offset
            strongSelf.offset = 0
            
            strongSelf.objects = response
            
            guard let results = strongSelf.objects?.results else
            {
                return
            }
            
            let sliceCount = strongSelf.offset + strongSelf.increment
            
            guard sliceCount < (strongSelf.objects?.results ?? []).count else
            {
                return
            }
            
            strongSelf.slice =
                Array<Results>(results[0..<sliceCount])
            
            strongSelf.offset = sliceCount
            
        }
    }
}

//MARK: UISearchBarDelegate
extension MasterViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterString = searchText
    }
}
