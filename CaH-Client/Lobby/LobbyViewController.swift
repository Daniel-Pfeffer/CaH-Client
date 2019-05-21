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
    var joinReq: JoinLobbyRequest? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        connectionManager?.delegate = self
        print("JoinLobbyRequest: \(joinReq)")
        try? connectionManager?.joinLobby(body: joinReq!)
    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let alert = UIAlertController(title: "Start the game", message: nil, preferredStyle: .alert)
        print("Destination \(segue.destination)")
        let dest = segue.destination as! UITabBarController
        let realDest = dest.viewControllers?[0] as! GameViewController

        let message = "Are you sure you want to start the game?"
        alert.message = message
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            realDest.connectionManager = self.connectionManager
            realDest.lobbyId = self.joinReq?.lobbyId
            realDest.model = self.model
            segue.perform()
        }))
        alert.addAction(UIAlertAction(title: "Nah", style: .cancel, handler: nil))
        self.present(alert, animated: true)
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
        print("Has recieved \(res) with the type \(type(of: res))")
        if type(of: res) == JoinLobbyResponse.self {
            if let dat = res as? JoinLobbyResponse {
                self.player?.playerId = dat.playerId
                self.connectionManager?.showLobby(id: (self.joinReq?.lobbyId)!)
            }
        } else if type(of: res) == Optional<GetLobbyResponse>.self {
            print("into getLobby")
            if let dat = res as? GetLobbyResponse {
                self.model.players = dat.players
                self.model.players.forEach({ player in
                    print("Player: \(player.nickname)")
                })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
