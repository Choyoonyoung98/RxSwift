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
    let signInViewModel = SignInViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    private func bindUI() {
        //ViewModel에게 입력값을 알려주어야 한다!
        //input: 2 id, pw 입력값
        idTextField.rx.text.orEmpty
            .bind(to: signInViewModel.idText)
            .disposed(by: disposeBag)
        
        pwTextField.rx.text.orEmpty
            .subscribe(onNext: { pw in
            self.signInViewModel.setPwText(pw)
        })
            .disposed(by: disposeBag)
        
        //output: 1 id, pw valid check
        signInViewModel.isIdValid
            .bind(to: idValidView.rx.isHidden)
        
        signInViewModel.isPwValid
            .bind(to: pwValidView.rx.isHidden)
        //output: 2 loginBtn의 enable 상태 변환
        
        Observable.combineLatest(signInViewModel.isIdValid, signInViewModel.isPwValid) { $0 && $1 }
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: disposeBag)

    }
}
