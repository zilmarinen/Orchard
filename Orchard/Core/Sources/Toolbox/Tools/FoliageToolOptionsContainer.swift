//
//  FoliageToolOptionsContainer.swift
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

internal class FoliageToolOptionsContainer: ToolOptionsStackContainer {
    
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
        
        addArrangedSubview(cursorStyle)
    }
}
