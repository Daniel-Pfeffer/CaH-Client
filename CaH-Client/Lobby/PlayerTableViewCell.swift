//
//  PlayerTableViewCell.swift
//  CaH-Client
//
//  Created by Alexander Burghuber on 13.05.19.
//  Copyright © 2019 at.htl-leonding. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var playerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
