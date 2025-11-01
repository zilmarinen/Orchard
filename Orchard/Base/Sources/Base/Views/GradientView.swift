//
//  GradientView.swift
//
//  Created by Zack Brown on 29/10/2025.
//

import AppKit

public class GradientView: NSView {
    
    internal enum Constant {
        
        static let angle = 90.0
    }
    
    private let primaryColor: NSColor
    private let secondaryColor: NSColor
    
    private let gradient: NSGradient?
    
    public init(primaryColor: NSColor,
                secondaryColor: NSColor) {
        
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        
        self.gradient = .init(colors: [primaryColor,
                                      secondaryColor])
        
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)
        
        guard let gradient else { return }
        
        gradient.draw(in: dirtyRect,
                      angle: Constant.angle)
    }
}

