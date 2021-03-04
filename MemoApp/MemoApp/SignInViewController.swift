//
//  SignInViewController.swift
//  MemoApp
//
//  Created by 조윤영 on 2021/03/04.
//

import UIKit
import RxSwift
import RxCocoa
//Cocoa framework + Rx
//UIKit을 위한 rx영역을 제공하는 프레임워크

class SignInViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var idValidView: UIView!
    @IBOutlet weak var pwValidView: UIView!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    var disposeBag = DisposeBag()
    private func bindUI() {
        
        bindIdValidView()
        bindPwValidView()
        
        //첫번째값이 변경이 되든, 두번째값이 변경이 되든
        //하나라도 바뀌면 가장 최근의 값을 가지고 subscribe해준다
        
        //zip: 모든 값이 변경되어야 데이터를 전달
        //merge: 두개의 스트림을 받는데, 순서대로 내려보내준다. 계산된 결과값을 보내지 못한다
        Observable.combineLatest(
            idTextField.rx.text.orEmpty.map(checkIdValid),
            pwTextField.rx.text.orEmpty.map(checkPasswordValid),
            resultSelector: { s1, s2 in s1 && s2 }
        )
        .subscribe(onNext: { b in
            self.loginBtn.isEnabled = b
        })
    }
    
    private func bindIdValidView() {
        idTextField.rx.text.orEmpty
            .map(checkIdValid)
            .subscribe(onNext: { b in
                self.idValidView.isHidden = b
        })
        .disposed(by: disposeBag)
    }
    
    private func bindPwValidView() {
        pwTextField.rx.text.orEmpty
            .map(checkPasswordValid)
            .subscribe(onNext: { b in
                self.pwValidView.isHidden = b
        })
        .disposed(by: disposeBag)
    }
    
    private func checkIdValid(_ id: String) -> Bool {
        return id.contains("@") && id.contains(".")
    }
    private func checkPasswordValid(_ pw: String) -> Bool {
        return pw.count > 5
    }

}
