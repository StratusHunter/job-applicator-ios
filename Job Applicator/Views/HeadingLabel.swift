//
// Created by Terence Baker on 2019-03-04.
// Copyright (c) 2019 Bulb Studios Ltd. All rights reserved.
//

import UIKit

class HeadingLabel: UILabel {

    override init() { super.init() }

    override init(frame: CGRect) { super.init(frame: frame) }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }

    private func setup() {

        textColor = UIColor.white
        font = Fonts.HEADING_FONT
    }
}
