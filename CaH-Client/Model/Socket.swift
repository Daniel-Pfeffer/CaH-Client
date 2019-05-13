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

    func sendPost(path: String, body: Any) {
        let url: URL = URL(string: (self.path + path))!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody: Data = try? JSONSerialization.data(withJSONObject: body) else {
            return
        }
        request.httpBody = httpBody
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

    func parse() {

    }
}
