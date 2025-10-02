//
//  TerrainInspectorViewController.swift
//  Core
//
//  Created by Zack Brown on 02/10/2025.
//

import AppKit
import Base

internal class TerrainInspectorViewController: InspectorViewController {
    
    private lazy var terrainTypePanel = TerrainTypeInspector(viewModel: viewModel)
    private lazy var toolPanel = TerrainToolInspector(viewModel: viewModel)
    
    private let viewModel: TerrainInspectorViewModel
    
    internal init() {
        
        self.viewModel = .init()
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addArrangedSubview(terrainTypePanel)
        addArrangedSubview(toolPanel)
    }
}
