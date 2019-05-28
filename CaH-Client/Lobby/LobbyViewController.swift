//
//  LobbyViewController.swift
//  CaH-Client
//
//  Created by Alexander Burghuber on 14.05.19.
//  Copyright © 2019 at.htl-leonding. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var model = DataDistributor()
    var connectionManager: ConnectionManager? = nil
    var player: Player? = Player()
    var lobby: Lobby = Lobby()


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        connectionManager?.delegate = self
        self.navBar.hidesBackButton = true
        self.navBar.title = self.lobby.lobbyName

        self.connectionManager?.showLobby(id: self.lobby.lobbyId)
    }

    @IBOutlet weak var navBar: UINavigationItem!

    @IBAction func onStart(_ sender: Any) {
        let alert = UIAlertController(title: "Start the game", message: nil, preferredStyle: .alert)
        let message = "Are you sure you want to start the game?"
        alert.message = message
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.performSegue(withIdentifier: "startGame", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "Nah", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        DispatchQueue.main.async {
            print("Destination \(segue.destination)")
            let dest = segue.destination as! UITabBarController
            let realDest = dest.viewControllers?[0] as! GameViewController
            realDest.connectionManager = self.connectionManager
            realDest.lobbyId = self.lobby.lobbyId
            realDest.player = self.player
            realDest.model = self.model
        }
    }

}

extension LobbyViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.players.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "player", for: indexPath) as! PlayerTableViewCell
        let player = model.players[indexPath.row]
        cell.playerName.text = player.nickname
        return cell
    }
}

extension LobbyViewController: ListenOnResponse {
    func hasReceived<T, S>(res: T, req: S) {
        if type(of: res) == Optional<GetLobbyResponse>.self {
            if let dat = res as? GetLobbyResponse {
                self.model.players = dat.players
                self.model.players.forEach({ player in
                })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
