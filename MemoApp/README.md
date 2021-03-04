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
> 
