//
//  Extensions.swift
//  Hub
//
//  Created by Leo Lamprecht on 16/05/16.
//  Copyright © 2016 Leo Lamprecht. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideView() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension String {

    func urlEncodedString() -> String {
        let allowedCharacterSet = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
        allowedCharacterSet.removeCharactersInString("\n:#/?@!$&'()*+,;=")
        allowedCharacterSet.addCharactersInString("[]")
        return self.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet)!
    }

    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.startIndex.advancedBy(Int(randomValue))])"
        }

        return randomString
    }

    func parametersFromQueryString() -> Dictionary<String, String> {
        var parameters = Dictionary<String, String>()

        let scanner = NSScanner(string: self)

        var key: NSString?
        var value: NSString?

        while !scanner.atEnd {
            key = nil
            scanner.scanUpToString("=", intoString: &key)
            scanner.scanString("=", intoString: nil)

            value = nil
            scanner.scanUpToString("&", intoString: &value)
            scanner.scanString("&", intoString: nil)

            if let key = key as? String, let value = value as? String {
                parameters.updateValue(value, forKey: key)
            }
        }

        return parameters
    }

}

extension Dictionary {

    func urlEncodedQueryString() -> String {
        var parts = [String]()

        for (key, value) in self {
            let newValue: String = "\(value)".stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)

            let keyString: String = "\(key)".urlEncodedString()
            let valueString: String = "\(newValue)".urlEncodedString()
            let query: String = "\(keyString)=\(valueString)"

            parts.append(query)
        }

        return parts.joinWithSeparator("&")
    }

}