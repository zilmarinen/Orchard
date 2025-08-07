//
//  InspectorStackView.swift
//  Base
//
//  Created by Zack Brown on 07/08/2025.
//

import AppKit

open class InspectorStackView: InspectorView {
    
    private lazy var stackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .vertical
        $0.alignment = .leading
        $0.distribution = .fill
        $0.spacing = Constant.spacing
    }
    
    override public init(title: String? = nil) {
        
        super.init(title: title)
        
        set(content: stackView)
    }
    
    public func addArrangedSubview(_ view: NSView) {
        
        stackView.addArrangedSubview(view)
    }
}
