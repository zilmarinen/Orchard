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
    
    private lazy var biome = with(PopUpControl(title: "Biome",
                                               values: Biome.allCases,
                                               selected: viewModel.biome)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.valueDidChange = { [weak self] value in
            
            guard let self else { return }
            
            self.viewModel.select(biome: value)
        }
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
        
        addArrangedSubview(biome)
        addArrangedSubview(SeparatorView())
        addArrangedSubview(cursorStyle)
    }
}
