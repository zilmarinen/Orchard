//
//  EmptyViewController.swift
//
//  Created by Zack Brown on 22/07/2025.
//

import AppKit

public class EmptyViewController: NSViewController {
    
    public static let noSelection = EmptyViewController(text: "No Selection")
    
    private lazy var stackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .vertical
        $0.alignment = .centerY
        $0.distribution = .fill
        $0.addArrangedSubview(textLabel)
    }
    
    private lazy var textLabel = with(NSTextField()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: NSFont.systemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = false
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.alignment = .center
    }
    
    public init(text: String) {
        
        super.init(nibName: nil,
                   bundle: nil)
        
        textLabel.stringValue = text
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(stackView)
        
        stackView.pinEdges(to: view)
    }
}
