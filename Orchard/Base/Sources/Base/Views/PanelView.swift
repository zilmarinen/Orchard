//
//  PanelView.swift
//  Base
//
//  Created by Zack Brown on 25/07/2025.
//

import AppKit

public class PanelView: NSView {
    
    private enum Constant {
        
        static let columnWidthMultiplier = 0.33
        static let cornerRadius = 4.0
        static let padding = 6.0
    }
    
    // MARK: Content View
    
    private let contentView = with(NSView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.wantsLayer = true
        $0.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        $0.layer?.cornerRadius = Constant.cornerRadius
    }
    
    private let groupView = with(NSView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.wantsLayer = true
        $0.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
        $0.layer?.cornerRadius = Constant.cornerRadius
    }
    
    private let titleLabel = with(NSTextField()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: NSFont.smallSystemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = false
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.alignment = .left
    }
    
    private let gridView = with(NSGridView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.xPlacement = .fill
        $0.yPlacement = .center
        $0.columnSpacing = Constant.padding
        $0.rowSpacing = Constant.padding
        $0.setContentHuggingPriority(.defaultHigh,
                                     for: .vertical)
    }
    
    public var title: String? {
        
        get { titleLabel.stringValue }
        set { titleLabel.stringValue = newValue ?? "" }
    }
    
    public required init(title: String? = nil) {
        
        super.init(frame: .zero)
        
        self.title = title
        
        addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(groupView)
        groupView.addSubview(gridView)
        
        NSLayoutConstraint.activate([
            
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                             constant: Constant.padding),
            contentView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor,
                                              constant: Constant.padding),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                constant: -Constant.padding),
            contentView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor,
                                               constant: -Constant.padding),
            
            titleLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor,
                                             constant: Constant.padding),
            titleLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.rightAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor,
                                            constant: Constant.padding),
            
            groupView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                          constant: Constant.padding),
            groupView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor,
                                           constant: Constant.padding),
            groupView.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor,
                                            constant: -Constant.padding),
            groupView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor,
                                             constant: -Constant.padding),
            
            gridView.topAnchor.constraint(equalTo: groupView.topAnchor,
                                             constant: Constant.padding),
            gridView.leftAnchor.constraint(equalTo: groupView.leftAnchor,
                                              constant: Constant.padding),
            gridView.bottomAnchor.constraint(equalTo: groupView.bottomAnchor,
                                                constant: -Constant.padding),
            gridView.rightAnchor.constraint(equalTo: groupView.rightAnchor,
                                               constant: -Constant.padding),
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func layout() {
        
        super.layout()
        
        let column = gridView.column(at: 0)
        
        column.width = gridView.frame.width * Constant.columnWidthMultiplier
        column.xPlacement = .trailing
    }
}

extension PanelView {
    
    public func addRow(label: String,
                       detail: NSControl) {
        
        let field = with(NSTextField()) {
            
            $0.font = .systemFont(ofSize: NSFont.smallSystemFontSize)
            $0.textColor = .lightGray
            $0.isEditable = false
            $0.isBordered = false
            $0.maximumNumberOfLines = 1
            $0.backgroundColor = .clear
            $0.alignment = .right
            $0.stringValue = label
        }
        
        gridView.addRow(with: [field,
                               detail])
    }
}
