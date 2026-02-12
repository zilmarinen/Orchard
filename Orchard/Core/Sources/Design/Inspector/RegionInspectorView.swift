//
//  RegionInspectorView.swift
//  Core
//
//  Created by Zack Brown on 12/02/2026.
//

import AppKit
import Base

public class RegionInspectorView: InspectorGroupView {
    
    private lazy var coordinate = with(CoordinateControl()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.title = "Coordinate"
        $0.value = .init(1, 2, -3)
    }
    
    private lazy var textLabel = with(TextFieldControl()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.title = "Identifier"
    }
    
    required public init() {
        
        super.init(frame: .zero)
        
        addArrangedSubview(coordinate)
        addArrangedSubview(textLabel)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
