//
// Created by Daniel Pfeffer on 2019-05-06.
// Copyright (c) 2019 at.htl-leonding. All rights reserved.
//

import Foundation


class ConnectionManager: NSObject {

    let path: String

    init(path: String) {
        self.path = path
    }

    func sendRest(path: String, body: CreateLobbyRequest) {

    }
}
