//
//  FoliageInspectorViewController.swift
//  Core
//
//  Created by Zack Brown on 09/10/2025.
//

import AppKit
import Base

public class FoliageInspectorViewController: InspectorViewController {
    
    private lazy var typeInspector = FoliageTypeInspector(viewModel: viewModel)
    
    private let viewModel: FoliageInspectorViewModel
    
    public init(viewModel: FoliageInspectorViewModel) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addArrangedSubview(typeInspector)
    }
}
