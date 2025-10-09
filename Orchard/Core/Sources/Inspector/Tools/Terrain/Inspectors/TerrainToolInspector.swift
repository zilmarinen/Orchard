//
//  TerrainToolInspector.swift
//  Core
//
//  Created by Zack Brown on 02/10/2025.
//

import AppKit
import Base

internal class TerrainToolInspector: InspectorStackView {
    
    private lazy var toolTypePopUp = with(NSPopUpButton(title: "Tool",
                                                        target: self,
                                                        action: #selector(popUpButton(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        //$0.addItems(withTitles: viewModel.terrainTypes.map { $0.id })
        //$0.selectItem(withTitle: viewModel.terrainType.id)
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
    }
    
    private let viewModel: TerrainInspectorViewModel
    
    internal required init(viewModel: TerrainInspectorViewModel) {
        
        self.viewModel = viewModel
        
        super.init(title: "Tool")
        
        addArrangedSubview(toolTypePopUp)
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension TerrainToolInspector {
    
    @objc
    internal func popUpButton(_ sender: NSPopUpButton) {
        
        switch sender {
            
        default: break
        }
    }
}
