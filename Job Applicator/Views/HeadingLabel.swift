//
// Created by Terence Baker on 2019-03-04.
//

import UIKit

class HeadingLabel: UILabel {

    override init(frame: CGRect) {

        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {

        textColor = UIColor.white
        font = Fonts.HEADING_FONT
    }

    override func drawText(in rect: CGRect) {

        let edgeInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0) //Rockwell seems to clip the top by 2px
        super.drawText(in: rect.inset(by: edgeInset))
    }
}
