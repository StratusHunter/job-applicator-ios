//
// Created by Terence Baker on 2019-03-04.
// Copyright (c) 2019 Bulb Studios Ltd. All rights reserved.
//

import UIKit

class InputField: UITextField {

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
}
