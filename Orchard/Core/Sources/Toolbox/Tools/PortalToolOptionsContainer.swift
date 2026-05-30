//
//  PortalToolOptionsContainer.swift
//  Core
//
//  Created by Zack Brown on 15/02/2026.
//

import AppKit
import Base
import Design

internal class PortalToolOptionsContainer: ToolOptionsStackContainer {
    
    private lazy var coordinate = with(CoordinateControl(title: "Coordinate",
                                                         value: .zero)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var textLabel = with(TextFieldControl(title: "Identifier",
                                                       value: "portal identifier goes here")) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.valueDidChange = { [weak self] value in
        
            guard let self else { return }
            
            //
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addArrangedSubview(coordinate)
        addArrangedSubview(textLabel)
    }
}
