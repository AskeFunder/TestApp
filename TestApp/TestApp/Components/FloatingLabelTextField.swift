//
//  FloatingLabelTextField.swift
//  TestApp
//
//  Created by Aske Funder Jensen on 26/08/2020.
//  Copyright © 2020 Aske Funder Jensen. All rights reserved.
//

import UIKit

class FloatingLabelTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    var floatingLabel: UILabel = UILabel(frame: CGRect.zero)
    var floatingLabelHeight: CGFloat = 14
    
    
    var _placeholder: String? {
        didSet {
            self.placeholder = _placeholder
            self.setNeedsDisplay()
        }
    }
    
    var floatingLabelColor: UIColor = .systemGray {
        didSet {
            self.floatingLabel.textColor = floatingLabelColor
            self.setNeedsDisplay()
        }
    }
    
    var activeBorderColor: UIColor = .blue
    
    var floatingLabelFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            self.floatingLabel.font = self.floatingLabelFont
            self.font = self.floatingLabelFont
            self.setNeedsDisplay()
        }
    }
    
    var underLine: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        
        return view
    }()
    
//    var selectedUnderLine: UIView = {
//        let view = UIView()
//
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .systemBlue
//
//        return view
//    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        self._placeholder = (self._placeholder != nil) ? self._placeholder : placeholder
        
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
        
        addUnderline()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //  some initialisation for init with frame
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self._placeholder = (self._placeholder != nil) ? self._placeholder : placeholder
        placeholder = self._placeholder
        
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
        
    }
    
    func addUnderline() {
        self.underLine.clipsToBounds = true
        self.underLine.frame = CGRect(x: 0, y: 0, width:
            self.frame.size.width, height: 0)
        self.addSubview(self.underLine)
          
        NSLayoutConstraint.activate([
            self.underLine.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 4),
            self.underLine.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4),
            self.underLine.leftAnchor.constraint(equalTo: self.leftAnchor, constant: -4),
            self.underLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func configureFloatingLAbel() {
          self.floatingLabel.textColor = floatingLabelColor
          self.floatingLabel.font = floatingLabelFont
          self.floatingLabel.text = self._placeholder
          self.floatingLabel.layer.backgroundColor = UIColor.white.cgColor
          self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
          self.floatingLabel.clipsToBounds = true
          self.floatingLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.floatingLabelHeight)
          self.layer.borderColor = self.activeBorderColor.cgColor
          self.addSubview(self.floatingLabel)
          

          
        
          self.floatingLabel.bottomAnchor.constraint(equalTo:
          self.topAnchor, constant: -8).isActive = true // Place our label 10pts above the text field
          // Remove the placeholder
          self.placeholder = ""
              
          

          
          self.setNeedsDisplay()
          self.layoutIfNeeded()
          UIView.animate(withDuration: 0.12) {
              if self.text == "" {
                  self.floatingLabel.frame.origin.y = self.floatingLabel.frame.origin.y + -48
              }
              
          }
    }
    
    @objc func addFloatingLabel() {
        
        configureFloatingLAbel()
        
        floatingLabel.textColor = .systemBlue
        underLine.backgroundColor = .systemBlue
    }
    
    @objc func removeFloatingLabel() {
        if self.text == "" {
            UIView.animate(withDuration: 2) {
                self.floatingLabel.removeFromSuperview()
                
                self.setNeedsDisplay()
            }
            self.placeholder = self._placeholder
        }
        floatingLabel.textColor = .systemGray
        underLine.backgroundColor = .systemGray
        
    }
}
