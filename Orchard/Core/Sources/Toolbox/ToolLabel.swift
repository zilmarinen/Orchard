//
//  ToolLabel.swift
//  Core
//
//  Created by Zack Brown on 07/02/2026.
//

import AppKit
import Base

internal class ToolLabel: NSView {
    
    private lazy var imageView = with(NSImageView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.imageAlignment = .alignCenter
        $0.contentTintColor = tool.color
        $0.image = tool.image
    }
    
    private lazy var textLabel = with(NSTextField()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: NSFont.systemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = false
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.alignment = .left
        $0.stringValue = tool.id
    }
    
    private let tool: Tool
    
    required internal init(tool: Tool) {
    
        self.tool = tool
        
        super.init(frame: .zero)
        
        addSubview(imageView)
        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: .padding),
            imageView.topAnchor.constraint(equalTo: topAnchor,
                                           constant: .margin),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            textLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                               constant: .margin),
            textLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            textLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor,
                                                constant: -.padding)
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
