//
//  Extension.swift
//  Mission_0911
//
//  Created by 계은성 on 2023/09/11.
//

import UIKit


// MARK: - UIButton
extension UIButton {
    func buttonSustemImage(imageString: String)
    -> UIButton {
        // setImg를 쓸까..? 굳이 한 번 더 거쳐야 하나?
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        let image = UIImage(systemName: imageString.description, withConfiguration: imageConfig)
        
        let btn = UIButton()
            btn.setImage(image, for: .normal)
            btn.tintColor = UIColor.black
            
            btn.layer.borderColor = UIColor.lightGray.cgColor
            btn.layer.borderWidth = 1
        
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 8
        return btn
    }
    func configButton(title: String? = nil,
                      fontName: FontStyle,
                      fontSize: CGFloat,
                      backgroundColor: UIColor? = nil) -> UIButton {
        let btn = UIButton()
            btn.setTitle(title, for: .normal)
        
        if let backgroundColor =  backgroundColor {
            btn.backgroundColor = backgroundColor
        }
        
        
        switch fontName {
        case .system:
            btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        case .bold:
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        }
        return btn
    }
}


extension UIView {
    // MARK: - Anchor
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                
                bottom: NSLayoutYAxisAnchor? = nil,
                paddingBottom: CGFloat = 0,
                
                leading: NSLayoutXAxisAnchor? = nil,
                paddingLeading: CGFloat = 0,
                
                trailing: NSLayoutXAxisAnchor? = nil,
                paddingTrailing: CGFloat = 0,
                
                width: CGFloat? = nil,
                height: CGFloat? = nil,
                
                centerX: UIView? = nil,
                paddingCenterX: CGFloat = 0,
                
                centerY: UIView? = nil,
                paddingCenterY: CGFloat = 0,
                
                cornerRadius: CGFloat? = nil) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing).isActive = true
        }
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let centerX = centerX {
            self.centerXAnchor.constraint(equalTo: centerX.centerXAnchor, constant: paddingCenterX).isActive = true
        }
        if let centerY = centerY {
            self.centerYAnchor.constraint(equalTo: centerY.centerYAnchor, constant: paddingCenterY).isActive = true
        }
        
        if let cornerRadius = cornerRadius {
            self.clipsToBounds = true
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    func anchorHeightAndCorner(height: CGFloat, cornerRadius: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        // height
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        // cornerRadius
        
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
    
    
    func configView(color: UIColor,
                    borderColor: UIColor? = nil,
                    borderWidth: CGFloat = 0.5) -> UIView {
        
        let view =  UIView()
            view.backgroundColor = color
        
        if let borderColor = borderColor {
            view.layer.borderColor = borderColor.cgColor
            view.layer.borderWidth = borderWidth
        }
        return view
    }
}




// MARK: - UIStackView
extension UIStackView {
    func stackView(arrangedSubviews: [UIView],
                   axis: NSLayoutConstraint.Axis? = .vertical,
                   spacing: CGFloat? = nil,
                   alignment: UIStackView.Alignment? = nil,
                   distribution: UIStackView.Distribution? = nil)
    -> UIStackView {
        let stv = UIStackView(arrangedSubviews: arrangedSubviews)
        
        if let axis = axis {
            stv.axis = axis
        }
        if let distribution = distribution {
            stv.distribution = distribution
        }
        if let spacing = spacing {
            stv.spacing = spacing
        }
        if let alignment = alignment {
            stv.alignment = alignment
        }
        return stv
    }
}



// MARK: - TextField
extension UITextField {
    func setTextFieldPadding(_ amount: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}




// MARK: - NSMutableAttributedString
extension NSMutableAttributedString {
    /// Font_Name - bold,
    /// Font_Size - 16,
    /// ForegroundColor = .red
    /// - Parameter text: String
    func attributedText(text: String) -> NSAttributedString {
        let text = NSMutableAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                         NSAttributedString.Key.foregroundColor : UIColor.red])
        return text
    }
}
