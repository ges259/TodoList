//
//  CustomImgButton.swift
//  Mission_0911
//
//  Created by 계은성 on 2023/09/15.
//

import UIKit

final class CustomImgButton: UIButton {
    
    weak var delegate: CustomImgButtonDelegate?

    
    override var isHighlighted: Bool {
        didSet { self.delegate?.didChangeHiglighted(currentButton: self, highlighed: self.isHighlighted) }
    }
    
    
    
    
    
    /**
     tintColor = .black,
     borderColor = .lightGray
     borderWidth = 1
     cornerRadius = 8
     */
    func buttonCustemImage(imageString: String)
    -> CustomImgButton {
        // setImg를 쓸까..? 굳이 한 번 더 거쳐야 하나?
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        let image = UIImage(systemName: imageString.description, withConfiguration: imageConfig)

        let btn = CustomImgButton()
            btn.setImage(image, for: .normal)
            btn.tintColor = UIColor.black

            btn.layer.borderColor = UIColor.lightGray.cgColor
            btn.layer.borderWidth = 1

            btn.clipsToBounds = true
            btn.layer.cornerRadius = 8
            
        return btn
    }
    
    /// Title = String,
    /// FontName = FontStyle,
    /// FontSize = CGFloat,
    /// BackgroundColor = UIColor
    func configCustomButton(title: String? = nil,
                            fontName: FontStyle,
                            fontSize: CGFloat,
                            backgroundColor: UIColor? = nil) -> CustomImgButton {
        let btn = CustomImgButton()
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
