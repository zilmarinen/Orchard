//
//  NSWindowController.swift
//  Base
//
//  Created by Zack Brown on 19/05/2026.
//

import AppKit
import Foundation

public extension NSWindowController {
    
    func present(error: Error) {
        
        guard let window else { fatalError(error.localizedDescription) }
        
        let alert = NSAlert(error: error)
        
        alert.beginSheetModal(for: window)
    }
}
