//
//  RegionInspectorView.swift
//  Core
//
//  Created by Zack Brown on 12/02/2026.
//

import AppKit
import Base
import Design

internal protocol RegionInspectorViewDelegate: AnyObject {
    
    func regionInspectorView(_ view: RegionInspectorView,
                             didUpdate identifier: String)
}

internal class RegionInspectorView: InspectorGroupView {
    
    private lazy var coordinate = with(CoordinateControl(title: "Coordinate",
                                                         value: viewModel.vertex.position)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.toolTip = "Region Coordinate"
    }
    
    private lazy var textLabel = with(TextFieldControl(title: "Identifier",
                                                       value: viewModel.identifier)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.toolTip = "Region Identifier"
        
        $0.valueDidChange = { [weak self] value in
        
            guard let self else { return }
            
            self.delegate?.regionInspectorView(self,
                                               didUpdate: value)
        }
    }
    
    private let viewModel: RegionInspectorViewModel
    private weak var delegate: RegionInspectorViewDelegate?
    
    internal init(viewModel: RegionInspectorViewModel,
                  delegate: RegionInspectorViewDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        title = "Region"
        
        addArrangedSubview(coordinate)
        
        guard viewModel.hasIntermediate else { return }
        
        addArrangedSubview(textLabel)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
