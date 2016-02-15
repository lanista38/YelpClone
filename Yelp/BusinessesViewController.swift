//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating  {
    
    
    var businesses: [Business]!
    var filteredBusiness: [Business]!
    var searchController: UISearchController!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        searchController.hidesNavigationBarDuringPresentation = false
        
        Business.searchWithTerm("Sushi", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredBusiness = self.businesses
            self.tableView.reloadData()
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
         
        /** Example of Yelp search with more search options specified
            Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) {
                (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
        
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }}
        **/
   
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return filteredBusiness!.count
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BussinessCell", forIndexPath: indexPath) as! BussinessCell
        cell.business = filteredBusiness[indexPath.row]
        
        return cell
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    func updateSearchResultsForSearchController(searchController: UISearchController){
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty {
                self.filteredBusiness = self.businesses
            }
            else {
                
                self.filteredBusiness = businesses!.filter({ (busines: Business) -> Bool in
                    if let title = busines.name{
                        
                        if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                            return  true
                        }
                            
                        else{
                            return false
                        }
                    }
                    return false
                })
            }
            tableView.reloadData()
        }
        
    }
}
