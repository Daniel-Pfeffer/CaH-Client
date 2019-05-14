//
//  Model.swift
//  CaH-Client
//
//  Created by Alexander Burghuber on 07.05.19.
//  Copyright © 2019 at.htl-leonding. All rights reserved.
//

import Foundation

class LobbyBO {
    var lobbyId: Int
    var lobbyName: String
    var hasPwd: Bool
    var playerCount: Int
    var players = [PlayerBO]()
    
    init(lobbyId: Int, lobbyName: String, hasPwd: Bool, playerCount: Int) {
        self.lobbyId = lobbyId
        self.lobbyName = lobbyName
        self.hasPwd = hasPwd
        self.playerCount = playerCount
    }
}

class PlayerBO {
    var playerId: Int
    var nickname: String
    
    init(playerId: Int, nickname: String) {
        self.playerId = playerId
        self.nickname = nickname
    }
}

class Model {
    var lobbies = [LobbyBO]()
}
