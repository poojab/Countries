//
//  Constants.swift
//  Countries
//
//  Created by Pooja Bohora on 28/06/19.
//  Used to show list of countries
import UIKit

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    @IBOutlet var tableView: UITableView!
    var detailViewController: DetailViewController? = nil
    var filteredCountries : [Country]?
    var savedCountries : [Country]?
    let queue = OperationQueue()
    var  operation = BlockOperation()
    var isOffline = false;
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- User defined methods
    
    /// Sets up basic UI
    func setupView()
    {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Countries"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        self.splitViewController?.delegate=self
        // Setup the search footer
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.becomeFirstResponder()
        self.tableView.isHidden=true
        
        if !Utils.shared.isNetworkAvailable(){
            isOffline = true
            if let countries = CountryListPresenter().getSavedCountries()
            {
                self.filteredCountries = [Country]()
                self.savedCountries = [Country]()
                tableView.isHidden=false
                self.filteredCountries?.append(contentsOf: countries)
                self.savedCountries?.append(contentsOf: countries)
                
            }
            Utils.shared.operation.cancel()
            tableView.reloadData()
        }
    }

    // MARK: - Table View methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var country: Country?
        country = filteredCountries?[indexPath.row]
        cell.textLabel!.text = country?.name
        cell.detailTextLabel?.text = country?.region
        return cell
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let country: Country?
                country = filteredCountries?[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailCountry = country
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Private instance methods
    
    /// Implements search
    ///
    /// - Parameter searchText: search text
    func filterContentForSearchText(_ searchText: String) {
        if isOffline{
            if let countries = CountryListPresenter().getCounties(forText: searchText)
            {
                self.filteredCountries?.removeAll()
                self.filteredCountries = [Country]()
                self.filteredCountries?.append(contentsOf: countries)
                self.tableView.isHidden=false
                Utils.shared.operation.cancel()
                self.tableView.reloadData()
            }
        }
        else{
            operation.cancel()
            
            operation = BlockOperation(block: {

            OperationQueue.main.addOperation({ () -> Void in
            CountryListPresenter().getCountries(searchKey: searchText) { (countries, error) in
                if !error{
                    self.filteredCountries?.removeAll()
                    
                    if let countries = countries{
                        self.filteredCountries = [Country]()
                        self.filteredCountries?.append(contentsOf: countries)
                        self.tableView.isHidden=false
                        Utils.shared.operation.cancel()
                        self.tableView.reloadData()
                    }
                }
            }
            })
        })
            operation.queuePriority = Operation.QueuePriority(rawValue: TaskPriority.high.rawValue)!
            queue.addOperation(operation)
        }
        
    }
    
}

extension MasterViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension MasterViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
}

extension MasterViewController : UISplitViewControllerDelegate
{
    //show master by default
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool{
        // Return true to prevent UIKit from applying its default behavior
        return true
    }
}
