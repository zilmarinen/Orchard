//
//  SlopeToolOptionsContainer.swift
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

internal class SlopeToolOptionsContainer: ToolOptionsStackContainer {
    
    private lazy var slope = with(PopUpControl(title: "Slope",
                                               values: Slope.allCases,
                                               selected: viewModel.slope)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.valueDidChange = { [weak self] value in
            
            guard let self else { return }
            
            self.viewModel.select(slope: value)
        }
    }
    
    private lazy var rise = with(PopUpControl(title: "Rise",
                                               values: Rise.allCases,
                                               selected: viewModel.rise)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.valueDidChange = { [weak self] value in
            
            guard let self else { return }
            
            self.viewModel.select(rise: value)
        }
    }
    
    private lazy var cast = with(PopUpControl(title: "Cast",
                                               values: Cast.allCases,
                                               selected: viewModel.cast)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.valueDidChange = { [weak self] value in
            
            guard let self else { return }
            
            self.viewModel.select(cast: value)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addArrangedSubview(slope)
        addArrangedSubview(rise)
        addArrangedSubview(cast)
    }
}
