//
//  LobbyTableViewCell.swift
//  CaH-Client
//
//  Created by Alexander Burghuber on 07.05.19.
//  Copyright © 2019 at.htl-leonding. All rights reserved.
//

import UIKit

class LobbiesTableViewCell: UITableViewCell {

    var lobby: LobbyBO!
    @IBOutlet weak var lobbyName: UILabel!
    @IBOutlet weak var playerCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}