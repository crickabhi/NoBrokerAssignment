//
//  FilterTableViewCell.swift
//  NoBrokerAssignment
//
//  Created by Abhinav Mathur on 15/05/17.
//  Copyright © 2017 Abhinav Mathur. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!

    var display : Dictionary<String,String> = [:]
    
    //var filterCategory : String?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return display.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "optionCell", for: indexPath as IndexPath) as! FilterOptionsCollectionViewCell
        cell.filterOptionButton.layer.cornerRadius = 5
        
        cell.filterOptionButton.setTitle(display.keys[display.keys.index(display.keys.startIndex, offsetBy: indexPath.row)], for: .normal)
        //cell.filterOptionButton.tag = (indexPath.row)
        
        if FilterHandler.selectedFilter[FilterHandler.filterCategories[self.collectionView.tag]] != nil && (FilterHandler.selectedFilter[FilterHandler.filterCategories[self.collectionView.tag]]?.count)! > 0
        {
            let arr = FilterHandler.selectedFilter[FilterHandler.filterCategories[self.collectionView.tag]]
            if arr!.contains(display.values[display.values.index(display.values.startIndex, offsetBy: indexPath.row)])
            {
                cell.filterOptionButton.setTitleColor(UIColor(red: 247/255, green: 27/255, blue: 66/255, alpha: 1.0), for: .normal)
                cell.filterOptionButton.layer.borderWidth = 0.5;
                cell.filterOptionButton.layer.borderColor = UIColor(red: 247/255, green: 27/255, blue: 66/255, alpha: 1.0).cgColor
            }
            else
            {
                cell.filterOptionButton.setTitleColor( UIColor.black, for: .normal)
                cell.filterOptionButton.layer.borderWidth = 0.5;
                cell.filterOptionButton.layer.borderColor = UIColor.darkGray.cgColor
            }
        }
        else
        {
            cell.filterOptionButton.setTitleColor( UIColor.black, for: .normal)
            cell.filterOptionButton.layer.borderWidth = 0.5;
            cell.filterOptionButton.layer.borderColor = UIColor.darkGray.cgColor
        }
        cell.filterOptionButton.addTarget(self, action: #selector(FilterTableViewCell.selectOption), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow : CGFloat = 4
        let hardCodedPadding : CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        _ = collectionView.bounds.height - (2 * hardCodedPadding)

        if display.count < 4 && display.count > 2
        {
            return CGSize(width: 150, height: 50)
        }
        else
        {
          return CGSize(width: itemWidth, height: 50)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    func selectOption(sender : UIButton)
    {
        let buttonPosition: CGPoint = sender.convert(CGPoint.zero, to: self.collectionView)
        let indexPath =   self.collectionView.indexPathForItem(at: buttonPosition)
        if indexPath != nil {
            if FilterHandler.selectedFilter.keys.contains(FilterHandler.filterCategories[self.collectionView.tag])
            {
                var newArray : Array<String> = FilterHandler.selectedFilter[FilterHandler.filterCategories[self.collectionView.tag]]!
                if newArray.contains(display[display.keys[display.keys.index(display.keys.startIndex, offsetBy: (indexPath?.row)!)]]!)
                {
                    newArray.remove(at: newArray.index(of: display[display.keys[display.keys.index(display.keys.startIndex, offsetBy: (indexPath?.row)!)]]!)!)
                }
                else
                {
                    newArray.append(display[display.keys[display.keys.index(display.keys.startIndex, offsetBy: (indexPath?.row)!)]]!)
                }
                FilterHandler.selectedFilter.updateValue(newArray, forKey: FilterHandler.filterCategories[self.collectionView.tag])
            }
            else
            {
                FilterHandler.selectedFilter[FilterHandler.filterCategories[self.collectionView.tag]] = [display[display.keys[display.keys.index(display.keys.startIndex, offsetBy: (indexPath?.row)!)]]!]//[displayArray[indexPath!.row]]
            }
            self.collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
