//
//  GameScene.swift
//  ARKitBirdGame
//
//  Created by Rachel Saunders on 09/02/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class GameScene: SKScene {
    
    var numberOfBirds = 10
    var timerLabel:SKLabelNode!
    var counterLabel:SKLabelNode!
    
    static var gameState:GameState = .none
    
    override func didMove(to view: SKView) {
        let waitAction = SKAction.wait(forDuration: 0.5)
        let spawnAction = SKAction.run {
            self.performInitialSpawn()
        }
        
        self.run(SKAction.sequence([waitAction, spawnAction]))
    }
    
    func performInitialSpawn() {
        
        GameScene.gameState = .spawnBirds
        
        for _ in 1 ... numberOfBirds {
            spawnBirds()
        }
    }
    
    func spawnBirds() {
        
        guard let sceneView = self.view as? ARSKView else {return}
        
        if let currentFrame = sceneView.session.currentFrame {
            var translation = matrix_identity_float4x4
            
            translation.columns.3.x = randomPosition(lowerBound: -1.5, upperBount: 1.5)
            translation.columns.3.y = randomPosition(lowerBound: -1.5, upperBount: 1.5)
            translation.columns.3.z = randomPosition(lowerBound: -1.5, upperBount: 1.5)
            
            let transform = simd_mul(currentFrame.camera.transform, translation)
            
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
            
        }
        
    }
    
}
