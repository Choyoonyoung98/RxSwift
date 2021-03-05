## 메모앱: RxSwift + MVVM

#### - MVVM 등장 배경
> MVC의 ViewController 역할이 커지자 등장한 것이 MVP, View가 화면의 input과 output을 처리하게 되고, Presenter는 input을 활용한 로직을 처리하고 화면에 무엇을 그릴지 알려주는 역할 을 담당합니다. (ViewController - 화면에 표시하는 역할) 그런데 View와 Presenter가 1:1의 관계를 가지게 되고 View를 생성할 떄마다 Presenter를 생성하게 되어 비슷한 View와 Presenter들이 많이 만들어지게 되는 문제점 발생 
> 그래서 만들어진 디자인패턴이 MVVM, ViewModel은 화면에 표시하는 역할을 하지 않고, 화면에 그려지는 요소만 가지고 있을거야! ViewModel이 input에 대한 처리가 완료되면 지켜보던 View가 화면을 표시하는 로직으로 구성됩니다.  

#### - optional binding
1. filter로 not nil 값 걸러내고, map으로 강제언래핑한 후 사용
```
idTextField.rx.text
  .filter{ $0 != nil }
  .map{ 0! }
  .map(checkIdValid)
  .subscribe(onNext: { s in
    print(s)
  })
  .disposed(by: disposeBag)
```
2. compactMap으로 not nil인 값 찾고, 언래핑
```
idTextField.rx.text
  .compactMap{ $0 }
  .map(checkIdValid)
  .subscribe(onNext: { s in
    print(s)
  })
  .disposed(by: disposeBag)
```
3. **orEmpty** : oprional을 바인딩해주는 Extension
```
idTextField.rx.text.orEmpty
  .map(checkIdValid)
  .subscribe(onNext: { s in
    print(s)
  })
  .disposed(by: disposeBag)
```

#### - CombindLatest VS Zip VS Merge
1. **[combineLatest](http://reactivex.io/documentation/operators/combinelatest.html)** : 어느 하나라도 방출이 될 때마다 가장 최근의 값들을 combine하여 결과값을 계산하는 방식
2. **[zip](http://reactivex.io/documentation/operators/zip.html)** : 두개의 스트림에서 모두 새로운 값이 방출이 될 때 결과값을 계산하는 방식
3. **[Merge](http://reactivex.io/documentation/operators/merge.html)** : 각 Observable에서 내려오는 값들을 가지고 계산하지 않고, 새로운 값을 받을 때마다 그대로 방출해주는 방식

#### - PublishSubject VS BehaviorSubject
> 두 종류의 Subject 모두 전달받은 이벤트를 Observer로 전달하는 기능을 수행합니다. 다만 BehaviorSubject는 반드시 값을 초기화 해주어야 한다는 점에서 차이점을 가집니다.  

