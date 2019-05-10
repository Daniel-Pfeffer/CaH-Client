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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCreate(_ sender: Any) {
        print("onCreate nickname: \(nickname.text!) lobbyName: \(lobbyName.text!) password: \(password.text!)")
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
