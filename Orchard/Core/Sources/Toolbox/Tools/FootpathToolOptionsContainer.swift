//
//  FootpathToolOptionsContainer.swift
//  Core
//
//  Created by Zack Brown on 09/02/2026.
//

import AppKit
import Base
import Design
import Harvest

internal class FootpathToolOptionsContainer: ToolOptionsStackContainer {
    
    private lazy var material = with(PopUpControl(title: "Material",
                                                  values: FootpathType.allCases,
                                                  selected: viewModel.footpathType)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.valueDidChange = { [weak self] value in
            
            guard let self else { return }
            
            self.viewModel.select(footpathType: value)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addArrangedSubview(material)
    }
}
