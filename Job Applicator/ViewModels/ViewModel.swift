//
// Created by Terence Baker on 2019-02-27.
// Copyright (c) 2019 Bulb Studios Ltd. All rights reserved.
//

import UIKit
import Moya
import RxSwift

struct ViewModel {

    private let service = MoyaProvider<JobApplicationService>()

    func performApplyRequest(application: JobApplication) -> Single<JobApplication> {

        return service.rx.request(.apply(application: application))
                .filterSuccessfulStatusCodes()
                .map(JobApplication.self)
    }
}
