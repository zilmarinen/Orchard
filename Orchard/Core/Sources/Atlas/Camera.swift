//
//  Camera.swift
//  Core
//
//  Created by Zack Brown on 14/05/2026.
//

import Base
import Deltille
import SpriteKit

internal class Camera: SKCameraNode {
    
    internal static let maximumScale = 5.0
    internal static let minimumScale = 1.0
    internal static let translationSpeed = 2.0
    
    internal override init() {
        
        super.init()
        
        setScale(Self.maximumScale / 2.0)
        zRotation = .pi / 2.0
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension Camera {
    
    internal var scale: CGFloat { xScale }
    
    internal func focus(on location: CGPoint) {
        
        self.position = location
    }
    
    internal func translate(by delta: CGPoint) {
        
        self.position += delta * scale * Self.translationSpeed
    }
    
    internal func zoom(delta: Double) {
        
        setScale(max(Self.minimumScale,
                     min(Self.maximumScale,
                         scale + delta)))
    }
}
