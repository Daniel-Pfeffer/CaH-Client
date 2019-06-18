//
//  CreateLobbyViewController.swift
//  CaH-Client
//
//  Created by Alexander Burghuber on 07.05.19.
//  Copyright © 2019 at.htl-leonding. All rights reserved.
//

import UIKit

class CreateLobbyViewController: UIViewController {

    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var lobbyName: UITextField!
    @IBOutlet weak var password: UITextField!
    var connectionManager: ConnectionManager? = nil
    var lobbyId: Int = 0
    var player: Player = Player()

    override func viewDidLoad() {
        super.viewDidLoad()
        connectionManager?.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func onCreate(_ sender: Any) {
        self.player.nickname = nickname.text!
        var createLobby: CreateLobbyRequest
        if ((password?.text) != nil) {
            createLobby = CreateLobbyRequest(
                    nickname: nickname.text!,
                    lobbyName: lobbyName.text!,
                    password: password.text
            )
        } else {
            createLobby = CreateLobbyRequest(
                    nickname: nickname.text!,
                    lobbyName: lobbyName.text!
            )
        }
        try? connectionManager?.createLobby(
                body: createLobby
        )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "joinFromCreate" {
            let dest = segue.destination as! LobbyViewController
            dest.connectionManager = self.connectionManager
            dest.player = self.player
            dest.lobby = Lobby(lobbyId: self.lobbyId, lobbyName: self.lobbyName.text!)
        }
    }
}

extension CreateLobbyViewController: ListenOnResponse {
    func hasReceived<T, S>(res: T, req: S) {
        if type(of: res) == CreateLobbyResponse.self {
            if let resp = res as? CreateLobbyResponse {
                self.lobbyId = resp.lobbyId
                self.player.playerId = resp.playerId
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "joinFromCreate", sender: nil)
                }
            }
        }

    }
}
