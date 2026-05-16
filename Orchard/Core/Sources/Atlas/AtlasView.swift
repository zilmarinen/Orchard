//
//  AtlasView.swift
//  Core
//
//  Created by Zack Brown on 14/05/2026.
//

import Base
import Deltille
import Euclid
import Harvest
import SpriteKit

public class AtlasView: SKView {
    
    internal let camera = Camera()
    
    internal let cursor = SKShapeNode()
    
    public init() {
        
        super.init(frame: .zero)
        
        let scene = SKScene()
        
        let path = CGMutablePath()
        
        let triangle = Triangle.zero
        
        let v0 = triangle.vertex(.c0).position(.region)
        let v1 = triangle.vertex(.c1).position(.region)
        let v2 = triangle.vertex(.c2).position(.region)
        
        path.move(to: .init(x: v0.x,
                            y: v0.z))
        
        path.addLine(to: .init(x: v1.x,
                               y: v1.z))
        
        path.addLine(to: .init(x: v2.x,
                               y: v2.z))
        
        path.addLine(to: .init(x: v0.x,
                               y: v0.z))
        
        cursor.path = path
        cursor.fillColor = .systemPink
        cursor.strokeColor = .white
        cursor.lineWidth = 1.0
        
        let origin = SKShapeNode(path: path)
        let xSprite = SKShapeNode(rectOf: .init(width: 10, height: 10))
        let ySprite = SKShapeNode(rectOf: .init(width: 10, height: 10))
        
        xSprite.position = .init(x: 100.0, y: 0.0)
        xSprite.fillColor = .systemRed
        xSprite.strokeColor = .systemRed
        
        ySprite.position = .init(x: 0.0, y: 100.0)
        ySprite.fillColor = .systemGreen
        ySprite.strokeColor = .systemGreen
        
        origin.fillColor = .systemBlue
        origin.strokeColor = .white
        origin.lineWidth = 1.0
        origin.zRotation = triangle.orientation
        
        scene.backgroundColor = .windowBackgroundColor
        scene.camera = camera
        scene.scaleMode = .resizeFill
        
        scene.addChild(camera)
        scene.addChild(origin)
        scene.addChild(xSprite)
        scene.addChild(ySprite)
        scene.addChild(cursor)
        
        presentScene(scene)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: Loading

extension AtlasView {
    
    
}

// MARK: Hit Test

extension AtlasView {
    
    public func hit(_ point: CGPoint) -> Vector? {
        
        guard let hit = scene?.convertPoint(fromView: point) else { return nil }
        
        return .init(hit.x,
                     0.0,
                     -hit.y)
    }
}

// MARK: Camera

extension AtlasView {
    
    public func camera(focus value: CGPoint) {
        
        camera.focus(on: value)
    }
    
    public func camera(translate value: CGPoint) {
        
        camera.translate(by: value)
    }
    
    public func camera(zoom value: Double) {
        
        camera.zoom(delta: value)
    }
}

// MARK: Cursor

extension AtlasView {
    
    public func cursor(focus value: Triangle.HitTest) {
        
        let position = value.triangle.position(.region)
        
        cursor.position = .init(x: position.x,
                                y: -position.z)
        
        cursor.zRotation = value.triangle.orientation
    }
}
