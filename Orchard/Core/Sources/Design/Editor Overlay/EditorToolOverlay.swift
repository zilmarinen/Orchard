//
//  EditorToolOverlay.swift
//  Core
//
//  Created by Zack Brown on 02/02/2026.
//

import AppKit
import Base

public protocol EditorToolOverlayDelegate: AnyObject {
    
    func editorToolOverlay(_ overlay: EditorToolOverlay,
                           didTapTool button: NSButton)
    func editorToolOverlay(_ overlay: EditorToolOverlay,
                           didTapOptions button: NSButton)
}

public class EditorToolOverlay: NSView {
    
    // MARK: Stack View
    
    private lazy var stackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .horizontal
        $0.alignment = .top
        $0.distribution = .equalSpacing
        $0.spacing = .spacing
        
        $0.addArrangedSubview(toolButton)
        $0.addArrangedSubview(optionsButton)
    }
    
    // MARK: Buttons
    
    private lazy var toolButton = with(NSButton(image: NSImage(icon: .hammer)!,
                                                target: self,
                                                action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.bezelColor = .controlAccentColor
    }
    
    private lazy var optionsButton = with(NSButton(image: NSImage(icon: .slider)!,
                                                   target: self,
                                                   action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private weak var delegate: EditorToolOverlayDelegate?
    
    public init(delegate: EditorToolOverlayDelegate) {
        
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                            constant: .padding),
            stackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor,
                                             constant: .padding),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            stackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension EditorToolOverlay {
    
    @objc
    private func button(_ sender: NSButton) {
        
        switch sender {
            
        case toolButton:
            
            delegate?.editorToolOverlay(self,
                                        didTapTool: toolButton)
            
        case optionsButton:
            
            delegate?.editorToolOverlay(self,
                                        didTapOptions: optionsButton)
            
        default: fatalError("Invalid sender for button")
        }
    }
}
