//
//  Tileset.swift
//
//  Created by Zack Brown on 24/03/2021.
//

import AppKit
import Meadow

extension Tileset {
    
    func image(for tile: TilesetTile) -> NSImage {
        
        let point = CGPoint(x: tile.uvs.start.x, y: 1 - tile.uvs.start.y)
        let origin = CGPoint(x: image.size.width * point.x, y: image.size.height * point.y)
        let size = CGSize(width: abs(tile.uvs.end.x - tile.uvs.start.x), height: abs(tile.uvs.end.y - tile.uvs.start.y))
        let sourceSize = CGSize(width: image.size.width * size.width, height: image.size.height * size.height)
        let destinationSize = CGSize(width: 128, height: 128)
        let source = CGRect(origin: origin, size: sourceSize)
        let destination = CGRect(origin: .zero, size: destinationSize)
        
        let blit = NSImage(size: destinationSize)
                
        blit.lockFocus()
        
        let transform = NSAffineTransform()
        
        transform.translateX(by: destinationSize.width, yBy: 0)
        transform.scaleX(by: -1, yBy: 1)
        transform.concat()
        
        image.draw(in: destination, from: source, operation: .copy, fraction: 1.0)
        
        blit.unlockFocus()
        
        return blit
    }
}
