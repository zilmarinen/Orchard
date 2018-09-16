//
//  ColorPaletteView.swift
//  Orchard
//
//  Created by Zack Brown on 01/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow

class ColorPaletteView: NSView {

    @IBOutlet public weak var primaryColor: NSBox!
    @IBOutlet public weak var secondaryColor: NSBox!
    @IBOutlet public weak var tertiaryColor: NSBox!
    @IBOutlet public weak var quaternaryColor: NSBox!
    
    public var colorPalette: ColorPalette? {
        
        didSet {
            
            if let colorPalette = colorPalette {
                
                primaryColor.fillColor = colorPalette.primary.color
                secondaryColor.fillColor = colorPalette.secondary.color
                tertiaryColor.fillColor = colorPalette.tertiary.color
                quaternaryColor.fillColor = colorPalette.quaternary.color
            }
            else {
                
                primaryColor.fillColor = NSColor.controlBackgroundColor
                secondaryColor.fillColor = NSColor.controlBackgroundColor
                tertiaryColor.fillColor = NSColor.controlBackgroundColor
                quaternaryColor.fillColor = NSColor.controlBackgroundColor
            }
        }
    }
    
    public var color: Color? {
        
        didSet {
            
            if let color = color {
                
                primaryColor.fillColor = color.color
                secondaryColor.fillColor = color.color
                tertiaryColor.fillColor = color.color
                quaternaryColor.fillColor = color.color
            }
            else {
                
                primaryColor.fillColor = NSColor.controlBackgroundColor
                secondaryColor.fillColor = NSColor.controlBackgroundColor
                tertiaryColor.fillColor = NSColor.controlBackgroundColor
                quaternaryColor.fillColor = NSColor.controlBackgroundColor
            }
        }
    }
}
