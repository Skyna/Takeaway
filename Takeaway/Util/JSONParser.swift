//
//  JSONParser.swift
//  Takeaway
//
//  Created by Emre Akman on 13/03/2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import Foundation
import UIKit

public class JSONParser {
    
    enum ParseError : Error{
        case fileNotFound
        case cannotOpenFile
        case cannotParseJson
    }
    
    public static func parse<T : Decodable>(_ fileName : String) throws -> T{
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            throw ParseError.fileNotFound
        }
        
        let url = URL(fileURLWithPath: path)
        
        guard UIApplication.shared.canOpenURL(url) else {
            throw ParseError.cannotOpenFile
        }
        
        do {
            let data = try Data(contentsOf: url, options: .alwaysMapped)
            let dictionary = try JSONDecoder().decode(T.self, from: data)
            return dictionary
        } catch {
            throw error
        }
    }
}
