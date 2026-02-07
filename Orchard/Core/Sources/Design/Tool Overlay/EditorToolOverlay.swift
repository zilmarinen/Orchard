//
//  EditorToolOverlay.swift
//  Core
//
//  Created by Zack Brown on 02/02/2026.
//

import AppKit
import Base

public protocol EditorToolOverlayDataSource: AnyObject {
    
    func editorToolOverlay(color overlay: EditorToolOverlay) -> NSColor?
    func editorToolOverlay(icon overlay: EditorToolOverlay) -> NSImage?
}

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
    }
    
    private lazy var optionsButton = with(NSButton(title: "Options",
                                                   target: self,
                                                   action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.imagePosition = .imageLeading
    }
    
    private weak var dataSource: EditorToolOverlayDataSource?
    private weak var delegate: EditorToolOverlayDelegate?
    
    public init(dataSource: EditorToolOverlayDataSource,
                delegate: EditorToolOverlayDelegate) {
        
        self.dataSource = dataSource
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
        
        reload()
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
    
    public func reload() {
        
        optionsButton.bezelColor = dataSource?.editorToolOverlay(color: self)
        optionsButton.image = dataSource?.editorToolOverlay(icon: self)
    }
}
