//
// Created by Terence Baker on 2019-03-04.
//

import UIKit

extension String {

    var isEmail: Bool { return isValid(regex: ".+@.+\\.[A-Za-z]{2}[A-Za-z]*") }

    func isValid(regex: String) -> Bool {

        let recognizer = try! NSRegularExpression(pattern: regex)
        return !recognizer.matches(in: self, range: NSRange(location: 0, length: count)).isEmpty
    }
}
