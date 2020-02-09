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
    
    var remainingTime:Int = 30 {
        didSet {
            timerLabel.text = "\(remainingTime) sec"
        }
    }
    
    var score:Int = 0 {
        didSet{
            counterLabel.text = "\(score) Birds"
        }
    }
    
    static var gameState:GameState = .none
    
    func setupHUD() {
        // THE TWO LINES BELOW WERE CHANGED - WARNING THROWN FOR OPTIONALS
        timerLabel = self.childNode(withName: "timerLabel") as? SKLabelNode
        counterLabel = self.childNode(withName: "counterLabel") as? SKLabelNode
        
        timerLabel.position = CGPoint(x: (self.size.width / 2) - 70, y: (self.size.width / 2) - 90)
        counterLabel.position = CGPoint(x: (self.size.width / 2) + 70, y: (self.size.width / 2) + 90)
        
        let wait = SKAction.wait(forDuration: 1)
        let action = SKAction.run {
            self.remainingTime -= 1
        }
        
        let timerAction = SKAction.sequence([wait, action])
        self.run(SKAction.repeatForever(timerAction))
    }
    
    func gameOver(){
        let reveal = SKTransition.crossFade(withDuration: 0.9)
        
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        if let mainMenu = MainMenuScene(fileNamed: "MainMenuScene") {
            sceneView.presentScene(mainMenu, transition: reveal)
        }
    }
    
    override func didMove(to view: SKView) {
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.spawnBirds), name: Notification.Name("Spawn"), object: nil)
        setupHUD()
        
        let waitAction = SKAction.wait(forDuration: 0.5)
        let spawnAction = SKAction.run {
            self.performInitialSpawn()
        }
        
        self.run(SKAction.sequence([waitAction, spawnAction]))
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if remainingTime == 0 {
            self.removeAllActions()
            gameOver()
        }
        
        guard let sceneView = self.view as? ARSKView else {return}
        
        if let cameraZ = sceneView.session.currentFrame?.camera.transform.columns.3.z {
            for node in nodes(at: CGPoint.zero) {
                if let bird = node as? Bird {
                    
                    guard let anchors = sceneView.session.currentFrame?.anchors else {return}
                    
                    for anchor in anchors {
                        if abs(cameraZ - anchor.transform.columns.3.z) < 0.2 {
                            if let potentialTargetBird = sceneView.node(for: anchor) {
                                if bird == potentialTargetBird {
                                    bird.removeFromParent()
                                    spawnBirds()
                                    score += 1
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    func performInitialSpawn() {
        
        GameScene.gameState = .spawnBirds
        
        for _ in 1 ... numberOfBirds {
            spawnBirds()
        }
    }
    
    @objc func spawnBirds() {
        
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
