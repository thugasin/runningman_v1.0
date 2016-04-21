//
//  File.swift
//  RunningMan_1.0
//
//  Created by Sirius on 16/2/16.
//  Copyright © 2016年 Sirius. All rights reserved.
//

import Foundation

class ImangeHandler:NSObject
{
    static func InitImageHandler()->(Void)
    {
        let path: String = NSBundle.mainBundle().pathForResource("ImageMap", ofType: "json", inDirectory: "Configure")!
        let nsUrl = NSURL(fileURLWithPath: path)
        var nsData: NSData = NSData(contentsOfURL: nsUrl)!
        
        var error: NSError?
        
        let jsonDict = NSJSONSerialization.JSONObjectWithData(nsData, options: nil, error: &error)
    }
    
}