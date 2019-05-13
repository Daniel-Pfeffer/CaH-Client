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

    //WORKS
    func sendGet(path: String/*, body: CreateLobbyRequest?*/) {
        print("na du")
        let url: URL = URL(string: (self.path + path))!

        let queue: DispatchQueue = DispatchQueue(label: "REST")
        queue.async {
            if let data = try? Data(contentsOf: url) {
                if let obj = try? JSONSerialization.jsonObject(with: data) {
                    DispatchQueue.main.async {
                        return obj
                    }
                }
            }
        }
    }

    //IN PRODUCTION
    func sendPost(path: String, body: CreateLobbyRequest) throws {
        let url: URL = URL(string: (self.path + path))!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(body)
        print(String(data: data, encoding: .utf8))
        request.httpBody = data
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, res: URLResponse?, error: Error?) in
            if let error = error {
                print("Error: \(error)")
            } else {
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Data: \(dataString)")
                }
            }
        }
        task.resume()
    }

}
