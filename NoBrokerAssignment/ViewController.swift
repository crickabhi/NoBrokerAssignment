//
//  ViewController.swift
//  NoBrokerAssignment
//
//  Created by Abhinav Mathur on 15/05/17.
//  Copyright © 2017 Abhinav Mathur. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!

    var flatsJSON       : JSON?
    var flatsArray      : Array<AnyObject> = []
    var start           : Int = 1
    
    override func viewWillAppear(_ animated: Bool) {
        self.getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.filterButton.layer.cornerRadius = self.filterButton.frame.width/2
        self.filterButton.addTarget(self, action: #selector(ViewController.setFilter), for: .touchUpInside)
        // Do any additional setup after loading the view, typically from a nib.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flatsArray.count > 0
        {
            return flatsArray.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        print(indexPath.row)
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1
        {
            self.callTableViewReload()
        }
    }
    
    func callTableViewReload()
    {
        start += 1
        self.getData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FlatInformationTableViewCell
        let flatInfo = self.flatsArray[indexPath.row] as AnyObject
        
        cell.FlatTitle.text = flatInfo.value(forKey: "title") as? String
        cell.FlatDescription.text = flatInfo.value(forKey: "secondaryTitle") as? String
        cell.FlatPrice.text = "₹ " + String(describing: flatInfo.value(forKey: "rent")!)
        cell.FlatSize.text = String(describing: flatInfo.value(forKey: "propertySize")!) + " Sq.ft."
        if (flatInfo.value(forKey: "furnishingDesc") as? String) != nil && (flatInfo.value(forKey: "furnishingDesc") as? String) == "Semi"
        {
            cell.FlatMoreInfo.text = "Semi Furnished"
        }
        else if (flatInfo.value(forKey: "furnishingDesc") as? String) != nil && (flatInfo.value(forKey: "furnishingDesc") as? String) == "Full"
        {
            cell.FlatMoreInfo.text = "Fully Furnished"
        }
        else
        {
            cell.FlatMoreInfo.text = "No Information"
        }
        cell.FlatBathrooms.text = String(describing: flatInfo.value(forKey: "bathroom")!) + " Bathrooms"
        let photosArray = flatInfo.value(forKey: "photos") as! Array<AnyObject>
        if photosArray.count > 0
        {
            let originalImage = ((photosArray[0] as AnyObject).value(forKey: "imagesMap") as AnyObject).value(forKey: "original") as! String
            let imagePathArray = originalImage.components(separatedBy: "_")
            let imageUrl = UrlConstants.imageUrl + imagePathArray[0] + "/" + originalImage
            cell.flatImage.sd_setImage(with: NSURL(string: imageUrl) as! URL, placeholderImage: UIImage(named:"NoImage"))
        }
        else
        {
            cell.flatImage.image = UIImage(named: "NoImage")
        }

        if cell.FlatLikeButton.isSelected == true
        {
            
            cell.FlatLikeButton.setImage(UIImage(named: "Favourite"), for: .normal)
            cell.FlatLikeButton.tintColor = UIColor(red: 247/255, green: 27/255, blue: 66/255, alpha: 1.0)
        }
        else
        {
            cell.FlatLikeButton.setImage(UIImage(named: "NotFavourite"), for: .normal)
            cell.FlatLikeButton.tintColor = UIColor(red: 139/255, green: 139/255, blue: 139/255, alpha: 1.0)
        }

        cell.FlatCallButton.setImage(UIImage(named: "Call"), for: .normal)
        cell.FlatCallButton.tintColor = UIColor(red: 247/255, green: 27/255, blue: 66/255, alpha: 1.0)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func getData()
    {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.mode = MBProgressHUDMode.indeterminate
        loadingNotification?.labelText = "Loading"

        var urlToUse : String = UrlConstants.apiUrl
        
        if FilterHandler.typeFilters.count > 0
        {
            self.flatsArray.removeAll()
            var val : String = ""
            for i in 0 ..< FilterHandler.typeFilters.count
            {
                val.append(FilterHandler.typeFilters[i])
            }
            urlToUse += "&type=" + val
        }
        if FilterHandler.buildingTypeFilters.count > 0
        {
            self.flatsArray.removeAll()
            var val : String = ""
            for i in 0 ..< FilterHandler.buildingTypeFilters.count
            {
                val.append(FilterHandler.buildingTypeFilters[i])
            }

            urlToUse += "&buildingType=" + val
        }
        
        urlToUse += "&pageNo=" + String(start)

        let url = URL(string: urlToUse)

        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            //print(JSON(json))
            self.flatsJSON = JSON(json)
            if self.flatsJSON!["data"] != nil
            {
                for i in 0 ..< self.flatsJSON!["data"].arrayObject!.count
                {
                    self.flatsArray.append(self.flatsJSON!["data"].arrayObject![i] as AnyObject)
                } 
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            })
        }
        
        task.resume()

    }
    
    func setFilter()
    {
        self.performSegue(withIdentifier: "applyFilterSegue", sender: "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //"chatView" "chatCollectionView"
        if segue.identifier == "applyFilterSegue" {
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            segue.destination as! FilterViewController
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

