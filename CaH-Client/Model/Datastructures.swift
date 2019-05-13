//
// Created by Daniel Pfeffer on 2019-05-07.
// Copyright (c) 2019 at.htl-leonding. All rights reserved.
//

import Foundation

struct CreateLobbyRequest {
    var name: String // Lobbyname
    var userName: String // Username
    var password: String // Password to join Lobby
}

struct Event {
    var eventName: String // Which thingy has updated
    var primaryKey: Int // primary key of thingy
}

struct ShowLobbiesResponse {
    var name: String // Lobbyname
    var count: Int // Number of players in lobby
    var hasPassword: Bool  // if lobby has password
}
