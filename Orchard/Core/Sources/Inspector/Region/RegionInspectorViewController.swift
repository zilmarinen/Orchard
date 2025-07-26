//
//  RegionInspectorViewController.swift
//  Feature
//
//  Created by Zack Brown on 24/07/2025.
//

import AppKit
import Base
import Deltille

public protocol RegionInspectorDelegate: AnyObject {
    
    func regionInsepectorViewController(_ viewController: RegionInspectorViewController,
                                        didRequestEditingFor coordinate: Coordinate)
    
    func regionInsepectorViewController(_ viewController: RegionInspectorViewController,
                                        didUpdate coordinate: Coordinate)
}

public class RegionInspectorViewController: InspectorViewController {
    
    private lazy var regionPanel = with(PanelView(title: "Region")) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addRow(label: "Coordinate",
                  detail: coordinateField)
    }
    
    private lazy var intermediatePanel = with(PanelView(title: "Intermediate")) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addRow(label: "Identifier",
                  detail: identifierField)
    }
    
    private lazy var coordinateField = with(CoordinateView()) {
        
        $0.coordinate = viewModel.coordinate
    }
    
    private lazy var identifierField = with(NSTextField()) {
        
        $0.font = .systemFont(ofSize: NSFont.smallSystemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = true
        $0.isBordered = true
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.placeholderString = "Region Name"
        $0.stringValue = viewModel.identifier
        $0.delegate = self
    }
    
    private lazy var button = with(NSButton(title: "",
                                            target: self,
                                            action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.title = viewModel.hasIntermediate ? "Edit Region" : "Create Region"
    }
    
    private let viewModel: RegionViewModel
    private weak var delegate: RegionInspectorDelegate?
    
    public init(coordinate: Coordinate,
                document: Document,
                delegate: RegionInspectorDelegate) {
        
        self.viewModel = .init(coordinate: coordinate,
                               document: document)
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        stackView.addArrangedSubview(regionPanel)
        
        if viewModel.hasIntermediate {
            
            stackView.addArrangedSubview(intermediatePanel)
        }
        
        stackView.addArrangedSubview(button)
    }
}

extension RegionInspectorViewController: NSTextFieldDelegate {
    
    @objc internal func button(_ sender: NSButton) {
        
        delegate?.regionInsepectorViewController(self,
                                                 didRequestEditingFor: viewModel.coordinate)
    }
    
    public func controlTextDidChange(_ notification: Notification) {
        
        guard let sender = notification.object as? NSTextField,
              sender == identifierField else { return }
        
        viewModel.update(identifier: identifierField.stringValue)
        
        delegate?.regionInsepectorViewController(self,
                                                 didUpdate: viewModel.coordinate)
    }
}
