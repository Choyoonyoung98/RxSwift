//
//  SignInViewModel.swift
//  MemoApp
//
//  Created by 조윤영 on 2021/03/04.
//

import Foundation
import RxSwift

class SignInViewModel {
    
    //subject를 더 활용해보자! text를 받아주는 subject가 있다면,
    let idText = BehaviorSubject(value: "")
    
    //데이터 어느것도 받지 않은 상태에서 로그인 버튼 enable에 대한 초기화를 해줘야하기 때문에 PublishSubject보다 BehaviorSubject가 더 적합
    let isIdValid = BehaviorSubject(value: false)
    let isPwValid = BehaviorSubject(value: false)
    
    //매번 id에 대한 valid를 체크할 필요없이
    //id text가 distinctUtilChanged할 때만 결과값을 isValid로 bind해주는 것
    init() {
        _ = idText.distinctUntilChanged()
            .map(checkIdValid)
            .bind(to: isIdValid)
    }
//    func setIdText(_ id: String) {
//        let isValid = checkIdValid(id)
//        isIdValid.onNext(isValid)
//    }
    
    func setPwText(_ pw: String) {
        let isValid = checkPasswordValid(pw)
        isPwValid.onNext(isValid)
    }
    
    private func checkIdValid(_ id: String) -> Bool {
        return id.contains("@") && id.contains(".")
    }
    
    private func checkPasswordValid(_ pw: String) -> Bool {
        return pw.count > 5
    }
}
