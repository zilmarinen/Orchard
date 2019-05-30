//
//  InspectorSceneView.swift
//  Orchard
//
//  Created by Zack Brown on 07/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

class InspectorSceneView: SCNView {
    
    private var lastUpdateTime: TimeInterval = -1

    let inspectable: SCNNode

    let cameraJib: SceneKitCamera
    
    required init?(coder decoder: NSCoder) {
        
        inspectable = SCNNode()
        
        cameraJib = SceneKitCamera()
        
        super.init(coder: decoder)
        
        scene = SCNScene()
    }
}

extension InspectorSceneView {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        guard let scene = scene else { return }
        
        self.delegate = self
        
        scene.rootNode.addChildNode(cameraJib)
        scene.rootNode.addChildNode(inspectable)
    }
}

extension InspectorSceneView: SCNSceneRendererDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let deltaTime = (lastUpdateTime == -1 ? 0 : (time - lastUpdateTime))
        
        cameraJib.update(deltaTime: deltaTime)
        
        lastUpdateTime = time
    }
}
