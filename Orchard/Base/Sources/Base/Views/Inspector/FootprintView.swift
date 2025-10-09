//
//  FootprintView.swift
//  Base
//
//  Created by Zack Brown on 09/10/2025.
//

import AppKit
import Deltille
import Euclid

public class FootprintView: NSView {
    
    internal enum Constant {
        
        static let scale = 1.5
    }
    
    public var footprint: Triangle.Footprint {
        
        didSet {
            
            setNeedsDisplay(bounds)
        }
    }
    
    public init(footprint: Triangle.Footprint) {
        
        self.footprint = footprint
        
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)
        
        let origin = Vector(frame.midX, 0.0, frame.midY)
        
        for tile in footprint.tiles {
            
            draw(tile.vertices.position(.chunk).map { $0 * Constant.scale },
                 origin,
                 .controlAccentColor)
        }
        
        for tile in footprint.perimeter {
            
            draw(tile.vertices.position(.chunk).map { $0 * Constant.scale },
                 origin,
                 .white)
        }
    }
}

extension FootprintView {
    
    private func draw(_ vertices: [Vector],
                      _ origin: Vector,
                      _ fill: NSColor) {
        
        guard let first = vertices.first,
              let last = vertices.last,
              first != last else { return }
        
        let path = NSBezierPath()
        
        path.move(to: .init(origin + last))
        
        vertices.forEach {
            
            path.line(to: .init(origin + $0))
        }
        
        fill.setFill()
        NSColor.black.setStroke()
        
        path.fill()
        path.stroke()
    }
}
