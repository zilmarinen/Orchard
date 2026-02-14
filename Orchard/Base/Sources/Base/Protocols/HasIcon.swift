//
//  HasIcon.swift
//  Base
//
//  Created by Zack Brown on 08/02/2026.
//

import AppKit

public protocol HasIcon: Equatable {
    
    var icon: NSImage.Icon { get }
    
    var image: NSImage { get }
}

extension HasIcon {
    
    public var image: NSImage { NSImage(icon: icon)! }
}
