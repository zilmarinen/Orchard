//
//  EditorCursorOverlay.swift
//  Core
//
//  Created by Zack Brown on 20/02/2026.
//

import AppKit
import Base
import Deltille
import Harvest

public class EditorCursorOverlay: NSView {
    
    public enum Mode: String,
                      Identifiable {
        
        case hexagon
        case triangle
        case vertex
        
        public var id : String { rawValue.capitalized }
        
        internal var color: NSColor {
            
            switch self {
                
            case .hexagon: .systemRed
            case .triangle: .systemIndigo
            case .vertex: .systemBlue
            }
        }
    }
    
    // MARK: Buttons
    
    private lazy var button = with(NSButton(title: Triangle.zero.id,
                                            target: self,
                                            action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.bezelColor = mode.color
    }
    
    private(set) var mode: Mode
    
    public init(mode: Mode = .triangle) {
        
        self.mode = mode
        
        super.init(frame: .zero)
        
        addSubview(button)
        
        NSLayoutConstraint.activate([
            
            button.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            button.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor,
                                         constant: .padding),
            button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                           constant: -.padding),
            button.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension EditorCursorOverlay {
    
    @objc
    private func button(_ sender: NSButton) {
        
        switch mode {
            
        case .hexagon: mode = .triangle
        case .triangle: mode = .vertex
        case .vertex: mode = .hexagon
        }
        
        button.bezelColor = mode.color
    }
}

extension EditorCursorOverlay {
 
    public func update(hit: HitTest) {
        
        switch mode {
            
        case .hexagon:
            
            let hexagon = Hexagon(hit.pointInWorld,
                                          .chunk)
            
            button.title = "H: \(hexagon.id)"
            
        case .triangle:
            
            button.title = "T: \(hit.triangle.id)"
            
        case .vertex:
            
            button.title = "V: \(hit.vertex.id)"
        }
    }
}
