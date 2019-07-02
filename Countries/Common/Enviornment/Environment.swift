//
//  Environment.swift
//  MyCard2.0
//
//  Created by Pooja Bohora on 29/01/19.
//  Copyright © 2019 Pooja Bohora. All rights reserved.
//  Used to read from various environments


import Foundation

/// This is enum for the manage the flavor
///
/// - serverURL: Server URL
/// - isLogEnable: isLogenable
/// - ConnectionProtocol: connection protocol
public enum PlistKey {
    case serverURL
   
    func value() -> String {
        switch self {
        case .serverURL:
            return "serverURL"
        }
    }
}

/// This method is used to set the enviornment
public struct Environment {
    
    fileprivate var infoDict: [String: Any]  {
        get {
            if let dict = Bundle.main.infoDictionary {
                return dict
            }else {
                fatalError("Plist file not found")
            }
        }
    }
    
    /// This method is used to set the configuration
    ///
    /// - Parameter key: plist
    /// - Returns: string
    public func configuration(_ key: PlistKey) -> String {
        switch key {
        case .serverURL:
            return infoDict[PlistKey.serverURL.value()] as! String
       
        }
    }
}
