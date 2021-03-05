## 메모앱

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

