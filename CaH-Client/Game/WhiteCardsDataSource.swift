//
//  WhiteCardsDataSource.swift
//  CaH-Client
//
//  Created by Alexander Burghuber on 14.06.19.
//  Copyright © 2019 at.htl-leonding. All rights reserved.
//

import UIKit

class WhiteCardsDataSource: NSObject, UITableViewDataSource {
    
    var whiteCards = Array<String>()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return whiteCards.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(whiteCards[indexPath.row])
        return cell
    }
}
