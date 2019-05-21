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

    override func viewDidLoad() {
        super.viewDidLoad()
        connectionManager?.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func onCreate(_ sender: Any) {
        try? connectionManager?.createLobby(
                body: CreateLobbyRequest(
                        nickname: nickname.text!,
                        lobbyName: lobbyName.text!,
                        password: password.text?.count == 0 ? nil : password.text
                )
        )
    }

    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if segue.identifier == "joinLobby" {
            let dest = segue.destination as! LobbyViewController
            dest.connectionManager = self.connectionManager
        }*/
    }*/
}

extension CreateLobbyViewController: ListenOnResponse {
    func hasReceived<T, S>(res: T, req: S) {
        performSegue(withIdentifier: <#T##String##Swift.String#>, sender: <#T##Any?##Any?#>)
    }
}