//
// Created by Terence Baker on 2019-03-04.
// Copyright (c) 2019 Bulb Studios Ltd. All rights reserved.
//

import UIKit

class InputField: UITextField {

    private let edgeInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

    override init(frame: CGRect) {

        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {

        borderStyle = .none
        backgroundColor = R.color.darkJazzBlue()?.withAlphaComponent(0.5)
        textColor = UIColor.white
        font = Fonts.INPUT_FONT
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {

        return super.textRect(forBounds: bounds.inset(by: edgeInset))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {

        return super.editingRect(forBounds: bounds.inset(by: edgeInset))
    }
}
