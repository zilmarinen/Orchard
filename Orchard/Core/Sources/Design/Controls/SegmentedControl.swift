//
//  SegmentedControl.swift
//  Core
//
//  Created by Zack Brown on 08/02/2026.
//

import AppKit
import Base

public class SegmentedControl<V: HasIcon>: NSView {
    
    public typealias ValueDidChange = ((V) -> Void)
    
    private lazy var textLabel = with(NSTextField()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: NSFont.systemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = false
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.alignment = .left
        $0.stringValue = title
    }
    
    private lazy var segmentedControl = with(NSSegmentedControl(images: values.map { $0.image },
                                                                trackingMode: .selectOne,
                                                                target: self,
                                                                action: #selector(segmentedControl(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.toolTip = title
        
        guard let selected,
              let index = values.firstIndex(of: selected) else { return }
        
        $0.setSelected(true,
                       forSegment: index)
    }
    
    private let title: String
    private let values: [V]
    private let selected: V?
    
    public var valueDidChange: ValueDidChange?
    
    public init(title: String,
                values: [V],
                selected: V? = nil) {
    
        self.title = title
        self.values = values
        self.selected = selected
        
        super.init(frame: .zero)
        
        addSubview(textLabel)
        addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: .padding),
            textLabel.topAnchor.constraint(equalTo: topAnchor,
                                           constant: .padding),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            segmentedControl.leadingAnchor.constraint(greaterThanOrEqualTo: textLabel.trailingAnchor,
                                                      constant: .padding),
            segmentedControl.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                       constant: -.padding)
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc
    private func segmentedControl(_ sender: NSSegmentedControl) {
        
        guard sender.indexOfSelectedItem >= 0,
              sender.indexOfSelectedItem < values.count else { return }
        
        let value = values[sender.indexOfSelectedItem]
        
        valueDidChange?(value)
    }
}
