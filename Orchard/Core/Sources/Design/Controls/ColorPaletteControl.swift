//
//  ColorPaletteControl.swift
//  Core
//
//  Created by Zack Brown on 13/02/2026.
//

import Alluvium
import AppKit
import Base

public class ColorPaletteControl: NSView {
    
    // MARK: Stack view
    
    private lazy var stackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .top
        $0.spacing = 0
        $0.setHuggingPriority(.defaultHigh,
                              for: .horizontal)
        $0.setHuggingPriority(.defaultHigh,
                              for: .vertical)
        $0.wantsLayer = true
        $0.layer?.backgroundColor = NSColor.systemFill.cgColor
        $0.layer?.cornerRadius = .cornerRadius
        $0.layer?.borderColor = NSColor.unemphasizedSelectedContentBackgroundColor.cgColor
        $0.layer?.borderWidth = .borderWidth
        
        $0.addArrangedSubview(primary)
        $0.addArrangedSubview(tertiary)
        $0.addArrangedSubview(secondary)
        $0.addArrangedSubview(quaternary)
    }
    
    // MARK: Views
    
    private lazy var primary = with(NSView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.wantsLayer = true
        $0.setContentHuggingPriority(.defaultLow,
                                     for: .horizontal)
        $0.setContentHuggingPriority(.defaultLow,
                                     for: .vertical)
    }
    
    private lazy var secondary = with(NSView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.wantsLayer = true
        $0.setContentHuggingPriority(.defaultLow,
                                     for: .horizontal)
        $0.setContentHuggingPriority(.defaultLow,
                                     for: .vertical)
    }
    
    private lazy var tertiary = with(NSView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.wantsLayer = true
        $0.setContentHuggingPriority(.defaultLow,
                                     for: .horizontal)
        $0.setContentHuggingPriority(.defaultLow,
                                     for: .vertical)
    }
    
    private lazy var quaternary = with(NSView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.wantsLayer = true
        $0.setContentHuggingPriority(.defaultLow,
                                     for: .horizontal)
        $0.setContentHuggingPriority(.defaultLow,
                                     for: .vertical)
    }
    
    public var value: ColorPalette {
        
        didSet { reload() }
    }
    
    required public init(value: ColorPalette) {
        
        self.value = value
        
        super.init(frame: .zero)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: topAnchor,
                                           constant: .padding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: .padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -.padding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -.padding),
            stackView.heightAnchor.constraint(equalToConstant: .defaultControlHeight)
        ])
        
        reload()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func reload() {
        
        primary.layer?.backgroundColor = NSColor(value.primary).cgColor
        secondary.layer?.backgroundColor = NSColor(value.secondary).cgColor
        tertiary.layer?.backgroundColor = NSColor(value.tertiary).cgColor
        quaternary.layer?.backgroundColor = NSColor(value.quaternary).cgColor
        
        setNeedsDisplay(bounds)
    }
}
