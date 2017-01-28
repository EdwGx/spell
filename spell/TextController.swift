//
//  TextController.swift
//  spell
//
//  Created by Edward Guo on 2017-01-28.
//  Copyright © 2017 Pei Liang Guo. All rights reserved.
//

import Foundation
import AppKit

protocol TextController {
    func render()
}

class SentenceController: TextController {
    struct Correction {
        let title: String
        let titleColor: SpellOutput.ANSIColorCode
        let detail: String
        let range: Range<String.Index>
        let guesses: [String]
    }
    
    let sentence: String
    
    var corrections: [Correction] = []
    
    let checker = NSSpellChecker.shared()
    
    init(sentence: String) {
        self.sentence = sentence
        
        let sentenceRange = NSRange(location: 0, length: sentence.characters.count)
        
        let checkingTypes: NSTextCheckingResult.CheckingType = [.spelling, .grammar]
        
        let results = checker.check(sentence, range: sentenceRange,
                                    types: checkingTypes.rawValue,
                                    options: nil, inSpellDocumentWithTag: 0, orthography: nil, wordCount: nil)
        
        for feedback in results {
            switch feedback.resultType {
            case NSTextCheckingResult.CheckingType.grammar:
                for detail in feedback.grammarDetails! {
                    let grammarCorrection = processGrammarFeedback(detail: detail)
                    corrections.append(grammarCorrection)
                }
            case NSTextCheckingResult.CheckingType.spelling:
                let spellingCorrection = processSpellingFeedback(range: feedback.range)
                corrections.append(spellingCorrection)
            default:
                break
            }
        }
    }
    
    func processGrammarFeedback(detail: [String : Any]) -> Correction {
        var description = detail[NSGrammarUserDescription] as! String
        
        // Change the first letter to lowercase form to match compiler warning
        let firstLetterRange = description.startIndex..<description.index(description.startIndex, offsetBy: 1)
        let firstLetter = description.substring(with: firstLetterRange)
        description.replaceSubrange(firstLetterRange, with: firstLetter.lowercased())
        
        
        let range = detail[NSGrammarRange] as! NSRange
        let corrections = detail[NSGrammarCorrections] as? [String]
        
        let start = sentence.index(sentence.startIndex, offsetBy: range.location)
        let end = sentence.index(start, offsetBy: range.length)
        
        return Correction(title: "grammar",
                          titleColor: .red,
                          detail: description,
                          range: start..<end,
                          guesses: corrections ?? [])
    }
    
    func processSpellingFeedback(range: NSRange) -> Correction {
        let start = sentence.index(sentence.startIndex, offsetBy: range.location)
        let end = sentence.index(start, offsetBy: range.length)
        
        let wordRange = start..<end
        
        let misspelledWord = sentence.substring(with: wordRange)
        let wordNSRange = NSRange(location: 0, length: misspelledWord.characters.count)
        
        let guesses = checker.guesses(forWordRange: wordNSRange,
                                      in: misspelledWord,
                                      language: checker.language(),
                                      inSpellDocumentWithTag: 0) ?? []
        
        var description = "word \'\(misspelledWord)\' is misspelled; "
        
        let suggestion = guesses.isEmpty ? nil : guesses[0]
        
        if suggestion != nil {
            description += "did you mean \'\(suggestion!)\'"
        } else {
            description += "no suggestions"
        }
        
        return Correction(title: "spelling",
                          titleColor: .magenta,
                          detail: description,
                          range: wordRange,
                          guesses: guesses)
    }
    
    func render() {
        if corrections.isEmpty {
            SpellOutput.printPositiveFeedback()
        } else {
            for correction in corrections {
                SpellOutput.printHeading(correction.title,
                                         color: correction.titleColor,
                                         body: correction.detail)
                
                var suggestion: String? = nil
                if !correction.guesses.isEmpty {
                    suggestion = correction.guesses.joined(separator: ", ")
                }
                
                SpellOutput.printUnderline(string: sentence,
                                           underline: correction.range,
                                           suggestion: suggestion)
            }
        }
    }
    
    
}

class WordController: TextController {
    let word: String
    let forceSuggestion: Bool
    
    init(word: String, forceSuggestion: Bool) {
        self.word = word
        self.forceSuggestion = forceSuggestion
    }
    
    func render() {
        let checker = NSSpellChecker.shared()
        
        let wordRange = NSRange(location: 0, length: word.characters.count)
        
        let misspelledRange = checker.checkSpelling(of: word, startingAt: 0)
        
        if misspelledRange.location == NSNotFound {
            SpellOutput.printPositiveFeedback()
            
            if (!forceSuggestion) {
                return
            }
        }
        
        if let guesses = checker.guesses(forWordRange: wordRange, in: word,
                                         language: checker.language(), inSpellDocumentWithTag: 0) {
            if (guesses.count == 0){
                print("No suggestions")
            } else {
                SpellOutput.printOrderedList(guesses)
            }
        } else {
            print("No suggestions")
        }
    }
}

class HelpController: TextController {
    let version: Version
    
    init(version: Version) {
        self.version = version
    }
    
    func render() {
        let checker = NSSpellChecker.shared()
        
        // Output information about spell
        print("spell - A command line tool that checks spelling and grammar like a compiler")
        print("It accepts a word or a sentence as its argument.")
        print("")
        print("Examples:")
        print("    spell swift")
        print("    spell --force swift")
        print("    spell I love programming!")
        print("")
        print("Options:")
        print("    Use --force or -f to force printing suggestions regardless")
        print("    the word is correctly spelled or not.")
        print("")
        print("language: \(checker.language())")
        print("version:  \(version)")
        print("")
        print("Created by Pei Liang Guo")
    }
}
