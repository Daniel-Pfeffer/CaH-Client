//
// Created by Daniel Pfeffer on 2019-05-06.
// Copyright (c) 2019 at.htl-leonding. All rights reserved.
//

import Foundation

// STANDARD THINGYS
class ConnectionManager: NSObject {
    weak var delegate: ListenOnResponse?
    let path: String

    init(path: String) {
        self.path = path
    }

}

// HANDLES REST
extension ConnectionManager {

    func showLobby(id: Int) {
        let url: URL = URL(string: (self.path + "/getLobby/" + String(id)))!

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
        let url: URL = URL(string: (self.path + "/example"))!

        var req: URLRequest = URLRequest(url: url)
        req.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: req) { (data: Data?, res: URLResponse?, error: Error?) in
            self.delegate?.hasReceived(res: "Example called", req: "HI")
        }
        task.resume()
    }

    func showLobbies() {
        let url: URL = URL(string: (self.path + "/getLobbies"))!

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
        let url: URL = URL(string: (self.path + "/startGame/" + String(lobbyId)))!
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
        let url: URL = URL(string: (self.path + "/getRandomCards"))!
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
        let url: URL = URL(string: (self.path + "/createLobby"))!
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
        let url: URL = URL(string: (self.path + "/leaveLobby"))!
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
        let url: URL = URL(string: (self.path + "/joinLobby"))!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data: Data = try encoder.encode(body)
        print("Join LOBBY: \(String(data: data, encoding: .utf8))")
        request.httpBody = data
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, res: URLResponse?, error: Error?) in
            if let error = error {
                print("Error: \(error)")
            } else {
                if let data = data {
                    let decoder = JSONDecoder()
                    let decoded = try! decoder.decode(JoinLobbyResponse.self, from: data)
                    self.delegate!.hasReceived(res: decoded, req: body)
                }
            }
        }
        task.resume()
    }
}
