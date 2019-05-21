//
// Created by Daniel Pfeffer on 2019-05-07.
// Copyright (c) 2019 at.htl-leonding. All rights reserved.
//

import Foundation

// Objects
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

    init() {
        self.nickname = ""
    }
}

class LobbyBO: Codable {
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

class PlayerBO: Codable {
    var playerId: Int
    var nickname: String

    init(playerId: Int, nickname: String) {
        self.playerId = playerId
        self.nickname = nickname
    }
}

class Card: Codable {
    var desc: String

    init(desc: String) {
        self.desc = desc
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
struct GetLobbiesResponse: Codable {
    var lobbyName: String // Lobbyname
    var playerCount: Int // Number of players in lobby
    var hasPwd: Bool  // if lobby has password
    var lobbyId: Int

}

struct GetLobbyResponse: Codable {
    var lobbyName: String
    var master: Int
    var players: Array<PlayerBO>
}


// JOIN LOBBY
struct JoinLobbyRequest: Codable {
    var lobbyId: Int
    var nickname: String
    var password: String?

    init(lobbyId: Int, nickName: String, password: String?) {
        self.lobbyId = lobbyId
        self.nickname = nickName
        self.password = password
    }

    init() {
        self.lobbyId = 0
        self.nickname = ""
    }

    init(lobbyId: Int, nickName: String) {
        self.lobbyId = lobbyId
        self.nickname = nickName
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
protocol ListenOnResponse: AnyObject {
    func hasReceived<T, S>(res: T, req: S) where T: Any, S: Any
}