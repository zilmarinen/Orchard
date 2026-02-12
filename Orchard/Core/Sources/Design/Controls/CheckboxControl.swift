//
//  CheckboxControl.swift
//  Core
//
//  Created by Zack Brown on 12/02/2026.
//

import AppKit
import Base

public class CheckboxControl: NSView {
    
    // MARK: Control
    
    private lazy var checkbox = with(NSButton(checkboxWithTitle: "",
                                              target: self,
                                              action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: NSFont.systemFontSize)
    }
    
    public var title: String {
        
        get { checkbox.stringValue }
        set {
            
            checkbox.title = newValue
            checkbox.toolTip = newValue
        }
    }
    
    public var value: Bool {
        
        get { checkbox.state == .on }
        set { checkbox.state = newValue ? .on : .off }
    }
    
    required public init() {
        
        super.init(frame: .zero)
        
        addSubview(checkbox)
        
        NSLayoutConstraint.activate([
            
            checkbox.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: .padding),
            checkbox.topAnchor.constraint(equalTo: topAnchor,
                                          constant: .margin),
            checkbox.bottomAnchor.constraint(equalTo: bottomAnchor,
                                             constant: -.margin),
            checkbox.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -.padding)
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc
    private func button(_ sender: NSButton) {
        
    }
}
