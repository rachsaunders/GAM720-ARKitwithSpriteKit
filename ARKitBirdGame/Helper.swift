//
//  Helper.swift
//  ARKitBirdGame
//
//  Created by Rachel Saunders on 09/02/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//

import Foundation

enum GameState:Int {
    case none, spawnBirds
}

func randomPosition (lowerBound lower:Float, upperBount upper:Float) -> Float {
    return Float(arc4random()) / Float(UInt32.max) * (lower - upper) + upper
}

func randomNumber (lowerBound lower:Int, upperBound upper:Int) -> Int {
    return Int(arc4random()) / Int(UInt32.max) * (lower - upper) + upper
}
