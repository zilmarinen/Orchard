//
//  ToolOptionsStackContainer.swift
//  Core
//
//  Created by Zack Brown on 08/02/2026.
//

import AppKit
import Base
import Design

internal class ToolOptionsStackContainer: NSViewController {
    
    private lazy var stackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = .margin
        $0.orientation = .vertical
        $0.alignment = .width
        $0.distribution = .equalSpacing
        $0.setHuggingPriority(.defaultHigh,
                              for: .horizontal)
        $0.setHuggingPriority(.defaultLow,
                              for: .vertical)
        
        $0.addArrangedSubview(toolLabel)
        $0.addArrangedSubview(SeparatorView())
    }
    
    private lazy var toolLabel = with(ToolLabel(tool: viewModel.tool)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
 
    internal let viewModel: ToolOptionsViewModel
    internal weak var delegate: ToolOptionsContainerDelegate?
    
    internal init(viewModel: ToolOptionsViewModel) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: .padding),
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                            constant: .padding),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -.padding),
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                             constant: -.padding)
        ])
        
        preferredContentSize = view.fittingSize
    }
}

extension ToolOptionsStackContainer {
    
    internal func addArrangedSubview(_ subview: NSView) {
        
        subview.setContentHuggingPriority(.defaultLow,
                                          for: .horizontal)
        subview.setContentHuggingPriority(.defaultHigh,
                                          for: .vertical)
        
        stackView.addArrangedSubview(subview)
    }
}
