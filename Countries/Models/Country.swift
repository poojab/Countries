//
//  Country.swift
//  Countries
//
//  Created by Pooja Bohora on 28/06/19.
// Country model

import UIKit

class CountryList : Codable{
    
    let countries : [Country]?

    private enum CodingKeys: String,CodingKey {
        case countries = "data"
    }
    required public init(from decoder:Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        countries = try container.decodeWrapper(key: .countries, defaultValue: nil)
    }
}
class Country: NSObject, Codable,NSCoding {
    //Required to store in user defaults
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(flag, forKey: "flag")
        aCoder.encode(region, forKey: "region")
        aCoder.encode(subregion, forKey: "subregion")
        aCoder.encode(capital, forKey: "capital")
        aCoder.encode(population, forKey: "population")

    }
    
    required init?(coder aDecoder: NSCoder) {
        population = aDecoder.decodeObject(forKey: "population") as? Int ?? aDecoder.decodeInteger(forKey: "population")
        name = aDecoder.decodeObject(forKey: "name") as? String
        flag = aDecoder.decodeObject(forKey: "flag") as? String
        region = aDecoder.decodeObject(forKey: "region") as? String
        subregion = aDecoder.decodeObject(forKey: "subregion") as? String
        capital = aDecoder.decodeObject(forKey: "capital") as? String

    }
    
    
    //MARK:- Variable declration
    let name:String?
    let capital:String?
    let flag:String?
    let region : String?
    let subregion : String?
    let population : Int?
    
    required public init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decodeWrapper(key: .name, defaultValue: nil)
        capital = try container.decodeWrapper(key: .capital, defaultValue: nil)
        flag = try container.decodeWrapper(key: .flag, defaultValue: nil)
        subregion = try container.decodeWrapper(key: .subregion, defaultValue: nil)
        population = try container.decodeWrapper(key: .population, defaultValue: nil)
        region = try container.decodeWrapper(key: .region, defaultValue: nil)

    }
}
