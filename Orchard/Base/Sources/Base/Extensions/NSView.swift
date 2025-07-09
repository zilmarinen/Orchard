//
//  NSView.swift
//  Base
//
//  Created by Zack Brown on 09/07/2025.
//

import AppKit

extension NSView {
    
    public func center(in view: NSView) {
        
        NSLayoutConstraint.activate([
            
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    public func pinEdges(to view: NSView) {
        
        NSLayoutConstraint.activate([
            
            topAnchor.constraint(equalTo: view.topAnchor),
            leftAnchor.constraint(equalTo: view.leftAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}
