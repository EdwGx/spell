//
//  Argument.swift
//  spell
//
//  Created by Pei Liang Guo on 2017-01-28.
//  Copyright © 2017 Pei Liang Guo. All rights reserved.
//

import Foundation

class ProgramOptions {
    // Store command line arguments
    var arguments: [String]
    
    // Values of the program options
    var forceSuggestion = false
    
    // Input Type
    enum InputType {
        case word
        case sentence
        case help
    }
    
    var inputType = InputType.help
    var inputBody = ""
    
    init(arguments: [String]) {
        self.arguments = arguments
        
        // Remove the excutable name
        self.arguments.removeFirst()
        
        forceSuggestion = parseOption(name: "force", shortHand: "f")
        
        if self.arguments.count == 0 {
            inputType = .help
        } else if self.arguments.count == 1 {
            inputType = .word
            inputBody = self.arguments[0]
        } else {
            inputType = .sentence
            inputBody = self.arguments.joined(separator: " ")
        }
    }
    
    func parseOption(name: String, shortHand: String) -> Bool {
        // Try to seach the option both forward and backward
        return (parseOption(name: name, shortHand: shortHand, front: true)
            || parseOption(name: name, shortHand: shortHand, front: false))
    }
    
    func parseOption(name: String, shortHand: String, front: Bool) -> Bool {
        // Return false because the arguments is empty
        guard !arguments.isEmpty else {
            return false
        }
        
        // Add dashes to name and shortHand
        let nameArgument = "--\(name)"
        let shortHandArgument = "-\(shortHand)"
        
        for forwardIndex in arguments.startIndex...arguments.endIndex {
            // Search forward is @param front is true, otherwise search backward
            let index = front ? forwardIndex : ((arguments.endIndex - 1) - forwardIndex)
            let argument = arguments[index]
            
            // If the argument starts with dash, test if it matches with name or shorthand.
            // Otherwise stop searching because the argument is a part of the input body.
            if argument.hasPrefix("-") {
                if argument == nameArgument || argument == shortHandArgument {
                    // Found the option, remove it from the arguments and and return true
                    arguments.remove(at: index)
                    return true
                } else {
                    // It is an option but the name or the shortHand does not match
                    continue
                }
            } else {
                // Stop searching because the index has reached the input body
                return false
            }
        }
        return false
    }
}
