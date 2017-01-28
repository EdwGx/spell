//
//  Version.swift
//  spell
//
//  Created by Edward Guo on 2017-01-28.
//  Copyright © 2017 Pei Liang Guo. All rights reserved.
//

import Foundation

struct Version: CustomStringConvertible {
    let major: Int
    let minor: Int
    let tiny: Int?
    
    var description: String {
        if tiny != nil {
            return "\(major).\(minor).\(tiny!)"
        } else {
            return "\(major).\(minor)"
        }
    }
}
