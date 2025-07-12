//
//  EditorView.swift
//  Core
//
//  Created by Zack Brown on 10/07/2025.
//

import Foundation
import RealityKit

public class EditorView: ARView {
    
    public required init(frame: NSRect) {
        
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        environment.background = .color(.systemPink)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
