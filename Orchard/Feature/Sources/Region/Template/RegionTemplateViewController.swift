//
//  RegionTemplateViewController.swift
//  Feature
//
//  Created by Zack Brown on 31/05/2026.
//

import AppKit
import Base
import Deltille
import Design
import Harvest

internal protocol RegionTemplateDelegate: NSViewController {
    
    func regionTemplateViewController(_ viewController: RegionTemplateViewController,
                                      didConfigure scale: Triangle.Scale,
                                      biome: Biome,
                                      elevation: Int)
}

internal class RegionTemplateViewController: NSViewController {
    
    // MARK: Controls
    
    private lazy var scalePopUp = with(PopUpControl(title: "Scale",
                                                    values: viewModel.scales,
                                                    selected: viewModel.scale)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.valueDidChange = { [weak self] value in
            
            guard let self else { return }
            
            self.viewModel.select(scale: value)
        }
    }
    
    private lazy var biomePopUp = with(PopUpControl(title: "Biome",
                                                    values: viewModel.biomes,
                                                    selected: viewModel.biome)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.valueDidChange = { [weak self] value in
            
            guard let self else { return }
            
            self.viewModel.select(biome: value)
        }
    }
    
    private lazy var elevationStepper = with(StepperControl(title: "Elevation",
                                                            value: viewModel.elevation)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.maximumValue = viewModel.maximumElevation
        $0.minimumValue = viewModel.minimumElevation
        
        $0.valueDidChange = { [weak self] value in
            
            guard let self else { return }
            
            self.viewModel.select(elevation: value)
        }
    }
    
    // MARK: Actions
    
    private lazy var createButton = with(NSButton(title: "Create",
                                                      target: self,
                                                      action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.bezelColor = .systemIndigo
        $0.toolTip = "Create a new region from this template"
    }
    
    private lazy var dismissButton = with(NSButton(title: "Dismiss",
                                                   target: self,
                                                   action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.hasDestructiveAction = true
        $0.toolTip = "Dismiss region template creation"
    }
    
    private let viewModel: RegionTemplateViewModel
    private weak var delegate: RegionTemplateDelegate?
    
    public init(delegate: RegionTemplateDelegate) {
        
        self.viewModel = .init()
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
        
        title = "Template"
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let stackView = NSStackView(views: [scalePopUp,
                                           biomePopUp,
                                           elevationStepper])
        
        stackView.orientation = .vertical
        
        view.addSubview(stackView)
        
        stackView.center(in: view)
        
        view.addSubview(createButton)
        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            createButton.leftAnchor.constraint(greaterThanOrEqualTo: dismissButton.leftAnchor),
        
            dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            dismissButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        ])
    }
}

extension RegionTemplateViewController {
    
    @objc
    private func button(_ sender: NSButton) {
        
        switch sender {
            
        case createButton:
            
            delegate?.regionTemplateViewController(self,
                                                   didConfigure: viewModel.scale,
                                                   biome: viewModel.biome,
                                                   elevation: viewModel.elevation)
            
        default: fatalError("Invalid sender for button")
        }
        
        dismiss(self)
    }
}
