//
//  InspectorSceneView.swift
//  Orchard
//
//  Created by Zack Brown on 07/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

class InspectorSceneView: SCNView {

    let inspectable: SCNNode

    let cameraJib: SCNNode
    
    required init?(coder decoder: NSCoder) {
        
        inspectable = SCNNode()
        
        cameraJib = SCNNode()
        
        cameraJib.camera = SCNCamera()
        
        super.init(coder: decoder)
        
        scene = SCNScene()
    }
}

extension InspectorSceneView {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        guard let scene = scene else { return }
        
        scene.rootNode.addChildNode(cameraJib)
        scene.rootNode.addChildNode(inspectable)
    }
}
