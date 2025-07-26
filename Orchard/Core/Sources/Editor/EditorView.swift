//
//  EditorView.swift
//  Core
//
//  Created by Zack Brown on 10/07/2025.
//

import AppKit
import Foundation
import RealityKit

internal class EditorView: ARView {
    
    internal required init(frame: NSRect) {
        
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        debugOptions = [.showStatistics,
                        .showPhysics]
        
        environment.background = .color(.windowBackgroundColor)
        
        let anchor = AnchorEntity(plane: .horizontal)
        let box = MeshResource.generateBox(size: 0.5)
        let material = SimpleMaterial(color: .red,
                                      isMetallic: true)
        let entity = ModelEntity(mesh: box,
                                 materials: [material])
        
//        let ortho = OrthographicCameraComponent()
//        let camera = Entity(components: [ortho])
        //let pers = PerspectiveCameraComponent()
        let camera = PerspectiveCamera()
        
        camera.position = [0, 0, 1]
        
        entity.position = [0, 0, -1]
    
        //anchor.addChild(camera)
        anchor.addChild(entity)
        
        camera.look(at: entity.position, from: camera.position, upVector: [0, 1, 0], relativeTo: nil)
        
        scene.addAnchor(anchor)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
