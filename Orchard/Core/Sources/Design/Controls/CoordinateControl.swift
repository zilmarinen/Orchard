//
//  CoordinateControl.swift
//  Core
//
//  Created by Zack Brown on 12/02/2026.
//

import AppKit
import Base
import Deltille

public class CoordinateControl: NSView {
    
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
    }
    
    // MARK: Stack view
    
    private lazy var stackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .top
        $0.spacing = .spacing
        $0.setHuggingPriority(.defaultHigh,
                              for: .horizontal)
        $0.setHuggingPriority(.defaultHigh,
                              for: .vertical)
        
        $0.addArrangedSubview(xLabel)
        $0.addArrangedSubview(yLabel)
        $0.addArrangedSubview(zLabel)
    }
    
    // MARK: Fields
    
    private lazy var xLabel = with(LabelControl()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentHuggingPriority(.defaultLow,
                                     for: .horizontal)
        $0.setContentHuggingPriority(.defaultLow,
                                     for: .vertical)
        $0.title = "X"
    }
    
    private lazy var yLabel = with(LabelControl()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentHuggingPriority(.defaultLow,
                                     for: .horizontal)
        $0.setContentHuggingPriority(.defaultLow,
                                     for: .vertical)
        $0.title = "Y"
    }
    
    private lazy var zLabel = with(LabelControl()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentHuggingPriority(.defaultLow,
                                     for: .horizontal)
        $0.setContentHuggingPriority(.defaultLow,
                                     for: .vertical)
        $0.title = "Z"
    }
    
    public var title: String {
        
        get { textLabel.stringValue }
        set { textLabel.stringValue = newValue }
    }
    
    public var value: Coordinate {
        
        get {
            
            .init(Int(xLabel.value) ?? 0,
                  Int(xLabel.value) ?? 0,
                  Int(xLabel.value) ?? 0)
        }
        set {
        
            xLabel.value = "\(newValue.x)"
            yLabel.value = "\(newValue.y)"
            zLabel.value = "\(newValue.z)"
        }
    }
    
    required public init() {
        
        super.init(frame: .zero)
        
        addSubview(textLabel)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: .padding),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -.padding),
            textLabel.topAnchor.constraint(equalTo: topAnchor,
                                           constant: .margin),
            
            stackView.topAnchor.constraint(equalTo: textLabel.bottomAnchor,
                                           constant: .margin),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: .padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -.padding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -.padding)
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
