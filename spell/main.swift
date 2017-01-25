//
//  main.swift
//  spell
//
//  Created by Edward Guo on 2017-01-24.
//  Copyright © 2017 Pei Liang Guo. All rights reserved.
//

import Foundation
import AppKit

func process(word: String, forceSuggestions: Bool) {
    let checker = NSSpellChecker.shared()
    
    let wordRange = NSRange(location: 0, length: word.characters.count)
    
    let misspelledRange = checker.checkSpelling(of: word, startingAt: 0)
    
    if misspelledRange.location == NSNotFound {
        print("Correct!")
        
        if (!forceSuggestions) {
            return
        }
    }
    
    if let guesses = checker.guesses(forWordRange: wordRange, in: word,
                                            language: checker.language(), inSpellDocumentWithTag: 0) {
        if (guesses.count == 0){
            print("No suggestions")
        } else {
            for i in 0..<guesses.count {
                print("\(i+1). \(guesses[i])")
            }
        }
    } else {
        print("No suggestions")
    }
}

func processHelp() {
    let checker = NSSpellChecker.shared()
    
    print("spell - A spell checker for command line")
    print("It takes exactly one word as its argument.")
    print("")
    print("Example:")
    print("    spell apple")
    print("")
    print("language: \(checker.language())")
}

let server = NSSpellServer()
server.run()

var arguments = CommandLine.arguments
arguments.removeFirst()

var forceSuggestions = false

if (arguments.count > 0) {
    if (arguments[0] == "-f" || arguments[0] == "--force") {
        forceSuggestions = true
        arguments.removeFirst()
    } else if (arguments[arguments.endIndex - 1] == "-f" || arguments[arguments.endIndex - 1] == "--force") {
        forceSuggestions = true
        arguments.removeLast()
    }
}

switch arguments.count {
case 0:
    processHelp()
case 1:
    process(word: arguments[0], forceSuggestions: forceSuggestions)
default:
    processHelp()
}


