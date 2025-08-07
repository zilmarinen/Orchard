//
//  CoordinateView.swift
//  Base
//
//  Created by Zack Brown on 25/07/2025.
//

import AppKit
import Deltille

public class CoordinateView: NSControl {
    
    internal enum Constant {
        
        static let spacing = 8.0
    }
    
    // MARK: Labels
    
    private let xLabel = with(NSTextField()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: NSFont.smallSystemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = false
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.alignment = .center
        $0.stringValue = "X"
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
    }
    
    private let yLabel = with(NSTextField()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: NSFont.smallSystemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = false
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.alignment = .center
        $0.stringValue = "Y"
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
    }
    
    private let zLabel = with(NSTextField()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: NSFont.smallSystemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = false
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.alignment = .center
        $0.stringValue = "Z"
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
    }
    
    // MARK: Fields
    
    private lazy var xField = with(NSTextField()) {
        
        $0.font = .systemFont(ofSize: NSFont.smallSystemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = true
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.alignment = .center
        $0.placeholderString = "x"
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
    }
    
    private lazy var yField = with(NSTextField()) {
        
        $0.font = .systemFont(ofSize: NSFont.smallSystemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = true
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.alignment = .center
        $0.placeholderString = "y"
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
    }
    
    private lazy var zField = with(NSTextField()) {
        
        $0.font = .systemFont(ofSize: NSFont.smallSystemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = true
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.alignment = .center
        $0.placeholderString = "z"
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
    }
    
    // MARK: Stack views
    
    private lazy var stackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .top
        $0.spacing = Constant.spacing
        $0.setContentHuggingPriority(.required,
                                     for: .horizontal)
        $0.addArrangedSubview(xStackView)
        $0.addArrangedSubview(yStackView)
        $0.addArrangedSubview(zStackView)
    }
    
    private lazy var xStackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .vertical
        $0.alignment = .centerX
        $0.spacing = 0
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
        $0.addArrangedSubview(xField)
        $0.addArrangedSubview(xLabel)
    }
    
    private lazy var yStackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .vertical
        $0.alignment = .centerX
        $0.spacing = 0
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
        $0.addArrangedSubview(yField)
        $0.addArrangedSubview(yLabel)
    }
    
    private lazy var zStackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .vertical
        $0.alignment = .centerX
        $0.spacing = 0
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
        $0.addArrangedSubview(zField)
        $0.addArrangedSubview(zLabel)
    }
    
    public var coordinate: Coordinate {
        
        get {
            
            Coordinate(xField.integerValue,
                       yField.integerValue,
                       zField.integerValue)
        }
        set {
            
            xField.integerValue = newValue.x
            yField.integerValue = newValue.y
            zField.integerValue = newValue.z
        }
    }
    
    public required init(title: String? = nil) {
        
        super.init(frame: .zero)
        
        addSubview(stackView)
        
        stackView.pinEdges(to: self)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
