//
// Created by Daniel Pfeffer on 2019-05-07.
// Copyright (c) 2019 at.htl-leonding. All rights reserved.
//

import Foundation

// HELPER
struct Player: Codable {
    var nickname: String
    var playerId: Int?

    init(nickname: String) {
        self.nickname = nickname
    }

    init(nickname: String, playerId: Int) {
        self.nickname = nickname
        self.playerId = playerId
    }
}

// REST
// CREATE LOBBY
struct CreateLobbyRequest: Codable {
    var nickname: String // Username
    var lobbyName: String // LobbyName
    var password: String? // Password to join Lobby

    init(nickname: String, lobbyName: String, password: String?) {
        self.nickname = nickname
        self.lobbyName = lobbyName
        self.password = password
    }

    init(nickname: String, lobbyName: String) {
        self.nickname = nickname
        self.lobbyName = lobbyName
    }
}

struct CreateLobbyResponse: Codable {
    var playerId: Int
    var lobbyId: Int
}


// SHOW LOBBY !only Responses!
struct ShowLobbyResponse: Codable {
    var name: String // Lobbyname
    var count: Int // Number of players in lobby
    var hasPassword: Bool  // if lobby has password
}

struct ShowLobbyDetailsResponse: Codable {
    var lobbyName: String
    var master: Int
    var players: Array<Player>
}


// JOIN LOBBY
struct JoinLobbyRequest: Codable {
    var lobbyId: Int
    var nickName: String
    var password: String?

    init(lobbyId: Int, nickName: String, password: String?) {
        self.lobbyId = lobbyId
        self.nickName = nickName
        self.password = password
    }

    init(lobbyId: Int, nickName: String) {
        self.lobbyId = lobbyId
        self.nickName = nickName
    }
}

struct JoinLobbyResponse: Codable {
    var playerId: Int
}


// LEAVE LOBBY !only Request!
struct LeaveLobbyRequest: Codable {
    var playerId: Int
    var lobbyId: Int

    init(playerId: Int, lobbyId: Int) {
        self.playerId = playerId
        self.lobbyId = lobbyId
    }
}


// WS
struct Event: Codable {
    var eventName: String // Which thingy has updated
    var primaryKey: Int? // primary key of thingy
}

// PROTOCOL
protocol ListenOnResponse {

}