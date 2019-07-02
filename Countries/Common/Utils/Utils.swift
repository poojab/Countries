//
//  Utils.swift
//  Countries
//
//  Created by Pooja Bohora on 28/06/19.
//

import UIKit
import SDWebImageSVGCoder
import Reachability

class Utils: NSObject {
    
    static let shared = Utils()
    let queue = OperationQueue()
    var  operation = BlockOperation()
    /// Function to convert String to dictionary
    ///
    /// - Parameter text: string
    /// - Returns: dict
    public func convertToDictionary(str: String) -> [String: AnyObject] {
        if let data = str.data(using: .utf8) {
            do {
                return (try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject])!
            } catch {
                
            }
        }
        return [String: AnyObject]()
    }
    
    
    /// Sets SVG image asycnhronously
    ///
    /// - Parameters:
    ///   - url: url
    ///   - imageView: imageview to which image to be set
    func setImage(url:URL,imageView:UIImageView)
    {
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
        operation = BlockOperation(block: {
            OperationQueue.main.addOperation({ () -> Void in
            imageView.sd_setImage(with: url, placeholderImage: nil, options: [], context: [.svgImageSize : imageView.frame.size])

        })
        })
        operation.queuePriority = Operation.QueuePriority(rawValue: TaskPriority.normal.rawValue)!
        queue.addOperation(operation)
    }
    
    
    /// Checks if network is available
    ///
    /// - Returns: boolean for result
    func isNetworkAvailable()->Bool{
        let reachability = Reachability()!
        if reachability.connection != .none{
            return true
        }
        return false
    }
}
