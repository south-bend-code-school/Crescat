//
//  SearchViewController.swift
//  crescat
//
//  Created by Madelyn Nelson on 12/29/16.
//  Copyright © 2016 Madelyn Nelson. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating  {
    
    //class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating  {


    @IBOutlet weak var searchTableView: UITableView!
    //var searchController = UISearchController(searchResultsController: nil)

    let cellReuseIdentifier = "profCell"
    
    //var titles = ["Bernie Sanders", "Alexandria Viegut", "Barack Obama", "Queen Elizabeth II"]
    var names = ["Bernie Sanders", "Alexandria Viegut", "Barack Obama", "Queen Elizabeth II"]
    var companies = ["Deloitte", "UW Madison", "United States of America", "England Monarchy"]
    var concatenatedData = [String]()
    
    //var nameAndCompany: [(name:String , company: String)] = []
    
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
           searchTableView.tableHeaderView = controller.searchBar
            return controller
        })()
        searchTableView.reloadData()
        
        //concatenatedData = names + companies
        //print("concatenated array:")
        //print(concatenatedData)

        
        // for searching through all fields
       /*
        for (i, element) in names.enumerated() {
            nameAndCompany += [(name:names[i] , company:companies[i])]
        }
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)

        let array = (names as NSArray).filtered(using: searchPredicate)
        
        filteredTableData = array as! [String]
        
        searchTableView.reloadData()
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.isActive {
            return self.filteredTableData.count
        }
        else {
            return self.names.count
        }
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = searchTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ProfSearchCell

        if self.resultSearchController.isActive {
            let i = indexPath.row
            let j = names.index(of: filteredTableData[i])
    
            cell.nameLabel.text = filteredTableData[i]
            cell.companyLabel.text = companies[j!]
            
        } else {
           cell.nameLabel.text = self.names[indexPath.row]
           cell.companyLabel.text = self.companies[indexPath.row]
        }
        return cell
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
        //return UITableViewAutomaticDimension
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
