//
//  Models.swift
//  Models
//
//  Created by Pooja Bohora on 28/06/19.
//  Copyright © 2019 Pooja Bohora. All rights reserved.
//  This is class of models to declare all the common method which is require for the model for parsing



import UIKit

/// This class is used to for models related methods
public class Models {
    public static let shared = Models()
}

// MARK: - extension KeyedDecodingContainer which takes default value if not present
public extension KeyedDecodingContainer {
    func decodeWrapper<T>(key: K, defaultValue: T) throws -> T
        where T : Decodable {
            return try decodeIfPresent(T.self, forKey: key) ?? defaultValue
    }
}

/// this is to initialise keys of JSON
struct JSONCodingKeys: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}


// MARK: - Below extension is to check type of json like array  / dictionary
// the encoded properties of a decodable type accessible by keys
extension KeyedDecodingContainer {
    
    /// This method is used to decode for decodable class
    ///
    /// - Parameters:
    ///   - type: decodable class
    ///   - key: key
    /// - Returns: data
    /// - Throws: error
    func decode(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any> {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }
    
    /// This method is used to decode the decodable if present
    ///
    /// - Parameters:
    ///   - type: decodatble class
    ///   - key: key
    /// - Returns: data
    /// - Throws: error
    func decodeIfPresent(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }
    
    /// This method is used to decode the decodable class
    ///
    /// - Parameters:
    ///   - type: type
    ///   - key: key
    /// - Returns: data
    /// - Throws: error
    func decode(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any> {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }
    
    /// This method is used to decode the decodable class
    ///
    /// - Parameters:
    ///   - type: type
    ///   - key: key
    /// - Returns: data
    /// - Throws: error
    func decodeIfPresent(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }
    
    /// This method is used to decode the decodable class
    ///
    /// - Parameters:
    ///   - type: type
    ///   - key: key
    /// - Returns: data
    /// - Throws: error
    func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()
        
        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }
}
// MARK: - Below extension is to check type of json like array  / dictionary
extension UnkeyedDecodingContainer {
    
    /// This method is used to decode the container
    ///
    /// - Parameter type: type
    /// - Returns: data
    /// - Throws: error
    mutating func decode(_ type: Array<Any>.Type) throws -> Array<Any> {
        var array: [Any] = []
        while isAtEnd == false {
            // See if the current value in the JSON array is `null` first and prevent infite recursion with nested arrays.
            if try decodeNil() {
                continue
            } else if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode(Array<Any>.self) {
                array.append(nestedArray)
            }
        }
        return array
    }
    
    /// This method is usd to decode the container value
    ///
    /// - Parameter type: type
    /// - Returns: data
    /// - Throws: error
    mutating func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        
        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}
