//
//  NSMenuItem+Color.swift
//  Orchard
//
//  Created by Zack Brown on 12/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import AppKit

extension NSMenuItem {
    
    func set(color: NSColor) {
        
        self.image = NSImage(size: NSSize(width: 24, height: 12), flipped: false, drawingHandler: { rect -> Bool in
            
            color.setFill()
            
            rect.fill()
            
            return true
        })
    }
    
    func set(color0: NSColor, color1: NSColor) {
        
        self.image = NSImage(size: NSSize(width: 24, height: 12), flipped: false, drawingHandler: { rect -> Bool in
            
            let r0 = NSRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height / 2)
            let r1 = NSRect(x: rect.origin.x, y: rect.origin.y + (rect.size.height / 2), width: rect.size.width, height: rect.size.height / 2)
            
            color0.setFill()
            
            r1.fill()
            
            color1.setFill()
            
            r0.fill()
            
            return true
        })
    }
}
