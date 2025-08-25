//
//  WorldEditorOverlayController.swift
//  Feature
//
//  Created by Zack Brown on 12/08/2025.
//

import AppKit
import Base
import Deltille
import Euclid

internal class WorldEditorOverlayController: NSViewController {
    
    internal enum Constant {
        
        static let padding = 8.0
        static let spacing = 8.0
    }
    
    // MARK: Labels
    
    private lazy var mouseLabel = with(NSButton()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.bezelColor = .systemRed
    }
    
    private lazy var cursorLabel = with(NSButton()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.bezelColor = .systemGreen
    }
    
    private lazy var coordinateLabel = with(NSButton()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.bezelColor = .systemBlue
    }
    
    // MARK: Stack views
    
    private lazy var stackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = Constant.spacing
        $0.addArrangedSubview(mouseLabel)
        $0.addArrangedSubview(cursorLabel)
        $0.addArrangedSubview(coordinateLabel)
    }
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: Constant.padding),
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                            constant: Constant.padding),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}

extension WorldEditorOverlayController {
    
    internal func update(mouse: CGPoint) {
        
        mouseLabel.title = "[\(String(format: "%.0f, %.0f", mouse.x, mouse.y))]"
    }
    
    internal func update(cursor: Vector) {
        
        cursorLabel.title = "[\(String(format: "%.2f, %.2f, %.2f", cursor.x, cursor.y, cursor.z))]"
    }
    
    internal func update(coordinate: Grid.Coordinate) {
        
        coordinateLabel.title = coordinate.id
    }
}
