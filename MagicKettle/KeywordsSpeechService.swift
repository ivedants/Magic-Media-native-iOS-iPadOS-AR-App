//
//  KeywordsSpeechService.swift
//  MagicKettle
//
//  Created by Vedant Shrivastava on 11/28/20.
//

import Foundation

class KeywordsSpeechService: SpeechService {
    
    func action(for text: String) -> SpeechAction? {
        let lowercased = text.lowercased()
        let words: [String] = lowercased
            .components(separatedBy: .punctuationCharacters)
            .joined()
            .components(separatedBy: .whitespaces)
            .filter{ !$0.isEmpty }
        return action(for: words)
    }
    
    private func action(for words: [String]) -> SpeechAction? {
        for word in words {
            if let objectType = ObjectType(rawValue: word) {
                return SpeechAction.addObject(objectType)
            }
//            if let animateType = AnimationType(rawValue: word) {
//                return SpeechAction.animateAnimal(animateType)
//            }
        }
        return nil
    }
    
}
