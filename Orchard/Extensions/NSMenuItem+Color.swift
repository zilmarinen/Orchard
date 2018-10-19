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
        
        self.image = NSImage(size: NSSize(width: 28, height: 12), flipped: false, drawingHandler: { rect -> Bool in
            
            color.setFill()
            
            rect.fill()
            
            return true
        })
    }
}
