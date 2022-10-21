//
//  String+Extension.swift
//  AsyncAwaitPOC
//
//  Created by Ashok Rawat on 04/10/22.
//

import Foundation

extension String
{
    mutating func replace(_ originalString:String, with newString:String) {
        self = self.replacingOccurrences(of: originalString, with: newString)
    }
}
