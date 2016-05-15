//
//  Connector.swift
//  GitHub
//
//  Created by Leonard Lamprecht on 15/05/16.
//  Copyright © 2016 Leo Lamprecht. All rights reserved.
//

import UIKit

enum AuthorizingError: ErrorType {
    case InvalidURL
    case InvalidTokenRequest
    case CannotLoadToken
}

let defaults = NSUserDefaults.standardUserDefaults()

class Connector: NSObject {
    
    let clientId: String = "0fe88ac59c5d6d50642a"
    let clientSecret: String = "43b9c296bde038f9efbed594556cf0ac6e137a8c"
    
    func generateURL(parts: Dictionary<String, String>, path: String) -> (main: NSURL?, body: String, full: NSURL?) {
        var urlParts = parts
        urlParts["client_id"] = clientId
        
        let main = "https://github.com/login/oauth/" + path
        let body = urlParts.urlEncodedQueryString()
        
        let full = main + "?" + body
  
        return (NSURL(string: main), body, NSURL(string: full))
    }
    
    func buildWebFlow() throws -> NSURLRequest {
        let urlParts: [String:String] = [
            "redirect_uri": "github://authenticated",
            "scope": scopes.joinWithSeparator(" "),
            "state": String.random()
        ]
        
        guard let url = generateURL(urlParts, path: "authorize").full else {
            throw AuthorizingError.InvalidURL
        }
        
        return NSURLRequest(URL: url)
    }
    
    func requestAccessToken(code: String, state: String) throws {
        let queryItems: [String:String] = [
            "client_secret": clientSecret,
            "code": code
        ]
        
        let urlParts = generateURL(queryItems, path: "access_token")
        
        guard let url = urlParts.main else {
            throw AuthorizingError.InvalidURL
        }
        
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = urlParts.body.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            guard error == nil && data != nil else {
                fatalError("error=\(error)")
            }
        
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String
            let params = responseString?.parametersFromQueryString()
            
            guard let token = params?["access_token"] else {
                fatalError("Not able to unwrap token")
            }

            appDelegate.token = token
        }
        
        task.resume()
    }

    func loadUser(completion: ((json: [String : AnyObject]) -> Void)!) throws {
        let urlString = "https://api.github.com/user"
        
        guard let url = NSURL(string: urlString) else {
            throw AuthorizingError.InvalidURL
        }
        
        guard let token = defaults.stringForKey("api_token") else {
            throw AuthorizingError.CannotLoadToken
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.addValue("token " + token, forHTTPHeaderField: "Authorization")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            guard error == nil && data != nil else {
                fatalError("error=\(error)")
            }
            
            guard let jsonString = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String else {
                fatalError()
            }
            
            let jsonData = jsonString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)
                completion(json: json as! [String : AnyObject])
            } catch {
                fatalError(String(error))
            }
        }
        
        task.resume()
    }
    
}
