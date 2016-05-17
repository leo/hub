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

let scopes = [
    "user",
    "public_repo",
    "repo",
    "delete_repo",
    "gist",
    "admin:repo_hook",
    "admin:org_hook",
    "admin:org",
    "admin:public_key",
    "admin:gpg_key"
]

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
    
    func buildWebFlow() throws -> NSURL? {
        let urlParts: [String:String] = [
            "redirect_uri": "github://authenticated",
            "scope": scopes.joinWithSeparator(" "),
            "state": String.random()
        ]
        
        guard let url = generateURL(urlParts, path: "authorize").full else {
            throw AuthorizingError.InvalidURL
        }
        
        return url
    }
    
    func requestAccessToken(code: String, state: String, completion: (() -> Void)!) throws {
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
            completion()
        }
        
        task.resume()
    }

    func loadDataOfCurrentUser(kind: String, completion: ((data: AnyObject) -> Void)!) throws {
        let urlString = "https://api.github.com/user/" + kind + "?sort=pushed"

        guard let url = NSURL(string: urlString) else {
            throw AuthorizingError.InvalidURL
        }

        guard let token = appDelegate.token else {
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

            guard let jsonData = jsonString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true) else {
                fatalError()
            }

            do {
                let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)

                if let message = json["message"] {
                    if message as! String == "Bad credentials" {
                        self.restartApp()
                    }
                } else {
                    completion(data: json)
                }
            } catch {
                fatalError(String(error))
            }
        }

        task.resume()
    }

    func restartApp() {
        defaults.removeObjectForKey("api_token")
        defaults.synchronize()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        appDelegate.window?.rootViewController = storyboard.instantiateInitialViewController()
    }

}
