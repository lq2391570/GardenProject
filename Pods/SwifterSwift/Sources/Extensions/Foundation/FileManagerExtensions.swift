//
//  FileManagerExtensions.swift
//  SwifterSwift
//
//  Created by Jason Jon E. Carreos on 05/02/2018.
//  Copyright © 2018 SwifterSwift
//

import Foundation

public extension FileManager {
    
    /// SwifterSwift: Read from a JSON file at a given path.
    ///
    /// - Parameters:
    ///   - path: JSON file path.
    ///   - options: JSONSerialization reading options.
    /// - Returns: Optional dictionary.
    /// - Throws: Throws any errors thrown by Data creation or JSON serialization.
    public func jsonFromFile(atPath path: String,
                             readingOptions: JSONSerialization.ReadingOptions = .allowFragments) throws -> [String: Any]? {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let json = try JSONSerialization.jsonObject(with: data, options: readingOptions)
        
        return json as? [String: Any]
    }
    
    /// SwifterSwift: Read from a JSON file with a given filename.
    ///
    /// - Parameters:
    ///   - filename: File to read.
    ///   - bundleClass: Bundle where the file is associated.
    ///   - readingOptions: JSONSerialization reading options.
    /// - Returns: Optional dictionary.
    /// - Throws: Throws any errors thrown by Data creation or JSON serialization.
    public func jsonFromFile(withFilename filename: String,
                             at bundleClass: AnyClass? = nil,
                             readingOptions: JSONSerialization.ReadingOptions = .allowFragments) throws -> [String: Any]? {
        // https://stackoverflow.com/questions/24410881/reading-in-a-json-file-using-swift
        
        // To handle cases that provided filename has an extension
        let name = filename.components(separatedBy: ".")[0]
        let bundle = bundleClass != nil ? Bundle(for: bundleClass!) : Bundle.main
        
        if let path = bundle.path(forResource: name, ofType: "json") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let json = try JSONSerialization.jsonObject(with: data, options: readingOptions)
            
            return json as? [String: Any]
        }
        
        return nil
    }
    
}
