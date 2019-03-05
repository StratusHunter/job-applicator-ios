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

    typealias InputData = (String, String, String, String, String)

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

        let inputDataObservable = Observable.combineLatest(nameField.rx.text.orEmpty, emailField.rx.text.orEmpty, teamField.rx.text.orEmpty,
                                                           aboutView.rx.text.orEmpty, urlView.rx.text.orEmpty)
                .share(replay: 1, scope: .forever)

        setupValidationObserver(input: inputDataObservable)
        setupButtonObserver(input: inputDataObservable)
    }

    private func setupValidationObserver(input inputDataObservable: Observable<InputData>) {

        inputDataObservable
                .debounce(0.3, scheduler: MainScheduler.instance)
                .map { [viewModel] (name, email, team, about, url) in

                    return viewModel.validateApplication(name: name, email: email, teams: team, about: about, urls: url)
                }
                .bind(to: submitButton.rx.isEnabled)
                .disposed(by: rx.disposeBag)
    }

    private func setupButtonObserver(input inputDataObservable: Observable<InputData>) {

        submitButton.rx.tap
                .debounce(0.3, scheduler: MainScheduler.instance)
                .withLatestFrom(inputDataObservable)
                .flatMapLatest { [viewModel] (name, email, team, about, url) -> Single<APIResult<JobApplication>> in

                    let application = viewModel.createApplication(name: name, email: email, teams: team, about: about, urls: url)
                    return viewModel.performApplyRequest(application: application)
                }
                .subscribe(onNext: { [weak self] in self?.handleApplicationResponse(result: $0) })
                .disposed(by: rx.disposeBag)
    }

    private func handleApplicationResponse(result: APIResult<JobApplication>) {

        var response: String? = nil

        switch (result) {

            case .success(let application):
                response = R.string.content.applicationReceived()
                DDLogInfo("\(response!): \(application)")
            case .error(let error):
                response = R.string.content.applicationError()
                DDLogWarn("\(response!): \(error)")
        }

        if let response = response {

            let alertController = UIAlertController(title: response, message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: R.string.content.ok(), style: .default, handler: nil))
            alertController.view.tintColor = R.color.darkJazzBlue()
            present(alertController, animated: true) { [alertController] in alertController.view.tintColor = R.color.darkJazzBlue() }
        }
    }
}
