//
//  Search.swift
//  
//
//  Created by Ксюся on 30.10.2020.
//

import Foundation

public class Search: SearchProtocol {
    
    let output: TerminalOutputProtocol
    let dict: DictionaryProtocol
    var isInDictionary: Bool
    
    init(dictionary: DictionaryProtocol, terminalOutput: TerminalOutputProtocol) {
        self.dict = dictionary
        self.output = terminalOutput
        self.isInDictionary = false
    }
    
    public func search(key: String?, language: String?) throws {
        
        let dictionary = dict.getDictionary()
        
        guard !dictionary.isEmpty else {
            throw ValidationResult.dictionaryIsEmpty
        }
        
        if key == nil && language == nil {
            defaultSearch(dictionary: dictionary)
            isInDictionary = true
        }
        
        if let key: String = key, language == nil {
            output.consoleOutput(word: key.lowercased())
        }
        for (englishWord, wordsArray) in dictionary {
            // -l
            if key == nil, let language: String = language, let word = wordsArray[language.lowercased()] {
                output.outputTemplates(variant: .equalSign, firstArgument: englishWord, secondArgument: word)
                isInDictionary = true
            }
            for (_, dictionaryTranslation) in wordsArray {
                if let key: String = key, dictionaryTranslation.lowercased() == key.lowercased() {
                    for (thisLanguage, thisTranslation) in wordsArray {
                        // -k
                        if language == nil {
                            output.outputTemplates(variant: .colon, firstArgument: thisLanguage, secondArgument: thisTranslation)
                            isInDictionary = true
                        // -k -l
                        } else if let language: String = language, thisLanguage == language.lowercased() {
                            output.consoleOutput(word: thisTranslation)
                            isInDictionary = true
                        }
                    }
                }
            }
        }
        output.outputNotFound(isInDictionary: isInDictionary)
    }

    public func defaultSearch(dictionary: [String: [String: String]]) {        
        let dictionary = dict.getDictionary()
        for (englishWord, wordsArray) in dictionary {
            output.consoleOutput(word: englishWord)
            for (dictionaryLanguage, dictionaryTranslation) in wordsArray {
                output.outputTemplates(variant: .colon, firstArgument: dictionaryLanguage, secondArgument: dictionaryTranslation)
            }
        }
    }
    
}


