//
//  ColorPaletteView.swift
//
//  Created by Zack Brown on 04/10/2025.
//

import Alluvium
import AppKit
import Deltille
import Euclid
import Harvest

public class ColorPaletteView: BackgroundView {
    
    internal enum Constant {
        
        static let scale = 1.7
    }
    
    public var colorPalette: ColorPalette {
        
        didSet {
            
            setNeedsDisplay(bounds)
        }
    }
    
    public init(colorPalette: ColorPalette) {
        
        self.colorPalette = colorPalette
        
        super.init(.controlBackgroundColor)
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)
        
        let triangle = Triangle.zero
        let origin = Vector(frame.midX, 0.0, frame.midY)
        let h0 = Hexagon(triangle.vertex(.c0).position)
        let h1 = Hexagon(triangle.vertex(.c1).position)
        let h2 = Hexagon(triangle.vertex(.c2).position)
        
        draw(h0.vertices.position(.region).map { $0 * Constant.scale },
             origin,
             .init(colorPalette.secondary))
        draw(h1.vertices.position(.region).map { $0 * Constant.scale },
             origin,
             .init(colorPalette.tertiary))
        draw(h2.vertices.position(.region).map { $0 * Constant.scale },
             origin,
             .init(colorPalette.quaternary))
        
        draw([h0.position(.region) * Constant.scale,
              h1.position(.region) * Constant.scale,
              h2.position(.region) * Constant.scale],
             origin,
             .init(colorPalette.primary))
    }
}

extension ColorPaletteView {
    
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
