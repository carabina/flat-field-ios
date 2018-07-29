//
//  FlatField.swift
//  FlatField
//
//  Created by Ampe on 7/28/18.
//

import UIKit

// MARK: - Properties
@IBDesignable
open class FlatField: UIView {
    
    // MARK: Views
    weak var textField: UITextField!
    weak var underline: UIView!
    
    // MARK: Properties
    private weak var underlineHeightConstraint: NSLayoutConstraint!
    
    // MARK: IBInspectables
    @IBInspectable
    open var text: String = FlatFieldConfig.default.text {
        didSet {
            textField.text = text
        }
    }
    
    @IBInspectable
    open var placeholderText: String = FlatFieldConfig.default.placeholderText {
        didSet {
            textField.placeholder = placeholderText
        }
    }
    
    @IBInspectable
    open var cursorColor: UIColor = FlatFieldConfig.default.cursorColor {
        didSet {
            textField.tintColor = cursorColor
        }
    }
    
    @IBInspectable
    open var textColor: UIColor = FlatFieldConfig.default.textColor {
        didSet {
            textField.textColor = textColor
        }
    }
    @IBInspectable
    open var placeholderColor: UIColor = FlatFieldConfig.default.placeholderColor {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes:[NSAttributedStringKey.foregroundColor: placeholderColor])
        }
    }
    
    @IBInspectable
    open var underlineColor: UIColor = FlatFieldConfig.default.underlineColor {
        didSet {
            underline.backgroundColor = underlineColor
        }
    }
    
    @IBInspectable
    open var underlineThickness: CGFloat = FlatFieldConfig.default.underlineThickness {
        didSet {
            underlineHeightConstraint.constant = underlineThickness
        }
    }
    
    @IBInspectable
    open var textAlignment: Int = FlatFieldConfig.default.textAlignment.rawValue {
        didSet {
            guard let alignment = NSTextAlignment(rawValue: textAlignment) else {
                assert(false, "use a valid alignment mapping integer (0-4)")
            }
            
            textField.textAlignment = alignment
        }
    }
    
    @IBInspectable
    open var thicknessChange: CGFloat = FlatFieldConfig.default.thicknessChange
    
    // MARK: Programmatic Initalizer
    public init(_ frame: CGRect,
                config: FlatFieldConfig,
                delegate: FloatingLabelDelegate?) {
        
        self.delegate = delegate
        
        let field = UITextField()
        textField = field
        
        let view = UIView()
        underline = view
        
        super.init(frame: frame)
        
        addViews()
        addContraints()
        
        initConfig(config)
    }
    
    // MARK: Storyboard Initalizer
    public required init?(coder aDecoder: NSCoder) {
        let field = UITextField()
        textField = field
        
        let view = UIView()
        underline = view
        
        super.init(coder: aDecoder)
        
        addViews()
        addContraints()
        
        initConfig()
    }
    
    // MARK: Setup Methods
    private func initConfig(_ config: FlatFieldConfig = FlatFieldConfig.default) {
        text = config.text
        placeholderText = config.placeholderText
        textColor = config.textColor
        placeholderColor = config.placeholderColor
        underlineColor = config.underlineColor
        underlineThickness = config.underlineThickness
        thicknessChange = config.thicknessChange
        textAlignment = config.textAlignment.rawValue
    }
    
    private func addViews() {
        addSubview(textField)
        addSubview(underline)
        
        textField.delegate = self
    }
    
    private func addContraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        underline.translatesAutoresizingMaskIntoConstraints = false
        
        underline.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        underline.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        underline.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let underlineHeightAnchor = underline.heightAnchor.constraint(equalToConstant: underlineThickness)
        underlineHeightAnchor.isActive = true
        
        underlineHeightConstraint = underlineHeightAnchor
    }
    
    // MARK: Storage
    var delegate: FloatingLabelDelegate?
}

extension FlatField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ sender: UITextField) {
        delegate?.editingBegan(self)
        
        textField.tintColor = cursorColor
        underlineHeightConstraint.constant += thicknessChange
    }
    
    public func textFieldDidEndEditing(_ sender: UITextField) {
        underlineHeightConstraint.constant -= thicknessChange
    }
    
    public func textFieldValueChanged(_ sender: UITextField) {
        delegate?.textChanged(self)
    }
}
