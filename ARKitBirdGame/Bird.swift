//
//  Bird.swift
//  ARKitBirdGame
//
//  Created by Rachel Saunders on 09/02/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//

import SpriteKit
import GameplayKit

class Bird : SKSpriteNode {
    
    var mainSprite = SKSpriteNode()
    
    func setup(){
        
        mainSprite = SKSpriteNode(imageNamed: "bird1")
        self.addChild(mainSprite)
        
        let textureAtlas = SKTextureAtlas(named: "bird")
        let frames = ["Sprite_0", "Sprite_1","Sprite_2","Sprite_3","Sprite_4","Sprite_5", "Sprite_6"].map{textureAtlas.textureNamed($0)}
        
        let atlasAnimation = SKAction.animate(with: frames, timePerFrame: 1/7, resize: true, restore: false)
        
        let animationAction = SKAction.repeatForever(atlasAnimation)
        mainSprite.run(animationAction)
        
        let left = GKRandomSource.sharedRandom().nextBool()
        if left {
            mainSprite.xScale = -1
        }
        
        let duration = randomNumber(lowerBound: 15, upperBound: 20)
        
        let fade = SKAction.fadeOut(withDuration: TimeInterval(duration))
        let removeBird = SKAction.run {
            NotificationCenter.default.post(name: Notification.Name("Spawn"), object: nil)
            self.removeFromParent()
        }
        
        let flySequence = SKAction.sequence([fade, removeBird])
        
        mainSprite.run(flySequence)
    }
    
}
