//
//  InspectorGridView.swift
//  Base
//
//  Created by Zack Brown on 07/08/2025.
//

import AppKit

open class InspectorGridView: InspectorView {
    
    private let gridView = with(NSGridView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.xPlacement = .fill
        $0.yPlacement = .center
        $0.columnSpacing = Constant.padding
        $0.rowSpacing = Constant.padding
    }
    
    override public init(title: String? = nil) {
        
        super.init(title: title)
        
        set(content: gridView)
    }
    
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
