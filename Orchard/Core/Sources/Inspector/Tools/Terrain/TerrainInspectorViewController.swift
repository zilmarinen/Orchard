//
//  TerrainInspectorViewController.swift
//  Core
//
//  Created by Zack Brown on 02/10/2025.
//

import AppKit
import Base

public class TerrainInspectorViewController: InspectorViewController {
    
    private lazy var typeInspector = TerrainTypeInspector(viewModel: viewModel)
    private lazy var toolInspector = TerrainToolInspector(viewModel: viewModel)
    
    private let viewModel: TerrainInspectorViewModel
    
    public init(viewModel: TerrainInspectorViewModel) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addArrangedSubview(typeInspector)
        addArrangedSubview(toolInspector)
    }
}
