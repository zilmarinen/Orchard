//
//  BuildingToolOptionsContainer.swift
//  Core
//
//  Created by Zack Brown on 09/02/2026.
//

import AppKit
import Base
import Deltille
import Design
import Harvest
import Lattice

internal class BuildingToolOptionsContainer: ToolOptionsStackContainer {
    
    private lazy var shape = with(PopUpControl(title: "Shape",
                                               values: Triangle.Septomino.allCases,
                                               selected: viewModel.septomino)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.valueDidChange = { [weak self] value in
            
            guard let self else { return }
            
            self.viewModel.select(septomino: value)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addArrangedSubview(shape)
    }
}
