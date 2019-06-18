//
// Created by Daniel Pfeffer on 2019-05-06.
// Copyright (c) 2019 at.htl-leonding. All rights reserved.
//

import Foundation
import Starscream

// STANDARD THINGYS
class ConnectionManager: NSObject {
    weak var delegate: ListenOnResponse?
    let path: String
    var socket: WebSocket? = nil

    init(path: String) {
        self.path = path
        self.socket = WebSocket(url: URL(string: path + "ws")!)
    }

    func connectSocket() {
        self.socket?.delegate = self
        self.socket?.callbackQueue = DispatchQueue(label: "SocketCallback")
        self.socket?.connect()
    }
}

// HANDLES REST
extension ConnectionManager {

    func showLobby(id: Int) {
        let url: URL = URL(string: (self.path + "rest/getLobby/" + String(id)))!

        var req: URLRequest = URLRequest(url: url)
        req.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: req) { (data: Data?, res: URLResponse?, error: Error?) in
            if let error = error {
                print("Error: \(error)")
            } else {
                if let data = data {
                    let decoder = JSONDecoder()
                    let decoded = try? decoder.decode(GetLobbyResponse.self, from: data)
                    self.delegate!.hasReceived(res: decoded, req: "")
                }
            }
        }
        task.resume();
    }

    func example() {
        let url: URL = URL(string: (self.path + "rest/example"))!

        var req: URLRequest = URLRequest(url: url)
        req.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: req) { (data: Data?, res: URLResponse?, error: Error?) in
            self.delegate?.hasReceived(res: "Example called", req: "HI")
        }
        task.resume()
    }

    func showLobbies() {
        let url: URL = URL(string: (self.path + "rest/getLobbies"))!

        var req: URLRequest = URLRequest(url: url)
        req.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: req) { (data: Data?, res: URLResponse?, error: Error?) in
            if let error = error {
                print("Error: \(error)")
            } else {
                if let data = data {
                    let decoder = JSONDecoder()
                    let decoded = try? decoder.decode(Array<GetLobbiesResponse>.self, from: data)
                    self.delegate!.hasReceived(res: decoded, req: "")
                }
            }
        }
        task.resume()
    }

    func startGame(lobbyId: Int) {
        let url: URL = URL(string: (self.path + "rest/startGame/" + String(lobbyId)))!
        var req: URLRequest = URLRequest(url: url)
        req.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: req) { (data: Data?, res: URLResponse?, error: Error?) in
            if let error = error {
                print("Error: \(error)")
            } else {
                if data != nil {
                    self.delegate!.hasReceived(res: true, req: "")
                }
            }
        }
        task.resume()
    }

    func getRandomCards() {
        let url: URL = URL(string: (self.path + "rest/getRandomCards"))!
        var req: URLRequest = URLRequest(url: url)
        req.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: req) { (data: Data?, res: URLResponse?, error: Error?) in
            if let error = error {
                print("Error: \(error)")
            } else {
                if let data = data {
                    let decoder = JSONDecoder()
                    let decoded = try? decoder.decode(Array<String>.self, from: data)
                    self.delegate?.hasReceived(res: decoded, req: "")
                }
            }
        }
        task.resume()
    }
}

// HANDLES POST
extension ConnectionManager {
    func createLobby(body: CreateLobbyRequest) throws {
        let url: URL = URL(string: (self.path + "rest/createLobby"))!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data: Data = try encoder.encode(body)
        print(String(data: data, encoding: .utf8))
        request.httpBody = data
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data: Data?, res: URLResponse?, error: Error?) in
            if let error = error {
                print("Error: \(error)")
            } else {
                if let data = data {
                    let decoder = JSONDecoder()
                    let decoded = try! decoder.decode(CreateLobbyResponse.self, from: data)
                    self.delegate!.hasReceived(res: decoded, req: body)
                }
            }
        }
        task.resume()
    }

    func leaveLobby(body: LeaveLobbyRequest) throws {
        let url: URL = URL(string: (self.path + "rest/leaveLobby"))!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data: Data = try encoder.encode(body)
        print(String(data: data, encoding: .utf8))
        request.httpBody = data
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, res: URLResponse?, error: Error?) in
            if let error = error {
                print("Error: \(error)")
            } else {
            }
        }
        task.resume()
    }

    func joinLobby(body: JoinLobbyRequest) throws {
        let url: URL = URL(string: (self.path + "rest/joinLobby"))!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data: Data = try encoder.encode(body)
        print("Join LOBBY: \(String(data: data, encoding: .utf8))")
        request.httpBody = data
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data: Data?, res: URLResponse?, error: Error?) in
            if let error = error {
                print("Error: \(error)")
            } else {
                if let resp: HTTPURLResponse = res as? HTTPURLResponse {
                    if resp.statusCode != 401 {
                        if let data = data {
                            let decoder = JSONDecoder()
                            let decoded = try! decoder.decode(JoinLobbyResponse.self, from: data)
                            self.delegate!.hasReceived(res: decoded, req: body)
                        }
                    }
                }

            }
        }
        task.resume()
    }
}

// HANDLES WS
extension ConnectionManager: WebSocketDelegate {
    public func websocketDidConnect(socket: WebSocketClient) {
        print("Hello El Sôrvõr")
    }

    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("Bye eš Śõrvêr")
    }

    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Rèçīèvėd \(text)")
    }

    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
    }
}
