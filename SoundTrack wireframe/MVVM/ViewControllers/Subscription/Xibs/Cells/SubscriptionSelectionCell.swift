//
//  SubscriptionSelectionCell.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 30/08/23.
//

import UIKit

class SubscriptionSelectionCell: UITableViewCell {

    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelSubscriptionType: UILabel!
    
    @IBOutlet weak var viewBestValue: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
