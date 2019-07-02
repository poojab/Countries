//
//  RequestManager.swift
//  Countries
//
//  Created by Pooja Bohora on 28/06/19.
//  Copyright © 2018 Pooja Bohora. All rights reserved.
//  Used to create a post/get request using given parameters

import UIKit
import Alamofire

class RequestManager: NSObject {
    
    /// Intiates post API call
    ///
    /// - Parameters:
    ///   - url: request URL
    ///   - params: API parameters
    ///   - header: API header if any
    ///   - completion: completion block
    func postRequest(_ url:String,params:[String:AnyObject]?,header:[String:String]?,completion:@escaping (_ response:AnyObject? ,_ error:AnyObject?)->Void)
    {
        //Request with given parameters
        Alamofire.request(url, method:.post, parameters: params!, encoding: JSONEncoding.default, headers: header).responseJSON { (Response) in
            completion(Response.result.value as AnyObject, "" as AnyObject)
        }
    }
    
    
    /// Intiates get API call
    ///
    /// - Parameters:
    ///   - url: Request URL
    ///   - header: API header if any
    ///   - completion: completion block
    func getRequest(_ url:String,header:[String:String]?,completion:@escaping (_ response:AnyObject? ,_ error:AnyObject?)->Void)
    {
        //Request for get API
        Alamofire.request(url, method:.get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (Response) in
            completion(Response.result.value as AnyObject, "" as AnyObject)
        }
    }
    
    /// To parse the response
    ///
    /// - Parameters:
    ///   - className: class Entity parse
    ///   - response: response to parse
    /// - Returns: return the parsed entity
    public func parseResponse<T:Decodable>(className:T.Type, response:[String: AnyObject])->(success:Bool,object:T?)
    {
        
        guard let data = try? JSONSerialization.data(withJSONObject: response) else {
            return (false,nil)
        }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(T.self, from: data)
            return (true,object)
        }
        catch {
            
            return (false,nil)
        }
    }
}
