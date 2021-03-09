## 하나의 ViewController에 여러 개의 TableViewController 구현하기

### 기본
#### 1) tableView 이름으로 구분
#### 2) tag로 구분

### 번외) RxSwift로 tableView를 구현하는 4가지 방법
크게는 **tableView.rx.items에 bind하는 법** , **RxDataSource를 사용하는 법** 2가지로 구분됩니다.  

#### 1) tableView.rx.items
```
private func bindTableView() {
  let cities = ["London", "Vienna", "Lisbon"]

  let citiesOb: Observable<[String]> = Observable.of(cities)
  citiesOb.bind(to: tableView.rx.items) { (tableView: UITableView, index: Int, element: String) -> UITableViewCell in
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell") else { return UITableViewCell() }
    cell.textLabel?.text = element
    return cell
  }
  .disposed(by: disposeBag)
}
```

#### 2) tableView.rx.items(cellIdentifier: String)
```
private func bindTableView() {
  let cities = ["London", "Vienna", "Lisbon"]
  
  let citiesOb: Observable<[String]> = Observable.of(cities)
  citiesOb.bind(to: tableView.rx.items(cellIdentifier: "NameCell")) { (index: Int, element: String, cell: UITableViewCell) in
    cell.textLabel?.text = element
  }
  .disposed(by: bag)
}
```

#### 3) tableView.rx.items(cellIdentifier: String, cellType: Cell.Type)
> 2번과 다르게 기본 Cell이 아닌 CustomCell을 지정해서 구현 가능
> 대신, CellType로 지정해준 한 가지 type의 cell만 사용할 수 있습니다!  
```
 private func bindTableView() {
   let cities = ["London", "Vienna", "Lisbon"]
   
   let citiesOb: Observable<[String]> = Observable.of(cities)
   citiesOb.bind(to: tableView.rx.items(cellIdentifier: "NameCell", cellType: NameCell.self)) { (index: Int, element: String, cell: NameCell) in
      cell.numberLabel.text = "\(index)"
      cell.nameLabel.text = element
    }
    .disposed(by: bag)
 }
```

#### 4) tableView.rx.items(dataSource: protocol<RxTableViewDataSourceType, UITableViewDataSource>) 사용하기
> 기존에 있던 datasource 개념을 더 명시적으로 구현해줄 수 있는 방법
> section에 대한 구현도 가능!

- pod으로 RxDataSource를 설치해주고 import합니다.
`import RxDataSources`  

- 클래스로 만든 이 datasource를 사용합니다.
````
open class RxTableViewSectionedReloadDataSource<S: SectionModelType>: TableViewSectionedDataSource<S>
````

- RxDdataSources에서는 SectionModelType를 따르는 SectionModel을 이미 구현해놓았는데, 이것을 사용하면 됩니다.  
```
public struct SectionModel<Section, ItemType> {
  public var model: Section
  public var items: [Item]

  public init(model: Section, items: [Item]) {
      self.model = model
      self.items = items
  }
}

extension SectionModel: SectionModelType {
    public typealias Identity = Section
    public typealias Item = ItemType
    
    public var identity: Section { return model }
}
```

- 이제 위의 것들을 사용하게 되면 아래와 같은 방법으로 section 별 구분되는 tableView를 구현할 수 있습니다.  
````
private func bindTableView() {
  typealias CitySectionModel = SectionModel<String, String>
  typealias CityDataSource = RxTableViewSectionedReloadDataSource<CitySectionModel>
  
  let firstCities = ["London", "Vienna", "Lisbon"]
  let secondCities = ["Paris", "Madrid", "Seoul"]
  let sections = [
      SectionModel<String, String>(model: "first section", items: firstCities),
      SectionModel<String, String>(model: "second section", items: secondCities)
  ]
  
  Observable.just(sections)
    .bind(to: tableView.rx.items(dataSource: datasource))
    .disposed(by: bag)
  
  private var cityDatasource: CityDataSource {
    let configureCell: (TableViewSectionedDataSource<CitySectionModel>, UITableView,IndexPath, String) -> UITableViewCell = { (datasource, tableView, indexPath,  element) in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as? NameCell else { return UITableViewCell() }
      cell.textLabel?.text = element
      return cell
    }
  
    let datasource = CityDataSource.init(configureCell: configureCell)
    datasource.titleForHeaderInSection = { datasource, index in
        return datasource.sectionModels[index].model
    }
    
    return datasource
  }
}
````

