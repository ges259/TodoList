//
//  PaddingLabel.swift
//  Mission_0911
//
//  Created by 계은성 on 2023/09/11.
//

import UIKit

final class PaddingLabel: UILabel {

    var edgeInset: UIEdgeInsets = .zero

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: edgeInset.top, left: edgeInset.left, bottom: edgeInset.bottom, right: edgeInset.right)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + edgeInset.left + edgeInset.right, height: size.height + edgeInset.top + edgeInset.bottom)
    }
    
    func configurePaddingLbl() -> PaddingLabel {
        let lbl = PaddingLabel()
            lbl.font = UIFont.systemFont(ofSize: 15)
        // border
            lbl.layer.borderColor = UIColor.lightGray.cgColor
            lbl.layer.borderWidth = 1
        // cornerRadius
            lbl.clipsToBounds = true
            lbl.layer.cornerRadius = 8
        // padding_Left
            lbl.edgeInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        return lbl
    }
    
    func PaddingOptionLabel() -> PaddingLabel {
        let lbl = PaddingLabel()
//            lbl.text = text
            lbl.font = UIFont.systemFont(ofSize: 15)
            
            lbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        // padding_Left
            lbl.edgeInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        return lbl
    }
}
