//
//  GameViewController.swift
//  CaH-Client
//
//  Created by Daniel Pfeffer on 21.05.19.
//  Copyright © 2019 at.htl-leonding. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    var model = DataDistributor()
    var connectionManager: ConnectionManager? = nil
    var lobbyId: Int? = nil

    @IBOutlet weak var labelToCheckCards: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.connectionManager?.delegate = self
        self.connectionManager?.startGame(lobbyId: lobbyId!)
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GameViewController: ListenOnResponse {
    func hasReceived<T, S>(res: T, req: S) {
        if type(of: res) == Bool.self {
            if res as! Bool {
                print("sendCards")
                self.connectionManager?.getRandomCards()
            }
        }
        print(type(of: res))
        if type(of: res) == Optional<Array<String>>.self {
            print("got Cards")
            if let dat = res as? Array<String> {
                print("parsed Cards")
                dat.forEach { (data) in
                    print("Cardname: \(data)")
                    self.model.cards.append(Card(desc: data))
                }
            }
            self.labelToCheckCards.text = self.model.cards.first?.desc
        }
    }
}
