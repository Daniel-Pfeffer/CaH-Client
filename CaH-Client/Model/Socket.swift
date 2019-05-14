//
// Created by Daniel Pfeffer on 2019-05-06.
// Copyright (c) 2019 at.htl-leonding. All rights reserved.
//

import Foundation

// STANDARD THINGYS
class ConnectionManager: NSObject {

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
                    let decoded = try? decoder.decode(ShowLobbyDetailsResponse.self, from: data)
                    print("Decoded: \(decoded)")
                    // TODO: send to model
                }
            }
        }
        task.resume();
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
                    let decoded = try? decoder.decode(ShowLobbyResponse.self, from: data)
                    print("Decoded: \(decoded)")
                    // TODO: sent to model
                }
            }
        }
        task.resume()
    }
}

// HANDLES POST
extension ConnectionManager {
    func createLobby(body: CreateLobbyRequest) throws {
        var decoded: CreateLobbyResponse?
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
                    decoded = try! decoder.decode(CreateLobbyResponse.self, from: data)
                    print(decoded)
                }
            }
        }
        task.resume()
        //return decoded!
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
                // WORKS DUNNO WHAT TO DO
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
        print(String(data: data, encoding: .utf8))
        request.httpBody = data
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, res: URLResponse?, error: Error?) in
            if let error = error {
                print("Error: \(error)")
            } else {
                if let data = data {
                    let decoder = JSONDecoder()
                    let decoded = try! decoder.decode(JoinLobbyResponse.self, from: data)
                    DispatchQueue.main.async {
                        return decoded
                    }
                }
            }
        }
        task.resume()
    }
}
