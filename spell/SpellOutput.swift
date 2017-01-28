//
//  SpellOutput.swift
//  spell
//
//  Created by Edward Guo on 2017-01-28.
//  Copyright © 2017 Pei Liang Guo. All rights reserved.
//

import Foundation

class SpellOutput {
    static let endl = "\n"
    
    
    static let positiveResponds = ["Correct!", "Perfect!", "100%", "Bingo!", "That is right.",
                                   "LGTM", "95.46% Confident"]
    
    static func printPositiveFeedback() {
        let randomIndex = Int(arc4random_uniform(UInt32(positiveResponds.count)))
        print(positiveResponds[randomIndex])
    }
    
    static func printOrderedList(_ list: [String]) {
        for i in 0..<list.count {
            print("\(i+1). \(list[i])")
        }
    }
    
    static func printUnderline(string: String, underline: Range<String.Index>, suggestion: String? = nil) {
        print(string)
        
        let paddingLength = string.distance(from: string.startIndex, to: underline.lowerBound)
        
        let padding = String(repeating: " ", count: paddingLength)
        
        let underlineLength = string.distance(from: underline.lowerBound, to: underline.upperBound)
        let underline = padding + "^" + String(repeating: "~", count: underlineLength - 1)
        let underlineOutput = format(string: underline, color: .green)
        print(underlineOutput)
        
        if suggestion != nil {
            let suggestionOutput = format(string: padding + suggestion!, color: .green)
            print(suggestionOutput)
        }
    }
    
    enum ANSIColorCode: Int, CustomStringConvertible {
        case reset = 0
        
        case boldOn = 1
        case boldOff = 22
        
        case red = 31
        case green = 32
        case magenta = 35
        case white = 37
        
        var description: String {
            return "\u{001B}[\(self.rawValue)m"
        }
    }
    
    static func format(string: String, color: ANSIColorCode) -> String {
        return "\(color)\(string)\(ANSIColorCode.reset)"
    }
    
    static func printHeading(_ title: String, color: ANSIColorCode, body: String) {
        var message = "\(ANSIColorCode.boldOn)\(color)\(title): "
        message += format(string: body, color: .white)
        print(message)
    }
}
