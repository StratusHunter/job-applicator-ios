//
// Created by Terence Baker on 2019-03-04.
// Copyright (c) 2019 Bulb Studios Ltd. All rights reserved.
//

import UIKit

class InputView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {

        super.init(frame: frame, textContainer: textContainer)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {

        indicatorStyle = .white

        textContainer.lineFragmentPadding = 0
        textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        backgroundColor = R.color.darkJazzBlue()?.withAlphaComponent(0.5)
        textColor = UIColor.white
        tintColor = UIColor.white

        font = Fonts.INPUT_FONT
    }
}
