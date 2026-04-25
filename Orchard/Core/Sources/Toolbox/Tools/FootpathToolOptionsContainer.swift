//
//  FootpathToolOptionsContainer.swift
//  Core
//
//  Created by Zack Brown on 09/02/2026.
//

import AppKit
import Base
import Cobble
import Design
import Harvest

internal class FootpathToolOptionsContainer: ToolOptionsStackContainer {
    
    private lazy var design = with(PopUpControl(title: "Design",
                                                values: Design.allCases,
                                                selected: viewModel.design)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.valueDidChange = { [weak self] value in
            
            guard let self else { return }
            
            self.viewModel.select(design: value)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addArrangedSubview(design)
    }
}
