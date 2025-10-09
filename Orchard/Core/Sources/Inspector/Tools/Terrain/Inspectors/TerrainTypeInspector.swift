//
//  TerrainTypeInspector.swift
//  Core
//
//  Created by Zack Brown on 02/10/2025.
//

import AppKit
import Base

internal class TerrainTypeInspector: InspectorGridView {
    
    private enum Constant {
        
        static let materialViewHeightMultiplier = 0.5
        static let borderWidth = 1.0
        static let cornerRadius = 4.0
    }
    
    private lazy var terrainTypePopUp = with(NSPopUpButton(title: "Terrain Type",
                                                           target: self,
                                                           action: #selector(popUpButton(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addItems(withTitles: viewModel.terrainTypes.map { $0.id })
        $0.selectItem(withTitle: viewModel.terrainType.id)
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
    }
    
    private lazy var materialView = with(TerrainMaterialView(viewModel: viewModel)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.wantsLayer = true
        $0.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
        $0.layer?.borderColor = NSColor.controlColor.cgColor
        $0.layer?.borderWidth = Constant.borderWidth
        $0.layer?.cornerRadius = Constant.cornerRadius
    }
    
    private let viewModel: TerrainInspectorViewModel
    
    internal required init(viewModel: TerrainInspectorViewModel) {
        
        self.viewModel = viewModel
        
        super.init(title: "Material")
        
        addRow(label: "Biome",
               detail: terrainTypePopUp)
        addArrangedSubview(materialView)
        
        NSLayoutConstraint.activate([

            materialView.heightAnchor.constraint(equalTo: materialView.widthAnchor,
                                                 multiplier: Constant.materialViewHeightMultiplier)
        ])
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension TerrainTypeInspector {
    
    @objc
    internal func popUpButton(_ sender: NSPopUpButton) {
        
        switch sender {
            
        case terrainTypePopUp:
            
            let terrainType = viewModel.terrainType(at: sender.indexOfSelectedItem)
            
            viewModel.select(terrainType: terrainType)
            
            materialView.setNeedsDisplay()
            
        default: break
        }
    }
}
