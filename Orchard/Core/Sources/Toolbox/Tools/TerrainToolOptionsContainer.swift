//
//  TerrainToolOptionsContainer.swift
//  Core
//
//  Created by Zack Brown on 08/02/2026.
//

import AppKit
import Base
import Design
import Harvest

internal class TerrainToolOptionsContainer: ToolOptionsStackContainer {
    
    private lazy var material = with(PopUpControl(title: "Biome",
                                                  values: Biome.allCases,
                                                  selected: viewModel.biome)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.valueDidChange = { [weak self] value in
            
            guard let self else { return }
            
            self.viewModel.select(biome: value)
            self.colorPalette.value = value.terrain
        }
    }
    
    private lazy var colorPalette = with(ColorPaletteControl(value: viewModel.biome.terrain)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var cursorStyle = with(SegmentedControl(title: "Cursor",
                                                         values: viewModel.cursorStyles,
                                                         selected: viewModel.cursorStyle)) {
            
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.valueDidChange = { [weak self] value in
            
            guard let self else { return }
            
            self.viewModel.select(cursorStyle: value)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addArrangedSubview(material)
        addArrangedSubview(colorPalette)
        addArrangedSubview(SeparatorView())
        addArrangedSubview(cursorStyle)
    }
}
