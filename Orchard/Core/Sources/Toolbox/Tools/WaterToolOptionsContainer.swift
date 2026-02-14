//
//  WaterToolOptionsContainer.swift
//  Core
//
//  Created by Zack Brown on 09/02/2026.
//

import AppKit
import Base
import Design
import Harvest

internal class WaterToolOptionsContainer: ToolOptionsStackContainer {
    
    private lazy var material = with(PopUpControl(title: "Fluid",
                                                  values: WaterType.allCases,
                                                  selected: viewModel.waterType)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.valueDidChange = { [weak self] value in
            
            guard let self else { return }
            
            self.viewModel.select(waterType: value)
            self.colorPalette.value = value.colorPalette
        }
    }
    
    private lazy var colorPalette = with(ColorPaletteControl(value: viewModel.waterType.colorPalette)) {
        
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
