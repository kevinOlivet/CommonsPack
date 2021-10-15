//
//  APIVerbs.swift
//
//

import Foundation

// MARK: - VERBS
extension APIManager {
    public func get<T:Codable>(uri:String, completion: @escaping (Result<T,APIManagerError>) -> ()) {

        guard let url = URL(string: "\(self.BASE)\(uri)") else {
            return completion(.failure(.init(.ERROR_URL)))
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        self.request(request: request,  completion: completion)
    }

    public func post<T:Codable>(uri: String, params: [String : Any], completion: @escaping (Result<T, APIManagerError>) -> ()) {

        guard let url = URL(string: "\(self.BASE)\(uri)") else {
            return completion(.failure(.init(.ERROR_URL)))
        }

        var request = URLRequest(url: url)

        guard let data = try? JSONSerialization.data(withJSONObject: params, options: .init()) else {
            completion(.failure(.init(.NO_PARAMS)))
            return
        }
        request.httpBody = data
        request.httpMethod = "POST"

        self.request(request: request, completion: completion)

    }

    public func put<T:Codable>(uri: String, params: [String : Any], completion: @escaping (Result<T, APIManagerError>) -> ()) {

        guard let url = URL(string: "\(self.BASE)\(uri)") else {
            return completion(.failure(.init(.ERROR_URL)))
        }

        var request = URLRequest(url: url)

        guard let data = try? JSONSerialization.data(withJSONObject: params, options: .init()) else {
            completion(.failure(.init(.NO_PARAMS)))
            return
        }
        request.httpBody = data
        request.httpMethod = "PUT"

        self.request(request: request, completion: completion)

    }

    public func delete<T>(uri: String, completion: @escaping (Result<T, APIManagerError>) -> ()) where T : Decodable, T : Encodable {
        guard let url = URL(string: "\(self.BASE)\(uri)") else {
            return completion(.failure(.init(.ERROR_URL)))
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        self.request(request: request,  completion: completion)
    }
}



// MARK: - Private funcs
extension APIManager {
    func request<T:Codable>(request: URLRequest, completion: @escaping (Result<T,APIManagerError>) -> ()) {

        var r = request
        r.setValue("application/json", forHTTPHeaderField: "Content-Type")

        for  p in self.getHeaders() {
            r.setValue(p.value, forHTTPHeaderField: p.key)
        }


        DispatchQueue.global(qos: .utility).async {
            URLSession.shared.dataTask(with: r) { data, response, error in
                let statusCode = "\((response as? HTTPURLResponse)?.statusCode ?? 500)"
                DispatchQueue.main.async {
                    guard let data = data else {
                        completion(.failure(.init(.BACKEND_ERROR, statusCode)))
                        return
                    }
                    guard let decode =  try? JSONDecoder().decode(T.self, from: data) else {
                        completion(.failure(.init(.DECODE_ERROR, statusCode)))
                        return
                    }
                    completion(.success(decode))
                }
            }.resume()
        }
    }
}
