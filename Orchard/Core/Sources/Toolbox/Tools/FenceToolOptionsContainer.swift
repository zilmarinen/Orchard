//
//  FenceToolOptionsContainer.swift
//  Core
//
//  Created by Zack Brown on 03/05/2026.
//

import AppKit
import Base
import Design
import Harvest
import Palisade

internal class FenceToolOptionsContainer: ToolOptionsStackContainer {
    
    private lazy var rampart = with(PopUpControl(title: "Rampart",
                                                values: Rampart.allCases,
                                                selected: viewModel.rampart)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.valueDidChange = { [weak self] value in
            
            guard let self else { return }
            
            self.viewModel.select(rampart: value)
        }
    }
    
    private lazy var segment = with(PopUpControl(title: "Segment",
                                                values: FenceSegment.allCases,
                                                selected: viewModel.segment)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.valueDidChange = { [weak self] value in
            
            guard let self else { return }
            
            self.viewModel.select(segment: value)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addArrangedSubview(rampart)
        addArrangedSubview(segment)
    }
}
