//
//  Constants.swift
//  Countries
//
//  Created by Pooja Bohora on 28/06/19.
//  Used to maintain required constant at one place

import UIKit

/// This is enum is used to set the priority of api calling
///
/// - veryLow: This is for very low netowk speed
/// - low: This is for low netowk speed
/// - normal: This is for normal netowk speed
/// - high: This is for high netowk speed
/// - veryHigh: This is for very high netowk speed
public enum TaskPriority : Int {
    case veryLow = 0
    case low = 1
    case normal = 2
    case high = 3
    case veryHigh = 4
}

class Constants: NSObject {

    static let shared = Constants()
    let savedContries = "savedContries"
    let countryAPI = "rest/v2/name"
}
