//
//  Storage.swift
//  Takeaway
//
//  Created by Emre Akman on 15/03/2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import Foundation


public class Storage {
    fileprivate init() { }
    
    static func store<T: Encodable>(_ object: T, fileName: String) {
        guard let urlCache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return
        }
        
        let url = urlCache.appendingPathComponent(fileName, isDirectory: false)
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func remove(_ fileName: String) {
        guard let urlCache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        
        let url = urlCache.appendingPathComponent(fileName, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    static func fileExists(_ fileName: String) -> Bool {
        guard let urlCache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return false }
        
        let url = urlCache.appendingPathComponent(fileName, isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }
}
