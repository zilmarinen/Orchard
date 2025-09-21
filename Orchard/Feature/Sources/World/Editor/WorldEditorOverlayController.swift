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
    
    private lazy var triangleLabel = with(NSButton()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.bezelColor = .systemBlue
        $0.title = ""
    }
    
    private lazy var vertexLabel = with(NSButton()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.bezelColor = .systemMint
        $0.title = ""
    }
    
    private lazy var hexagonLabel = with(NSButton()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.bezelColor = .systemPurple
        $0.title = ""
    }
    
    // MARK: Stack views
    
    private lazy var stackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = Constant.spacing
        $0.addArrangedSubview(triangleLabel)
        $0.addArrangedSubview(vertexLabel)
        $0.addArrangedSubview(hexagonLabel)
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

    internal func update(triangle: Triangle) {
        
        triangleLabel.title = "T: " + triangle.vertex.id
    }
    
    internal func update(vertex: Triangle.Vertex) {
        
        vertexLabel.title = "V: " + vertex.id
    }
    
    internal func update(hexagon: Hexagon) {
        
        hexagonLabel.title = "H: " + hexagon.vertex.id
    }
}
