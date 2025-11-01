//
//  InspectorGridView.swift
//  Base
//
//  Created by Zack Brown on 07/08/2025.
//

import AppKit

open class InspectorGridView: InspectorStackView {
    
    private let gridView = with(NSGridView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.xPlacement = .fill
        $0.yPlacement = .center
        $0.columnSpacing = Constant.padding
        $0.rowSpacing = Constant.padding
    }
    
    public override init(title: String? = nil,
                         accentColor: NSColor) {
        
        super.init(title: title,
                   accentColor: accentColor)
        
        addArrangedSubview(gridView)
    }
    
    public func addRow(label: String? = nil,
                       detail: NSControl) {
        
        detail.setContentHuggingPriority(.low,
                                         for: .horizontal)
        
        let field = with(NSTextField()) {
            
            $0.font = .systemFont(ofSize: NSFont.smallSystemFontSize)
            $0.textColor = .lightGray
            $0.isEditable = false
            $0.isBordered = false
            $0.maximumNumberOfLines = 1
            $0.backgroundColor = .clear
            $0.alignment = .right
            $0.stringValue = label ?? ""
        }
        
        gridView.addRow(with: [field,
                               detail])
    }
}
