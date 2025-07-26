//
//  SidebarItemView.swift
//  Base
//
//  Created by Zack Brown on 21/07/2025.
//

import AppKit

public class SidebarItemView: NSTableRowView {
    
    private enum Constant {
        
        static let padding = 2.0
    }
    
    private lazy var imageView = with(NSImageView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.imageAlignment = .alignCenter
        $0.contentTintColor = .controlAccentColor
    }
    
    private lazy var textLabel = with(NSTextField()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: NSFont.smallSystemFontSize)
        $0.isEditable = false
        $0.isBordered = false
        $0.maximumNumberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.backgroundColor = .clear
    }
    
    private lazy var badgeLabel = with(NSTextField()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: NSFont.smallSystemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = false
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
    }
    
    public var image: NSImage? {
        
        get { imageView.image }
        set { imageView.image = newValue }
    }
    
    public var text: String? {
        
        get { textLabel.stringValue }
        set { textLabel.stringValue = newValue ?? "" }
    }
    
    public var badge: String? {
        
        get { badgeLabel.stringValue }
        set { badgeLabel.stringValue = newValue ?? "" }
    }
    
    public required init() {
        
        super.init(frame: .zero)
        
        addSubview(imageView)
        addSubview(textLabel)
        addSubview(badgeLabel)
        
        NSLayoutConstraint.activate([
            
            imageView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor,
                                            constant: Constant.padding),
            imageView.topAnchor.constraint(equalTo: textLabel.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: textLabel.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            textLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            textLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor,
                                            constant: Constant.padding),
            
            badgeLabel.leftAnchor.constraint(equalTo: textLabel.rightAnchor,
                                             constant: Constant.padding),
            badgeLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            badgeLabel.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualTo: badgeLabel.heightAnchor),
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
