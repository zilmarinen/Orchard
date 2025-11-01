//
//  ZoneIntermediateInspector.swift
//  Core
//
//  Created by Zack Brown on 08/08/2025.
//

import AppKit
import Base

internal protocol ZoneIntermediateInspectorDelegate: AnyObject {
    
    func zoneIntermediateInspector(_ inspector: ZoneIntermediateInspector,
                                   didUpdate selection: Document.Selection)
}

internal class ZoneIntermediateInspector: InspectorGridView {
    
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
        $0.placeholderString = "Zone Identifier"
        $0.stringValue = viewModel.identifier
        $0.delegate = self
    }
    
    private let viewModel: ZoneInspectorViewModel
    private weak var delegate: ZoneIntermediateInspectorDelegate?
    
    internal required init(viewModel: ZoneInspectorViewModel,
                           delegate: ZoneIntermediateInspectorDelegate) {
        
        self.delegate = delegate
        self.viewModel = viewModel
        
        super.init(title: "Zone",
                   accentColor: .systemGray)
        
        addRow(label: "Coordinate",
               detail: coordinateField)
        
        guard viewModel.hasIntermediate else { return }
        
        addRow(label: "Identifier",
               detail: identifierField)
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension ZoneIntermediateInspector: NSTextFieldDelegate {
    
    public func controlTextDidChange(_ notification: Notification) {
        
        guard let sender = notification.object as? NSTextField,
              sender == identifierField,
              viewModel.hasIntermediate else { return }
        
        viewModel.update(identifier: identifierField.stringValue)
        
        delegate?.zoneIntermediateInspector(self,
                                            didUpdate: .zone(coordinate: viewModel.coordinate))
    }
}
