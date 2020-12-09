//
//  NSStoryboard.swift
//  Orchard
//
//  Created by Zack Brown on 07/12/2020.
//

import Cocoa

extension NSStoryboard {
    
    static let inspector = NSStoryboard(name: NSStoryboard.Name("Inspector"), bundle: nil)
    static let main = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    static let utility = NSStoryboard(name: NSStoryboard.Name("Utility"), bundle: nil)
}
