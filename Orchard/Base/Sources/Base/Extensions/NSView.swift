//
//  NSView.swift
//
//  Created by Zack Brown on 09/07/2025.
//

import AppKit

extension NSView {
    
    public func center(in view: NSView) {
        
        NSLayoutConstraint.activate([
            
            centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    public func pinEdges(to view: NSView) {
        
        NSLayoutConstraint.activate([
            
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}
