//
//  ViewController.swift
//  Job Applicator
//
//  Created by Terence Baker on 2019-02-27.
//  Copyright © 2019 Bulb Studios Ltd. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import NSObject_Rx
import CocoaLumberjack

class ViewController: UIViewController {

    private let viewModel = ViewModel()
    private let service = MoyaProvider<JobApplicationService>()

    override func viewDidLoad() {

        super.viewDidLoad()

        performRequest()
    }

    private func performRequest() {

        let jobApplication = JobApplication(name: "Terence",
                                            email: "stratushunter@gmail.com",
                                            about: "iOS and Android Developer",
                                            urls: ["https://github.com/StratusHunter"],
                                            teams: ["android", "ios"])

        viewModel.performApplyRequest(application: jobApplication)
                .subscribe { event in

                    switch (event) {

                        case .success(let application):
                            DDLogInfo("application successful: \(application)")
                        case .error(let error):
                            DDLogWarn("request error: \(error)")
                    }
                }
                .disposed(by: rx.disposeBag)
    }
}
