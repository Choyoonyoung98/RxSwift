# RxSwift
RxSwift, 도대체 뭘까?
- [참고자료1 - 곰튀김님 RxSwift 강의 시즌1](https://www.youtube.com/playlist?list=PL03rJBlpwTaAh5zfc8KWALc3ADgugJwjq)  
- [참고자료2 - 곰튀김님 RxSwift 강의 시즌2](https://www.youtube.com/playlist?list=PL03rJBlpwTaBrhux_C8RmtWDI_kZSLvdQ)
### - RxSwift를 공부하게 된 계기, 또는 사용해야겠다고 생각한 이유?
> GitCat에서 특정 날짜에 대한 커밋 내역 기록을 불러오는 커밋 달력 기능을 제공합니다. 그런데 여러 날짜에 대해서 짧은 시간 안에 연이어 요청을 하게 되면 유저의 화면 입장에서는 가장 최근의 요청에 대해 기다리지만, 누적된 요청에 대해 모두 처리하고 난 뒤에 최근 요청에 대한 응답을 화면에 노출하기 때문에 유저가 원하는 데이터를 보기까지 많은 시간이 소요되는 것을 알 수 있었습니다. 해당 상황을 해결하기 위해서는 비동기로 요청 중인 작업을 취소하고 최근의 요청에 대해서만 응답을 받아야했습니다. 
> 그러기 위해서는 OperationQueue 또는 수작업으로 DispatchQueue를 사용하되, flag를 두고 내내 체크하는 방법을 사용해야한다는 결론이 나왔습니다. 그런데 RxSwift에 이런 비동기 요청 작업 취소 행위를 dispose를 통해 쉽게 해준다고 해서 공부 중입니다.   

### - RxSwift란?
> RxSwift란 observable 스트림을 통해 비동기 프로그래밍을 직관적으로 작성할 수 있도록 도와주는 라이브러리입니다.  

### - RxSwift를 왜 사용할까?
> 비동기적으로 생성되는 데이터를 completion와 같은 closure를 통해서가 아닌 return 값으로 전달하기 위해 사용합니다.  
```
//비동기로 생성되는 데이터를 Observable로 감싸서 리턴하는 방법
func douwnloadJson(_ url: String) -> Obsesrvable<String?> {
  return Observable.create() { f in
    DispatchQueue.global().async {
      let url = URL(string: url)!
      let data = try! Data(contentOf: url)
      let json = String(data: data, encoding: .utf8)
      
      DispatchQueue.main.async {
        f.onNext(json)
      }
      return Disposable.create()
   }
 }
 
 //Observable로 오는 데이터를 받아서 처리하는 방법
 downloadJson("https://image.~")
  .subscribe { event in //이벤트의 종류는 총 3가지!
    switch event {
    case let .next(json)"
      break
    case .completed:
      break
    case .error:
      break
    }
  }
```

### - 비동기 프로그래밍이 필요한 순간들?
1. 버튼을 눌렀을 때의 반응
2. 텍스트필드에 포커스가 잡힌 경우
3. 인터넷에서 크기가 큰 이미지 파일을 받는 경우
4. delegation 패턴을 사용할 경우
5. 클로저 구현할 때

### - RxSwift의 장점은 무엇일까?
> 비동기 요청 작업에 대한 취소를 간단학게 구현할 수 있을 뿐만 아니라 tableView와 collectionView를 구현할 때 전통적인 델리게이트 패턴을 이용하지 않고 단순 코드로 구현할 수 있다는 장점을 가지고 있습니다. 

### - RxSwift의 단점은 무엇일까?
> 클로저의 사용이 많기 때문에 클로저의 캡처리스트를 신경써야 합니다. 강한 순환 참조에 의한 메모리 누수를 일으킬 수도 있기 때문입니다.  

### - Rx의 3가지 구성요소
> Observables, Operators, Schedulers 등이 있습니다.  

### - Observable?
> Observable은 모든 타입의 데이터를 전달할 수 있는 이벤트들을 비동기적으로 생성하는 기능을 합니다. Observer는 Observable을 감시하고 있다가 전달되는 이벤트를 처리합니다.  
> Observable의 가장 큰 장점은 element들을 비동기적으로 받을 수 있다는 점입니다. 

### - Observable의 생명주기
1. Create
2. Subscribe: Observable의 동작시점
3. onNext
4. onCompleted / onError
5. Disposed  

### - Observable이 방출하는 세 가지 이벤트
1. Next
> Observable에서 발생한 새로운 이벤트는 Next 이벤트를 통해 전달됩니다. 이벤트에 값이 포함되어 있으며, 이 과정을 Emission이라고 합니다. 

2. Error / Completed
> Observable에서 에러가 발생하면 Error 이벤트가 전달되고, Observable이 정상적으로 종료되면 Completed 이벤트가 전달됩니다. 두 이벤트는 Observable의 라이프 사이클에서 가장 마지막에 전달되는 이벤트입니다. 이후 Observable이 종료되고 모든 resource가 정리되기 때문에 다른 이벤트가 전달되지 않습니다. 보통 이 과정을 Notification이라고 합니다.  

### - dispose란?
> Observable의 사용이 끝나면 메모리를 해제해야 하는데, Dispose를 통해 subscription을 명시적으로 중단할 수 있습니다.  
```
//클로저에서 생긴 참조는 completed 또는 error 때 사라지게 된다
 let disposable = downloadJson("https://image.~")
  .subscribe { [weak self] event in //이벤트의 종류는 총 3가지!
    switch event {
    case let .next(json)"
      beak
    case .completed:
      break
    case .error:
      break
    }
  }
  
  disposable.dispose() //바로 취소했으므로 위의 로직이 화면에 표시되지 않는다
```

### - disposeBag란?
> 생성하는 subscription마다 별도의 dispose로 관리하면 번거롭기 때문에 DisposeBag를 사용해서 한꺼번에 처리할 수 있습니다.
> DisposesBag은 Disposable타입을 담을 수 있는 클래스입니다. Disposable에서 disposed(by:)메소드를 호출하면 사용할 수 있습닌다. DisposeBag에 담긴 Disposable들은 DisposeBag이 dealloc될 때 같이 dealloc됩니다.  

### - subscribe란?
> subscribe는 Observable의 알림과 방출에 따라 동작합니다. Subscribe 연산자는 Observable에 Observer를 연결하는 접착제입니다. Observable에 아이템이 방출되거나 에러 혹은 완료 알림을 받기 위해서는 반드시 처음에 이 연산자를 Observable에 사용해 구독해야만 가능합니다.
1. Observer를 생성하고 
2. 생성한 Observer를 내부에 생성한 Observable에 붙이고
3. 붙인 그 구조체를 반환합니다.
> subscribe의 반환타입은 disposable입니다!

```
Observable.just(["A","B","C","D"])
  .subscribe { event in
    switch event {
    case .next(let str)://4번 호출
      print("next: \(str)")
      break
     case .error(let err)
      break
     case .completed:
      print("completed")
      break
    }
  }
  .disposed(by: disposeBag)
}
//출려
next: A
next: B
next: C
next: D
completed
```
```
Observable.just(["A","B","C","D"])
  .subscribe { onNext: { s in
    print(s)
  }, onError: { err in
    print(err.localizedDescription)
  }, onCompleted: {
    print("completed"
  }, onDisposed: {
    print("disposed") //complete난 경우 또는 error
  })
  .disposed(by: disposeBag)
}
```

### - Operators 종류
> Observable의 복잡한 논리를 구현하기 위한 많은 메서드들을 Operator라고 부릅니다.  
> Operator는 비동기 입력을 받아 출력만 생성하기 때문에 Operator들끼리 쉽게 혼합해서 사용이 가능합니다.
> Rx Operator는 Observable에 의해 들어온 값들을 처리하고 최종값이 나올 때 방출합니다.
1. 생성: create/just/from
2. 변환: map
3. 필터링: filter
4. 결합
5. 오류처리
6. 조건과 불린 연산자
7. 수학과 집계 연산자
8. 역압 연산자
9. 연결
10. Observable 변환

### - Subject란?
> Rx에서 Subject는 Observable과 Observer 둘 다 될 수 있는 특별한 형태입니다. Subject는 Observable을 subscribe 할 수 있고, 다시 emit할 수도 있습니다. 혹은 새로운 Observable을 emit할 수 있습니다.
> 이러한 Subject는 3가지의 타입을 포함합니다.  
1. PublishSubject
2. BehaviorSubject
3. ReplaySubject

### - PublishSubject
> 전달받은 이벤트를 Observer로 전달하는 가장 기본적인 Subject입니다. PublishSubject는 subscribe 전의 이벤트는 emit 하지 않습니다. subscribe한 후의 이벤트만을 emit합니다. 그리고 에러 이벤트가 발생하면 그 후의 이벤트는 emit하지 않습니다.  

### - BehaviorSubject
> BehaviorSubject는 PublishSubject와 거의 같지만, BehaviorSubject는 반드시 값으로 초기화 해줘야 한다는 점에서 차이점을 가집니다. 즉 Observer에게 subscribe 하기 전 마지막 이벤트 혹은 초기값을 emit합니다.

### - ReplaySubject
> ReplaySubject는 미리 정해진 사이즈만큼 가장 최근의 이벤트를 새로운 Subscriber에게 전달합니다.

### - just
> ObservableType 프로토콜의 Type Method입니다. just로 생성한 Observable은 파라미터로 전달한 요소를 그대로 방출합니다.  
```
Observable.justs("Hello")
  .subscribe(onNext: { str in
    print(str)
  })
  .disposed(by: disposeBag)
}
//출력: "Hello"
```
```
Observable.just("Hello")
  .map{ str in "\(str) RxSwift" }
  .subscirbe(onNext: { stsr in
    print(str)
  })
  .disposed(by: disposeBag)
}
```
```
Observable.just("800x600")
  .map{ $0.replacingOccurance(of: "x", with: "/")}
  .map{ "https://picsum.photos/\($0)/?random" }
  .map{ URL(sting: $0) }
  .filter{ $0 != nil }
  .map{ $0! }
  .map{ try Data(contentsOf: $0 }
  .map{ UImage(data: $0) }
  .subscribe(onNext: { image in
    self.imageView.image = image
    
  })
  .disposed(by: disposeBag)
}
```
### - of
> 파라미터가 가변 파라미터로 선언되어 있어 여러 개의 값을 동시에 전달할 수 있습니다. 따라서 두 개 이상의 요소를 방출하는 Observable을 만들기 위해 사용합니다. of연산자 역시 ObservableType프로토콜의 Type method입니다.  

### - from
> from은 전달된 배열이 각각 처리되도록 학기 위해 사용합니다.  
```
Observable.from(["A","B","C","D"])
  .subscribe(onNext: { str in
    print(str)
  })
  .disposed(by: disposeBag)
}
//출력:
A
B
C
D
```
```
Observable.just(["Hello", "World"])
  .subscribe(onNext: { arr in
    print(arr)
  })
  .disposed(by: disposeBag)
}
//출력: ["Hello","World"] 
//그대로 출려되는 모습
```

### - just, of, from을 비교해보자.
> just는 하나의 요소를 방출해야 할 때, of는 두 개 이상의 요소를 방출해야할 때, from은 배열에 저장된 요소를 순서대로 하나씩 방출해야 할 때 사용합니다.  

### - Scheduler
> Scheduler는 작업을 위한 메커니즘을 추상화합니다. 이러한 메커니즘에는 디스패치 큐,오퍼레이션 큐 DispatchQueue의 기능을 포함합니다. 
1.**oberveOn** : Observable이 Observer에게 **알리는 스케줄러** 를 다른 스케줄러로 지정합니다.  
```
Observable.just("800x600")
  .observeOn(ConcurrentDispatchQueueScheduler(qos: .default) //다음 stream들은 Concurrency하게 돌아간다
  .map{ $0.replacingOccurance(of: "x", with: "/")}
  .map{ "https://picsum.photos/\($0)/?random" }
  .map{ URL(sting: $0) }
  .filter{ $0 != nil }
  .map{ $0! }
  .map{ try Data(contentsOf: $0 }
  .map{ UImage(data: $0) }
  .observeOn(MainScheduler.instance) //subscribe는 main에서 돌려야 하기 때문에 
  .subscribe(onNext: { image in
    self.imageView.image = image
    
  })
  .disposed(by: disposeBag)
}
```

2.**subscribeOn** : subscribeOn은 Obsesrvable이 **동작하는 스케줄러** 를 다른 스케줄러로 지정하여 동작을 변경합니다.  
```
Observable.just("800x600")
  .map{ $0.replacingOccurance(of: "x", with: "/")}
  .map{ "https://picsum.photos/\($0)/?random" }
  .map{ URL(sting: $0) }
  .filter{ $0 != nil }
  .map{ $0! }
  .map{ try Data(contentsOf: $0 }
  .map{ UImage(data: $0) }
  .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default)) //위치는 상관없다
  //subscibe하는 순간 실행되는 코드이기 때문에
  .subscribe(onNext: { image in
    self.imageView.image = image //side-effect 발생하는 부분
    
  })
  .disposed(by: disposeBag)
}
```

### - side-effect를 허용해주는 2가지
외부에 영향을 끼쳐도 허용해주는!
1. subscribe
2. do

### - delegate를 사용하지 않고 로그인 가능 여부를 검사하려면 어떻게 해야할까?
```
idField.rx.text
  .filter{ $0 != nil }
  .map{ $0! }
  .map(checkEmailValid)
  .subscribe(onNext: { s in
    self.idValidView.isHidden = s
  })
  .disposed(by: disposeBag)
  
pwField.rx.text
  .filter{ $0 != nil }
  .map{ $0! }
  .map(checkPasswordValid)
  .subscribe(onNext: { s in
    self.pwValidView.isHidden = s
  })
  .disposed(by: disposeBag)
  
//두 Observable을 결합
Observable.combineLatest(
  idField.rx.text.orEmpty.map(checkEmailValid),
  pwField.rx.text.orEmpty.map(checkPasswordValid),
  resultSelector: { s1, s2 in s1 && s2 }
)
.subscribe(onNext: { b in
  self.loginButton.isEnabled = b
})
.disposed(by: disposeBag)
}
```

조금 더 고급지게 바꾸어보자!
```
let idInputOb: Observable<String> = idField.rx.orEmpty.asObservable()
let idValidOb = idInputOb.map(checkEmailValiid)

let pwInputOb: Observable<String> = pwField.rx.text.orEmpty.asObservable()
let pwValidOb = pwInputIb.map(checkPasswordValid)

idValidOb.subscribe(onNext: { b in self.idValidView.isHidden = b })
.disposed(by: disposeBag)
pwValidOb.subscribe(onNext: { b in self.passwordValidView.isHidden = b })
.disposed(by: disposeBag)

Observable.combineLatest(idValidOb, pwValidOb, resultSelecto: { $0 && $1 })
.subscribe(onNext: { b in self.loginButton.isEnabled = b }
.disposed(by: disposeBag)
```
