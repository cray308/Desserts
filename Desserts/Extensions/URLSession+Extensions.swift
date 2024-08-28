//
//  URLSession+Extensions.swift
//  Desserts
//
//  Created by Chris Ray on 8/25/24.
//

import Foundation

extension URLSession {
    func fetchData<T: Decodable>(from url: URL) async throws -> T {
        do {
            let (data, response) = try await data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw DessertsError.failedRequest
            }

            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw DessertsError.unexpected(error)
        }
    }
}
