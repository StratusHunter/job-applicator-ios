//
// Created by Terence Baker on 2019-02-27.
// Copyright (c) 2019 Bulb Studios Ltd. All rights reserved.
//

import Foundation
import Moya

enum JobApplicationService: TargetType {

    case apply(application: JobApplication)

    var baseURL: URL { return URL(string: Settings.instance.baseURL)! }

    var path: String {

        switch (self) {

            case .apply: return "/apply"
        }
    }

    var method: Moya.Method {

        switch (self) {

            case .apply: return .post
        }
    }

    var task: Task {

        switch (self) {

            case let .apply(application): return .requestJSONEncodable(application)
        }
    }

    var headers: [String: String]? {

        return ["Content-type": "application/json"]
    }

    var sampleData: Data {

        switch (self) {

            case .apply(let application): return try! JSONEncoder().encode(application)
        }
    }
}
