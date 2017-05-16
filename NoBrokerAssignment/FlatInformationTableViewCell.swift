//
//  FlatInformationTableViewCell.swift
//  NoBrokerAssignment
//
//  Created by Abhinav Mathur on 15/05/17.
//  Copyright © 2017 Abhinav Mathur. All rights reserved.
//

import UIKit

class FlatInformationTableViewCell: UITableViewCell {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var flatImage: UIImageView!

    @IBOutlet weak var FlatTitle: UILabel!
    @IBOutlet weak var FlatDescription: UILabel!
    @IBOutlet weak var FlatCallButton: UIButton!
    @IBOutlet weak var FlatLikeButton: UIButton!
    
    @IBOutlet weak var FlatPrice: UILabel!
    @IBOutlet weak var FlatMoreInfo: UILabel!
    @IBOutlet weak var FlatBathrooms: UILabel!
    @IBOutlet weak var FlatSize: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
