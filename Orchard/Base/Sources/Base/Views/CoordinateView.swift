//
//  CoordinateView.swift
//  Base
//
//  Created by Zack Brown on 25/07/2025.
//

import AppKit
import Deltille

public class CoordinateView: NSControl {
    
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
        $0.stringValue = "x"
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
        $0.stringValue = "y"
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
        $0.stringValue = "z"
    }
    
    // MARK: Fields
    
    private lazy var xField = with(NSTextField()) {
        
        $0.font = .systemFont(ofSize: NSFont.smallSystemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = true
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.placeholderString = "x"
    }
    
    private lazy var yField = with(NSTextField()) {
        
        $0.font = .systemFont(ofSize: NSFont.smallSystemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = true
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.placeholderString = "y"
    }
    
    private lazy var zField = with(NSTextField()) {
        
        $0.font = .systemFont(ofSize: NSFont.smallSystemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = true
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.placeholderString = "z"
    }
    
    // MARK: Stack views
    
    private lazy var stackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .horizontal
        $0.distribution = .fill
        $0.alignment = .centerY
        $0.addArrangedSubview(xStackView)
        $0.addArrangedSubview(yStackView)
        $0.addArrangedSubview(zStackView)
    }
    
    private lazy var xStackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .vertical
        $0.alignment = .centerX
        $0.addArrangedSubview(xField)
        $0.addArrangedSubview(xLabel)
    }
    
    private lazy var yStackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .vertical
        $0.alignment = .centerX
        $0.addArrangedSubview(yField)
        $0.addArrangedSubview(yLabel)
    }
    
    private lazy var zStackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .vertical
        $0.alignment = .centerX
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
