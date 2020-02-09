//
//  ViewController.swift
//  ARKitBirdGame
//
//  Created by Rachel Saunders on 07/02/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }


}

extension ViewController : ARSKViewDelegate {
    
    func view(_ view: ARSKView, didAdd node: SKNode, for anchor: ARAnchor) {
         let birdNode = SKSpriteNode(imageNamed: "bird")
        birdNode.xScale = 0.25
        birdNode.yScale = 0.25
        
        node.addChild(birdNode)
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        
    }
}

