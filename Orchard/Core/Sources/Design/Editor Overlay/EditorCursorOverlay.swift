//
//  EditorCursorOverlay.swift
//  Core
//
//  Created by Zack Brown on 20/02/2026.
//

import AppKit
import Base
import Deltille
import Euclid
import Harvest

public class EditorCursorOverlay: NSView {
    
    public enum Mode: String,
                      Identifiable {
        
        case triangle
        case vertex
        
        public var id : String { rawValue.capitalized }
        
        internal var color: NSColor {
            
            switch self {
                
            case .triangle: .systemIndigo
            case .vertex: .systemPink
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

        mode = mode == .triangle ? .vertex : .triangle
        
        button.bezelColor = mode.color
    }
}

extension EditorCursorOverlay {
 
    public func update(_ hit: Triangle.HitTest) {
        
        switch mode {
            
        case .triangle:
            
            button.title = "T: \(hit.triangle.id)"
            
        case .vertex:
            
            button.title = "V: \(hit.vertex.id)"
        }
    }
}
