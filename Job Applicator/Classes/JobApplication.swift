//
// Created by Terence Baker on 2019-02-27.
// Copyright (c) 2019 Bulb Studios Ltd. All rights reserved.
//

import UIKit

struct JobApplication: Codable {

    var name: String
    var email: String
    var about: String
    var urls: [String]
    var teams: [String]
}
