//
//  SpellOutput.swift
//  spell
//
//  Created by Pei Liang Guo on 2017-01-28.
//  Copyright © 2017 Pei Liang Guo. All rights reserved.
//

import Foundation

class SpellOutput {
    static let endl = "\n"
    
    // List phrases to tell user the word or the sentence is correct
    static let positiveResponds = ["Correct!", "Perfect!", "100%", "Bingo!", "That is right.",
                                   "LGTM", "95.46% Confident"]
    
    // Output the positive feedback message
    static func printPositiveFeedback() {
        let randomIndex = Int(arc4random_uniform(UInt32(positiveResponds.count)))
        print(positiveResponds[randomIndex])
    }
    
    // Output a short description of a grammar or spelling correction
    static func printHeading(_ title: String, color: ANSIColorCode, body: String) {
        var message = "\(ANSIColorCode.boldOn)\(color)\(title): "
        message += format(string: body, color: .white)
        print(message)
    }
    
    // Output a list of string with index
    static func printOrderedList(_ list: [String]) {
        for i in 0..<list.count {
            print("\(i+1). \(list[i])")
        }
    }
    
    // Output underline and suggestion in a format that is similar to code compliers
    static func printUnderline(string: String, underline: Range<String.Index>, suggestion: String? = nil) {
        print(string)
        
        // Generate a padding string that will ensure correct underline and suggestion alignment
        let paddingLength = string.distance(from: string.startIndex, to: underline.lowerBound)
        let padding = String(repeating: " ", count: paddingLength)
        
        // Calculate the length of the underline string
        let underlineLength = string.distance(from: underline.lowerBound, to: underline.upperBound)
        
        // Output underline in the correct format: ^~~~~~~~
        let underline = padding + "^" + String(repeating: "~", count: underlineLength - 1)
        let underlineOutput = format(string: underline, color: .green)
        print(underlineOutput)
        
        // If there is suggestion, output the suggestion below the underline
        if suggestion != nil {
            let suggestionOutput = format(string: padding + suggestion!, color: .green)
            print(suggestionOutput)
        }
    }
    
    // ANSIColorCode for output string color formatting
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
    
    // Return a formatted string with a desired color
    static func format(string: String, color: ANSIColorCode) -> String {
        return "\(color)\(string)\(ANSIColorCode.reset)"
    }
}
