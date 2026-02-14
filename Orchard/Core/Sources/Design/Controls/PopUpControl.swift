//
//  PopUpControl.swift
//  Core
//
//  Created by Zack Brown on 07/02/2026.
//

import AppKit
import Base

public class PopUpControl<V: Identifiable>: NSView where V.ID == String {
    
    public typealias ValueDidChange = ((V) -> Void)
    
    // MARK: Label
    
    private lazy var textLabel = with(NSTextField()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: NSFont.systemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = false
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.alignment = .left
        $0.stringValue = title
    }
    
    // MARK: Control
    
    private lazy var popUp = with(NSPopUpButton(title: title,
                                                target: self,
                                                action: #selector(popUpButton(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addItems(withTitles: values.map { $0.id })
        
        guard let selected else { return }
        
        $0.selectItem(withTitle: selected.id)
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
        addSubview(popUp)
        
        NSLayoutConstraint.activate([
            
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: .padding),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -.padding),
            textLabel.topAnchor.constraint(equalTo: topAnchor,
                                           constant: .padding),
            
            popUp.topAnchor.constraint(equalTo: textLabel.bottomAnchor,
                                       constant: .margin),
            
            popUp.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: .padding),
            popUp.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -.padding),
            popUp.bottomAnchor.constraint(equalTo: bottomAnchor,
                                          constant: -.padding)
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc
    private func popUpButton(_ sender: NSPopUpButton) {
        
        guard sender.indexOfSelectedItem >= 0,
              sender.indexOfSelectedItem < values.count else { return }
        
        let value = values[sender.indexOfSelectedItem]
        
        valueDidChange?(value)
    }
}
