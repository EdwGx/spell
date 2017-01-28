//
//  main.swift
//  spell
//
//  Created by Pei Liang Guo 2017-01-24.
//  Copyright © 2017 Pei Liang Guo. All rights reserved.
//

import Foundation
import AppKit

var version = Version(major: 0, minor: 3, tiny: nil)

let options = ProgramOptions(arguments: CommandLine.arguments)

let controller: TextController

switch options.inputType {
case .sentence:
    controller = SentenceController(sentence: options.inputBody)
case .word:
    controller = WordController(word: options.inputBody, forceSuggestion: options.forceSuggestion)
case .help:
    controller = HelpController(version: version)
}

controller.render()
