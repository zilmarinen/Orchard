//
//  BackgroundView.swift
//
//  Created by Zack Brown on 29/10/2025.
//

import AppKit

public class BackgroundView: NSView {
    
    public let backgroundColor: NSColor
    
    public init(_ backgroundColor: NSColor) {
        
        self.backgroundColor = backgroundColor
        
        super.init(frame: .zero)
        
        wantsLayer = true
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public override func updateLayer() {
        
        self.layer?.backgroundColor = backgroundColor.cgColor
        
        super.updateLayer()
    }
}
