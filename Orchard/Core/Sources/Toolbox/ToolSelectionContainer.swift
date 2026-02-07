//
//  ToolSelectionContainer.swift
//  Core
//
//  Created by Zack Brown on 07/02/2026.
//

import AppKit
import Base
import Design

public protocol ToolSelectionContainerDelegate: AnyObject {
    
    func toolSelectionContainer(_ container: ToolSelectionContainer,
                                didSelect tool: Tool)
}

public class ToolSelectionContainer: NSViewController {
    
    private lazy var stackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = .margin
        $0.orientation = .vertical
        $0.alignment = .leading
        $0.distribution = .fill
        
        for tool in Tool.allCases {
            
            let button = with(NSButton(title: tool.id,
                                       target: self,
                                       action: #selector(button(_:)))) {

                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.imagePosition = .imageLeading
                $0.contentTintColor = tool.color
                $0.image = tool.image
            }
            
            $0.addArrangedSubview(button)
        }
    }
    
    private weak var delegate: ToolSelectionContainerDelegate?
    
    public init(delegate: ToolSelectionContainerDelegate) {
        
        self.delegate = delegate
        
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

extension ToolSelectionContainer {
    
    @objc
    private func button(_ sender: NSButton) {
        
        guard let tool = Tool(rawValue: sender.title.lowercased()) else { return }
        
        delegate?.toolSelectionContainer(self,
                                         didSelect: tool)
        
        presentingViewController?.dismiss(self)
    }
}
