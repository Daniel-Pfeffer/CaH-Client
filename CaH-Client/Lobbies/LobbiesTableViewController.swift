//
//  LobbyTableViewController.swift
//  CaH-Client
//
//  Created by Alexander Burghuber on 07.05.19.
//  Copyright © 2019 at.htl-leonding. All rights reserved.
//

import UIKit

class LobbiesTableViewController: UITableViewController {

    var model = Model()

    let socket: ConnectionManager = ConnectionManager(path: "http://192.168.2.1:8080/rest")
    var boi: Any? = nil;


    override func viewDidLoad() {
        super.viewDidLoad()

        let lobby = LobbyBO(lobbyId: 0, lobbyName: "Karls lobby", hasPwd: true, playerCount: 1)
        model.lobbies.append(lobby)

        socket.delegate = self
        do {
            try socket.createLobby(body: CreateLobbyRequest(nickname: "MrGewurz", lobbyName: "Bunkersquad"))
        } catch {
            print("Failed")
        }
        }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.lobbies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lobby", for: indexPath) as! LobbyTableViewCell
        let lobby = model.lobbies[indexPath.row]
        cell.lobby = lobby
        cell.lobbyName?.text = lobby.lobbyName
        cell.playerCount?.text = "\(lobby.playerCount)/10 Players"
        return cell
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "createLobby" {
            let selectedLobby = sender as! LobbyTableViewCell
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
                segue.perform()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        }
    }
}

extension LobbiesTableViewController: ListenOnResponse {
    func hasReceived<T>(data: T) {
        print(data)
    }

}