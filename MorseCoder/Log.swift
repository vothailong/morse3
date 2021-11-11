//
//  Log.swift
//  IDareU
//
//  Created by Dung Do on 6/19/19.
//  Copyright © 2019 Dung Do. All rights reserved.
//

import Foundation

struct Log {
    
    static func debug(_ message: Any, filePath: String = #file, function: String = #function, line: Int = #line) {
        #if !PRO
        let fileName = filePath.components(separatedBy: "/").last!
        print("🔵\(fileName)" + "_" + "\(function)[line \(line)]: \(message)🔵")
        #endif
    }
    
    static func error(_ message: Any, filePath: String = #file, function: String = #function, line: Int = #line) {
        #if !PRO
        let fileName = filePath.components(separatedBy: "/").last!
        print("🔴ERROR FILTER: \(fileName)" + "_" + "\(function)[line \(line)]: \(message)🔴")
        #endif
    }
    
}
