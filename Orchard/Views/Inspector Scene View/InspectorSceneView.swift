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
    
    /*!
     @property lastUpdateTime
     @abstract TimeInterval of when the last update was performed.
     */
    private var lastUpdateTime: TimeInterval = -1

    /*!
     @property inspectable
     @abstract Singular instance of a SCNNode to inspect.
     */
    let inspectable: SCNNode

    /*!
     @property cameraJib
     @abstract Main world camera parent node.
     */
    let cameraJib: CameraJib
    
    /*!
     @method initWithCoder
     @abstract Support coding and decoding via NSKeyedArchiver.
     */
    required init?(coder decoder: NSCoder) {
        
        inspectable = SCNNode()
        
        cameraJib = CameraJib()
        
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

extension InspectorSceneView {
    
    override func scrollWheel(with event: NSEvent) {
        
        switch cameraJib.stateMachine.state {
            
        case .focus(let focus, let edge, let zoomLevel):
            
            let newZoomLevel = (zoomLevel + event.deltaY)
            
            cameraJib.stateMachine.state = .focus(focus, edge, newZoomLevel)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        
        switch cameraJib.stateMachine.state {
            
        case .focus(let focus, let edge, let zoomLevel):
            
            let nextEdge = GridEdge(rawValue: (edge == .west ? GridEdge.north.rawValue : (edge.rawValue + 1)))!
            
            cameraJib.stateMachine.state = .focus(focus, nextEdge, zoomLevel)
        }
    }
    
    override func rightMouseDown(with event: NSEvent) {
     
        switch cameraJib.stateMachine.state {
            
        case .focus(let focus, let edge, let zoomLevel):
            
            let nextEdge = GridEdge(rawValue: (edge == .north ? GridEdge.west.rawValue : (edge.rawValue - 1)))!
            
            cameraJib.stateMachine.state = .focus(focus, nextEdge, zoomLevel)
        }
    }
}

extension InspectorSceneView: SCNSceneRendererDelegate {
    
    /*!
     @method renderer:updateAtTime:
     @abstract Called exactly once per frame before any animation and actions are evaluated and any physics are simulated.
     @param renderer The renderer that will render the scene.
     @param time The time at which to update the scene.
     */
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let deltaTime = (lastUpdateTime == -1 ? 0 : (time - lastUpdateTime))
        
        cameraJib.update(deltaTime: deltaTime)
        
        lastUpdateTime = time
    }
}
