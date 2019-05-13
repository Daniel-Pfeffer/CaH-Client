//
// Created by Daniel Pfeffer on 2019-05-07.
// Copyright (c) 2019 at.htl-leonding. All rights reserved.
//

import Foundation

// HELPER
struct Player {
    var nickname: String
    var playerId: Int
}

// REST
// CREATE LOBBY
struct CreateLobbyRequest: Codable {
    var nickname: String // Username
    var lobbyName: String // LobbyName
    var password: String? // Password to join Lobby
}

struct CreateLobbyResponse {
    var playerId: Int
    var lobbyId: Int
}


// SHOW LOBBY
struct ShowLobbyResponse {
    var name: String // Lobbyname
    var count: Int // Number of players in lobby
    var hasPassword: Bool  // if lobby has password
}

struct ShowLobbyDetailsResponse {
    var lobbyName: String
    var master: Int
    var players: Array<Player>
}


// JOIN LOBBY
struct JoinLobbyRequest {
    var lobbyId: Int
    var nickName: String
    var password: String?
}

struct JoinLobbyResponse {
    var playerId: Int
}


// LEAVE LOBBY
struct LeaveLobbyRequest {
    var playerId: Int
    var lobbyId: Int
}


// WS
struct Event {
    var eventName: String // Which thingy has updated
    var primaryKey: Int? // primary key of thingy
}