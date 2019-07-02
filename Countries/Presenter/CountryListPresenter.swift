//
//  CountryListPresenter.swift
//  Countries
//
//  Created by Pooja Bohora on 28/06/19.
//  Used to call API for searching country

import UIKit

class CountryListPresenter: RequestManager {

    
    /// Calls API to get country list for given search key
    ///
    /// - Parameters:
    ///   - searchKey: search key
    ///   - completion: completion handler
    func getCountries(searchKey : String ,completion:@escaping (_ result: ([Country]?), _ error: Bool)->Void)
    {
        var countries : [Country]?
        
        let endURL = Environment().configuration(PlistKey.serverURL)

        let url = endURL + "/"  + Constants.shared.countryAPI + "/" + searchKey

        getRequest(url, header: nil) { (response, error) in
            
            if let result = response as? Array<[String : AnyObject]>
            {
                let resultWithKey = ["data" : result]
                let parsedResult = self.parseResponse(className: CountryList.self, response: resultWithKey as [String : AnyObject])
                if let data = parsedResult.object?.countries{
                    countries = [Country]()
                    countries?.append(contentsOf: data)
                    completion(countries,false)
                }
            }
            completion(countries,true)
        }
    }
    
    
    /// Saves country locally
    ///
    /// - Parameter country: country to be saved
    func saveCountry(country : Country)
    {
        var countries : [Country]?
        if let savedCountries = getSavedCountries(){
            countries = [Country]()
            countries?.append(contentsOf: savedCountries)
            countries?.append(country)
        }
        else{
            countries = [Country]()
            countries?.append(country)
        }
        let userDefaults = UserDefaults.standard
        let encodedData = NSKeyedArchiver.archivedData( withRootObject: countries!)
        userDefaults.set(encodedData, forKey: Constants.shared.savedContries)

        userDefaults.synchronize()
    }
    
    
    /// Search in locally saved county list
    ///
    /// - Parameter forText: country key to search
    /// - Returns: boolean for search
    func getCounties(forText : String)-> [Country]?{
        if let savedCountries = getSavedCountries(){
            return  savedCountries.filter({ $0.name?.lowercased().contains(forText.lowercased()) == true})
        }
        return nil
    }
    
    /// Gets saved countries
    ///
    /// - Returns: array of saved country
    func getSavedCountries() -> [Country]?
    {
        let userDefaults = UserDefaults.standard
        if let decoded  = userDefaults.object(forKey: Constants.shared.savedContries) as? Data{
            return NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [Country]
        }
        return nil
    }
    
    
    /// Checks if given county is already saved or not
    ///
    /// - Parameter country: country to check
    /// - Returns: true , false based on result
    func checkIfSaved(country : Country) -> Bool{
        
        if let savedCountries = getSavedCountries()
        {
            if savedCountries.contains(where: {$0.name == country.name})
            {
                return true
            }
        }
        return false

    }
}
