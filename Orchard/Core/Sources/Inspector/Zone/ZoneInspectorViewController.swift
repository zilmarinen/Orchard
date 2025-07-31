//
//  ZoneInspectorViewController.swift
//  Core
//
//  Created by Zack Brown on 28/07/2025.
//

import AppKit
import Base
import Deltille

public protocol ZoneInspectorDelegate: AnyObject {
    
    func zoneInsepectorViewController(_ viewController: ZoneInspectorViewController,
                                      didRequestEditingFor selection: Document.Selection)
    
    func zoneInsepectorViewController(_ viewController: ZoneInspectorViewController,
                                      didUpdate selection: Document.Selection)
}

public class ZoneInspectorViewController: InspectorViewController {
    
    private lazy var zonePanel = with(PanelView(title: "Zone")) {
        
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
        $0.placeholderString = "Zone Name"
        $0.stringValue = viewModel.identifier
        $0.delegate = self
    }
    
    private lazy var button = with(NSButton(title: "",
                                            target: self,
                                            action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.title = "Edit Zone"
    }
    
    private let viewModel: ZoneInspectorViewModel
    private weak var delegate: ZoneInspectorDelegate?
    
    public init(coordinate: Coordinate,
                document: Document,
                delegate: ZoneInspectorDelegate) {
        
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
        
        stackView.addArrangedSubview(zonePanel)
        stackView.addArrangedSubview(intermediatePanel)
        stackView.addArrangedSubview(button)
    }
}

extension ZoneInspectorViewController: NSTextFieldDelegate {
    
    @objc internal func button(_ sender: NSButton) {
        
        delegate?.zoneInsepectorViewController(self,
                                               didRequestEditingFor: .zone(coordinate: viewModel.coordinate))
    }
    
    public func controlTextDidChange(_ notification: Notification) {
        
        guard let sender = notification.object as? NSTextField,
              sender == identifierField else { return }
        
        viewModel.update(identifier: identifierField.stringValue)
        
        guard viewModel.hasIntermediate else { return }
        
        delegate?.zoneInsepectorViewController(self,
                                               didUpdate: .zone(coordinate: viewModel.coordinate))
    }
}
