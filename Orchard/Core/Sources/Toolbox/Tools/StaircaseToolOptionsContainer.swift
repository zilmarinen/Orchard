//
//  StaircaseToolOptionsContainer.swift
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
import Newel

internal class StaircaseToolOptionsContainer: ToolOptionsStackContainer {
    
    private lazy var shape = with(PopUpControl(title: "Shape",
                                               values: StaircaseType.allCases,
                                               selected: viewModel.staircaseType)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.valueDidChange = { [weak self] value in
            
            guard let self else { return }
            
            self.viewModel.select(staircaseType: value)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addArrangedSubview(shape)
    }
}
