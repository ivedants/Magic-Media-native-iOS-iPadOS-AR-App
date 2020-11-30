//
//  AnimationDetails.swift
//  MagicKettle
//
//  Created by Vedant Shrivastava on 11/29/20.
//

import Foundation

enum ObjectType: String {
    case moon = "moon"
    }

struct AnimationDetails {
    let objectType: ObjectType
    let startTime: Double
    let duration: Double
    //let animationType: AnimationType
}
