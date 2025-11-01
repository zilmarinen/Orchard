//
//  SidebarGroupView.swift
//
//  Created by Zack Brown on 24/07/2025.
//

import AppKit

public class SidebarGroupView: NSTableRowView {
    
    private enum Constant {
        
        static let padding = 2.0
    }
    
    private lazy var textLabel = with(NSTextField()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: NSFont.smallSystemFontSize)
        $0.isEditable = false
        $0.isBordered = false
        $0.maximumNumberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.backgroundColor = .clear
    }
    
    public var text: String? {
        
        get { textLabel.stringValue }
        set { textLabel.stringValue = newValue?.uppercased() ?? "" }
    }
    
    public required init() {
        
        super.init(frame: .zero)
        
        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            
            textLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor,
                                            constant: Constant.padding),
            textLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            textLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
