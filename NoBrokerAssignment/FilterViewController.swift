//
//  FilterViewController.swift
//  NoBrokerAssignment
//
//  Created by Abhinav Mathur on 15/05/17.
//  Copyright © 2017 Abhinav Mathur. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyButton: UIButton!
    
    var searchActive        : Bool = false
    var searching_data      : NSMutableArray = []

    override func viewWillAppear(_ animated: Bool) {
        searchBar.delegate = self
        searchBar.text = .none
        searchBar.showsCancelButton = false
        searchBar.returnKeyType = .default
        searchActive = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.navigationItem.title = "FILTER BY"
        self.navigationItem.hidesBackButton = true

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(FilterViewController.removeController))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        let imageView = UIView(frame: CGRect(x: 0,y: 0,width: 25,height: 25))
        let image = UIImageView(frame: CGRect(x: 0,y: 0,width: 25,height: 25))
        image.image = UIImage(named: "reload")
        image.contentMode = .scaleAspectFit
        imageView.addSubview(image)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(FilterViewController.refersh))
        imageView.addGestureRecognizer(tapRecognizer)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: imageView)

        // Do any additional setup after loading the view.
    }
    
    func refersh()
    {
        
    }
    
    func removeController()
    {
        self.navigationController?.viewControllers.removeLast(self.navigationController!.viewControllers.count - 1)
    }

    func dismissKeyboard()
    {
        view.endEditing(true)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //searchActive = false;
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.showsCancelButton = false
        searchBar.text = .none
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false;
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text!.isEmpty{
            searchActive = false
            tableView.reloadData()
        } else {
            print(" search text %@ ",searchBar.text! as NSString)
            searchActive = true
            searching_data.removeAllObjects()
            /*
            for index in 0 ..< projectsArray!.count
            {
                let currentString = projectsArray?[index].value(forKey: "title") as! String
                if currentString.lowercased().range(of: searchText.lowercased())  != nil {
                    searching_data.add(projectsArray![index])
                    
                }
            }
            */
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 30
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: tableView.bounds.size.width, height: 30))
        
        label.text = FilterHandler.filterCategories[section]
        headerView.addSubview(label)

        //headerView.backgroundColor = UIColor.groupTableViewBackground
        return headerView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        //if searchController.active
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell") as! FilterTableViewCell
        if indexPath.section == 0
        {
            cell.display = FilterHandler.apartmentType
        }
        else if indexPath.section == 1
        {
            cell.display = FilterHandler.propertyType
        }
        else if indexPath.section == 2
        {
            cell.display = FilterHandler.leaseType
        }
        cell.collectionView.tag = indexPath.section
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    @IBAction func applyFilterClicked(_ sender: Any) {
    
        if FilterHandler.selectedFilter.count > 0
        {
            if FilterHandler.selectedFilter[FilterHandler.filterCategories[0]]!.count > 0
            {
                let arr = FilterHandler.selectedFilter[FilterHandler.filterCategories[0]]!
                FilterHandler.typeFilters.append(arr[0])
                for i in 1 ..< arr.count
                {
                    let val = "/" + arr[i]
                    FilterHandler.typeFilters.append(val)
                }
            }
            if FilterHandler.selectedFilter[FilterHandler.filterCategories[1]]!.count > 0
            {
                let arr = FilterHandler.selectedFilter[FilterHandler.filterCategories[1]]!
                FilterHandler.buildingTypeFilters.append(arr[0])
                for i in 1 ..< arr.count
                {
                    let val = "/" + arr[i]
                    FilterHandler.buildingTypeFilters.append(val)
                }
            }
            self.removeController()
        }
        else
        {
            
            let alert = UIAlertController(title: "Alert", message: "Please select filter of your choice", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil);
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
