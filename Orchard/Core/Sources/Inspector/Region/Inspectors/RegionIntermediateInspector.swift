//
//  RegionIntermediateInspector.swift
//  Core
//
//  Created by Zack Brown on 07/08/2025.
//

import AppKit
import Base

internal protocol RegionIntermediateInspectorDelegate: AnyObject {
    
    func regionIntermediateInspector(_ inspector: RegionIntermediateInspector,
                                     didUpdate selection: Document.Selection)
}

internal class RegionIntermediateInspector: InspectorGridView {
    
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
        $0.placeholderString = "Region Identifier"
        $0.stringValue = viewModel.identifier
        $0.delegate = self
    }
    
    private let viewModel: RegionInspectorViewModel
    private weak var delegate: RegionIntermediateInspectorDelegate?
    
    internal required init(viewModel: RegionInspectorViewModel,
                           delegate: RegionIntermediateInspectorDelegate) {
        
        self.delegate = delegate
        self.viewModel = viewModel
        
        super.init(title: "Region")
        
        addRow(label: "Coordinate",
               detail: coordinateField)
        
        guard viewModel.hasIntermediate else { return }
        
        addRow(label: "Identifier",
               detail: identifierField)
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension RegionIntermediateInspector: NSTextFieldDelegate {
    
    public func controlTextDidChange(_ notification: Notification) {
        
        guard let sender = notification.object as? NSTextField,
              sender == identifierField,
              viewModel.hasIntermediate else { return }
        
        viewModel.update(identifier: identifierField.stringValue)
        
        delegate?.regionIntermediateInspector(self,
                                              didUpdate: .region(coordinate: viewModel.coordinate))
    }
}
