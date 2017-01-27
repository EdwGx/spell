//
//  main.swift
//  spell
//
//  Created by Edward Guo on 2017-01-24.
//  Copyright © 2017 Pei Liang Guo. All rights reserved.
//

import Foundation
import AppKit

func printOrderedList(_ list: [String]) {
    for i in 0..<list.count {
        print("\(i+1). \(list[i])")
    }
}

func printSpellingError(sentence: String, wordRange: Range<String.Index>) {
    let misspelledWord = sentence.substring(with: wordRange)
    let wordNSRange = NSRange(location: 0, length: misspelledWord.characters.count)
    
    
    let checker = NSSpellChecker.shared()
    let guesses = checker.guesses(forWordRange: wordNSRange,
                                  in: misspelledWord,
                                  language: checker.language(),
                                  inSpellDocumentWithTag: 0) ?? []
    
    var description = "word \'\(misspelledWord)\' is misspelled; "
    
    if guesses.count == 0 {
        description += "no suggestions"
    } else {
        description += "did you mean \'\(guesses[0])\'"
    }
    printColoredMessage("spelling", colorCode: 35, body: description)
    printUnderline(string: sentence, underline: wordRange, multipleArrows: false)
}

func printUnderline(string: String, underline: Range<String.Index>, multipleArrows: Bool) {
    // TODO: Handle long string
    print(string)
    var arrows = String(repeating: " ",
                        count: string.distance(from: string.startIndex,
                                               to: underline.lowerBound))
    if multipleArrows {
        arrows += String(repeating: "^",
                         count: string.distance(from: underline.lowerBound,
                                                to: underline.upperBound))
    } else {
        arrows += "^"
    }
    print(arrows)
}

func printColoredMessage(_ title: String, colorCode: Int, body: String) {
    var message = "\u{001B}[\(colorCode)m\(title):\u{001B}[0m "
    message += body
    print(message)
}

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
            printOrderedList(guesses)
        }
    } else {
        print("No suggestions")
    }
}

func handleGrammarFeedback(sentence: String, details: [[String : Any]]) {
    for detail in details {
        let description = detail[NSGrammarUserDescription] as! String
        let range = detail[NSGrammarRange] as! NSRange
        let corrections = detail[NSGrammarCorrections] as? [String]
        
        let start = sentence.index(sentence.startIndex, offsetBy: range.location)
        let end = sentence.index(start, offsetBy: range.length)
        
        printColoredMessage("grammar", colorCode: 31, body: description)
        
        if corrections != nil {
            print(String(repeating: " ", count: 9) + "corrections: " + corrections!.joined(separator: ", "))
        }
        
        printUnderline(string: sentence,
                       underline: start..<end,
                       multipleArrows: true)
        
        
    }
}

func process(sentence: String) {
    let checker = NSSpellChecker.shared()
    
    let sentenceRange = NSRange(location: 0, length: sentence.characters.count)
    
    let checkingTypes: NSTextCheckingResult.CheckingType = [.spelling, .grammar]
    
    let results = checker.check(sentence, range: sentenceRange,
                                types: checkingTypes.rawValue,
                                options: nil, inSpellDocumentWithTag: 0, orthography: nil, wordCount: nil)

    if results.count == 0 {
        print("Correct!")
        return
    }
    
    for  feedback in results {
        let range = feedback.range
        
        switch feedback.resultType {
        case NSTextCheckingResult.CheckingType.grammar:
            handleGrammarFeedback(sentence: sentence, details: feedback.grammarDetails!)
        case NSTextCheckingResult.CheckingType.spelling:
            let start = sentence.index(sentence.startIndex, offsetBy: range.location)
            let end = sentence.index(start, offsetBy: range.length)
            printSpellingError(sentence: sentence, wordRange: start..<end)
        default:
            abort()
        }
        
        
    }
    
}

func processHelp() {
    let checker = NSSpellChecker.shared()
    
    print("spell - A command line tool for spelling and grammar checking")
    print("It takes a word or a sentence as its argument.")
    print("")
    print("Example:")
    print("    spell swift")
    print("    spell I love programming!")
    print("")
    print("language: \(checker.language())")
    print("version: 0.2")
    print("")
    print("Created by Pei Liang Guo")
}

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
    process(sentence: arguments.joined(separator: " "))
}


