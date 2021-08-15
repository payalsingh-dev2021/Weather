//
//  RecentsViewController.swift
//  Weather
//
//  Created by Payal Singh on 14/08/21.
//

import UIKit
import CoreData

class RecentsViewController: UITableViewController {
    var dataPassed:String?
    let dataManager = DataManager() //Manages Network Request to API
    var activityIndicatorView:UIActivityIndicatorView!
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    var recentSearchesViewModel: RecentSearchViewModel? {
        didSet {
            updateView()
        }
    }
    
    func updateView(){
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataPassed = nil
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        tableView.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView

        fetchRecentSearchesData()
        // Do any additional setup after loading the view.
    }
    
    func fetchRecentSearchesData(){
        recentSearchesViewModel = dataManager.getRecentSearches(managedObjectContext)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchWithRecent" {
            if let item = tableView.indexPathForSelectedRow{
                dataPassed = recentSearchesViewModel?.viewModel(for: item.row).recentSearchText
            }
        }
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



extension RecentsViewController{

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearchesViewModel?.searchesCount ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentsTableViewCell.reuseIdentifier, for: indexPath) as? RecentsTableViewCell else {
            fatalError("Unable to Dequeue Recent Searches Table View Cell")
        }

        guard let recentSearchesViewModel = recentSearchesViewModel else{
            fatalError("Unable to Dequeue Recent Searches Table View Cell")
        }
        
        let recentSearchesRowViewModel = recentSearchesViewModel.viewModel(for: indexPath.row)
        cell.searchText.text = recentSearchesRowViewModel.recentSearchText
        cell.searchTimestamp.text = recentSearchesRowViewModel.searchTimestamp

        return cell
    }
    
    
}
