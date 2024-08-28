//
//  Bundle+Extensions.swift
//  Desserts
//
//  Created by Chris Ray on 8/27/24.
//

import Foundation

extension Bundle {
    func loadFile<T: Decodable>(_ filename: String) -> T? {
        guard let file = url(forResource: filename, withExtension: "json"),
              let data = try? Data(contentsOf: file) else {
            return nil
        }

        return try? JSONDecoder().decode(T.self, from: data)
    }
}
