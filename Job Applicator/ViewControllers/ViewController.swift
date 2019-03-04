//
//  ViewController.swift
//  Job Applicator
//
//  Created by Terence Baker on 2019-02-27.
//  Copyright © 2019 Bulb Studios Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import NSObject_Rx
import CocoaLumberjack

class ViewController: UIViewController {

    private let viewModel = ViewModel()
    private let service = MoyaProvider<JobApplicationService>()

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var teamField: UITextField!
    @IBOutlet weak var aboutView: UITextView!
    @IBOutlet weak var urlView: UITextView!
    @IBOutlet weak var submitButton: UIButton!

    override func viewDidLoad() {

        super.viewDidLoad()

        setupValidationObserver()
        setupButtonObserver()
    }

    private func setupValidationObserver() {

        Observable.combineLatest(nameField.rx.text.orEmpty, emailField.rx.text.orEmpty, teamField.rx.text.orEmpty,
                                 aboutView.rx.text.orEmpty, urlView.rx.text.orEmpty)
                .debounce(0.3, scheduler: MainScheduler.instance)
                .map { [viewModel] (name, email, team, about, url) in

                    return viewModel.validateApplication(name: name, email: email, teams: team, about: about, urls: url)
                }
                .bind(to: submitButton.rx.isEnabled)
                .disposed(by: rx.disposeBag)
    }

    private func setupButtonObserver() {

        submitButton.rx.tap
                .debounce(0.3, scheduler: MainScheduler.instance)
                .flatMapLatest { [weak self] _ -> Single<APIResult<JobApplication>> in

                    guard let strongSelf = self else { return Single.just(APIResult.error(ApplicationError.selfNil)) }

                    let viewModel = strongSelf.viewModel
                    let application = viewModel.createApplication(name: strongSelf.nameField.text ?? "",
                                                                  email: strongSelf.emailField.text ?? "",
                                                                  teams: strongSelf.teamField.text ?? "",
                                                                  about: strongSelf.aboutView.text ?? "",
                                                                  urls: strongSelf.urlView.text ?? "")

                    return viewModel.performApplyRequest(application: application)
                }
                .subscribe(onNext: {

                    switch ($0) {

                        case .success(let application):
                            DDLogInfo("Application successful: \(application)")
                        case .error(let error):
                            DDLogWarn("Application error: \(error)")
                    }
                })
                .disposed(by: rx.disposeBag)
    }
}
