//
//  SpeechService.swift
//  MagicKettle
//
//  Created by Vedant Shrivastava on 11/28/20.
//

import Foundation

enum SpeechAction {
    case addObject(ObjectType)
//    case animateAnimal(AnimationType)
}

protocol SpeechService {
    func action(for text: String) -> SpeechAction?
}
