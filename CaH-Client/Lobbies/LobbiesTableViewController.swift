//
//  LobbyViewController.swift
//  CaH-Client
//
//  Created by Alexander Burghuber on 07.05.19.
//  Copyright © 2019 at.htl-leonding. All rights reserved.
//

import UIKit

class LobbiesTableViewController: UITableViewController {

    var model = DataDistributor()

    let socket: ConnectionManager = ConnectionManager(path: "http://192.168.2.1:8080/")

    var player: Player = Player()

    var lobby: Lobby = Lobby()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        // Clear lobbies
        model.lobbies.removeAll()
        // set listener to current controller
        socket.delegate = self
        // if socket is not connected connect
        if (!socket.socket!.isConnected) {
            //  socket.connectSocket()
        }
        // show lobbies
        socket.showLobbies()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("get numOfRows ")
        return model.lobbies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lobby", for: indexPath) as! LobbiesTableViewCell
        let lobby = model.lobbies[indexPath.row]
        cell.lobby = lobby
        cell.lobbyName?.text = lobby.lobbyName
        cell.playerCount?.text = "\(lobby.playerCount)/10 Players"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let selectedLobby = tableView.cellForRow(at: indexPath!) as! LobbiesTableViewCell

        let alert = UIAlertController(title: selectedLobby.lobbyName.text, message: nil, preferredStyle: .alert)

        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nickname"
        }

        var message: String
        if selectedLobby.lobby.hasPwd {
            alert.addTextField { (textField: UITextField) in
                textField.placeholder = "Password"
            }
            message = "Enter your nickname and the password"
        } else {
            message = "Enter your nickname"
        }
        alert.message = message

        alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { action in
            var join: JoinLobbyRequest = JoinLobbyRequest()
            if let textFields = alert.textFields {
                if let username = textFields[0].text {
                    if textFields.count > 1 {
                        if let pwd = textFields[1].text {
                            join.password = pwd
                        }
                    }
                    join.nickname = username
                    join.lobbyId = selectedLobby.lobby.lobbyId
                }
            }
            self.player.nickname = join.nickname
            self.lobby.lobbyId = join.lobbyId
            try? self.socket.joinLobby(body: join)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "createLobby" {
            let dest = segue.destination as! LobbyViewController
            dest.connectionManager = self.socket
            dest.lobby = self.lobby
            dest.player = self.player
        } else {
            let dest = segue.destination as! CreateLobbyViewController
            dest.connectionManager = self.socket
        }
    }
}

extension LobbiesTableViewController: ListenOnResponse {
    func hasReceived<T, TT>(res: T, req: TT) {
        if type(of: res) == Optional<Array<GetLobbiesResponse>>.self {
            if let dat = res as? Array<GetLobbiesResponse> {
                dat.forEach { response in
                    print("\(response.lobbyName)")
                    self.model.lobbies.append(
                            LobbyBO(
                                    lobbyId: response.lobbyId,
                                    lobbyName: response.lobbyName,
                                    hasPwd: response.hasPwd,
                                    playerCount: response.playerCount
                            )
                    )
                };
                print("Reload now")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else if type(of: res) == JoinLobbyResponse.self {
            if let dat = res as? JoinLobbyResponse {
                self.player.playerId = dat.playerId
                self.lobby.lobbyName = dat.lobbyName
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "joinLobby", sender: nil)
                }
            }
        }
    }
}
