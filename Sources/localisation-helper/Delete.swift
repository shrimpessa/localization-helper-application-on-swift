//
//  Delete.swift
//  
//
//  Created by Ксюся on 30.10.2020.
//

import Foundation

public class Delete: DeleteProtocol {
    
    var output: TerminalOutputProtocol
    let dict: DictionaryProtocol
    
    init(dictionary: DictionaryProtocol, terminalOutput: TerminalOutputProtocol) {
        self.dict = dictionary
        self.output = terminalOutput
    }
    
    public func delete(key: String?, language: String?) throws {
        
        var dictionary = dict.getDictionary()
        
        guard !dictionary.isEmpty else {
            throw ValidationResult.dictionaryIsEmpty
        }
        
        guard key != nil && language != nil else {
            throw ValidationResult.onlyOneParameterEnteredToDelete
        }
        
        for (englishWord, wordsArray) in dictionary {
            var wordsArray = wordsArray
            // -k -l
            if let language: String = language, let key: String = key, wordsArray[language]?.lowercased() == key.lowercased() {
                wordsArray[language] = nil
                dictionary[englishWord] = wordsArray
            }
        }
        try dict.write(dictionary: dictionary)
        output.consoleOutput(word: "Слово удалено.")
    }
}


