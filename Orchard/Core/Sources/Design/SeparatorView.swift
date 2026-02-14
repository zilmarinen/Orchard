//
//  SeparatorView.swift
//  Core
//
//  Created by Zack Brown on 07/02/2026.
//

import AppKit
import Base

public class SeparatorView: NSView {
 
    required public init() {
        
        super.init(frame: .zero)
        
        wantsLayer = true
        layer?.backgroundColor = NSColor.separatorColor.cgColor
        setContentHuggingPriority(.defaultHigh,
                                  for: .vertical)
        
        NSLayoutConstraint.activate([
            
            heightAnchor.constraint(equalToConstant: 1.0)
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func viewWillMove(toSuperview newSuperview: NSView?) {
        
        super.viewWillMove(toSuperview: newSuperview)
        
        guard let superview else { return }
        
        NSLayoutConstraint.deactivate([
            
            leadingAnchor.constraint(equalTo: superview.leadingAnchor,
                                     constant: .padding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor,
                                     constant: -.padding),
        ])
    }
    
    public override func viewDidMoveToSuperview() {
        
        super.viewDidMoveToSuperview()
        
        guard let superview else { return }
        
        NSLayoutConstraint.activate([
            
            leadingAnchor.constraint(equalTo: superview.leadingAnchor,
                                     constant: .padding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor,
                                     constant: -.padding),
        ])
    }
}
