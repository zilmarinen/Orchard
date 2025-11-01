//
//  InspectorView.swift
//  Base
//
//  Created by Zack Brown on 07/08/2025.
//

import AppKit

open class InspectorView: NSView {
    
    internal enum Constant {
        
        static let cornerRadius = 4.0
        static let padding = 6.0
        static let spacing = 8.0
    }
    
    private let inspectorView = with(BackgroundView(.windowBackgroundColor)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer?.cornerRadius = Constant.cornerRadius
    }
    
    private let contentView = with(BackgroundView(.controlBackgroundColor)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer?.cornerRadius = Constant.cornerRadius
        $0.setContentHuggingPriority(.high,
                                     for: .horizontal)
    }
    
    private lazy var circleView = with(NSView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.wantsLayer = true
        $0.layer?.backgroundColor = accentColor.cgColor
        $0.layer?.cornerRadius = Constant.cornerRadius
    }
    
    private let titleLabel = with(NSTextField()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: NSFont.smallSystemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = false
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.alignment = .left
    }
    
    public var title: String? {
        
        get { titleLabel.stringValue }
        set { titleLabel.stringValue = newValue ?? "" }
    }
    
    public var accentColor: NSColor {
        
        didSet { circleView.layer?.backgroundColor = accentColor.cgColor }
    }
    
    public init(title: String? = nil,
                accentColor: NSColor = .controlBackgroundColor) {
        
        self.accentColor = accentColor
        
        super.init(frame: .zero)
        
        self.title = title
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(inspectorView)
        
        inspectorView.addSubview(circleView)
        inspectorView.addSubview(titleLabel)
        inspectorView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            
            inspectorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                               constant: Constant.padding),
            inspectorView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor,
                                                constant: Constant.padding),
            inspectorView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                  constant: -Constant.padding),
            inspectorView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor,
                                                 constant: -Constant.padding),
            
            circleView.widthAnchor.constraint(equalTo: circleView.heightAnchor),
            circleView.widthAnchor.constraint(equalToConstant: Constant.cornerRadius * 2.0),
            
            circleView.leftAnchor.constraint(equalTo: inspectorView.safeAreaLayoutGuide.leftAnchor,
                                             constant: Constant.padding),
            circleView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            titleLabel.leftAnchor.constraint(equalTo: circleView.rightAnchor,
                                             constant: Constant.padding),
            titleLabel.rightAnchor.constraint(lessThanOrEqualTo: inspectorView.safeAreaLayoutGuide.rightAnchor),
            titleLabel.topAnchor.constraint(equalTo: inspectorView.safeAreaLayoutGuide.topAnchor,
                                            constant: Constant.padding),
            
            contentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                          constant: Constant.padding),
            contentView.leftAnchor.constraint(equalTo: inspectorView.safeAreaLayoutGuide.leftAnchor,
                                           constant: Constant.padding),
            contentView.rightAnchor.constraint(equalTo: inspectorView.safeAreaLayoutGuide.rightAnchor,
                                            constant: -Constant.padding),
            contentView.bottomAnchor.constraint(equalTo: inspectorView.safeAreaLayoutGuide.bottomAnchor,
                                             constant: -Constant.padding)
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension InspectorView {
    
    public func set(content: NSView) {
        
        content.setContentHuggingPriority(.low,
                                          for: .horizontal)
        content.setContentHuggingPriority(.high,
                                          for: .vertical)
        
        contentView.addSubview(content)
        
        NSLayoutConstraint.activate([
            
            content.topAnchor.constraint(equalTo: contentView.topAnchor,
                                         constant: Constant.padding),
            content.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                          constant: Constant.padding),
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                            constant: -Constant.padding),
            content.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                           constant: -Constant.padding)
        ])
    }
}
