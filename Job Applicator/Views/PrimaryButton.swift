//
// Created by Terence Baker on 2019-03-04.
// Copyright (c) 2019 Bulb Studios Ltd. All rights reserved.
//

import UIKit

class PrimaryButton: UIButton {

    override init(frame: CGRect) {

        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        setup()
    }

    override var isEnabled: Bool {
        get { return super.isEnabled }
        set {

            super.isEnabled = newValue
            alpha = (isEnabled) ? 1.0 : 0.5
        }
    }

    private func setup() {

        backgroundColor = UIColor.white

        setTitleColor(R.color.jazzBlue(), for: .normal)

        titleLabel?.font = Fonts.BUTTON_FONT

        titleEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        contentVerticalAlignment = .fill
    }

    override func layoutSubviews() {

        super.layoutSubviews()
        layer.cornerRadius = bounds.size.height / 2.0
    }
}
