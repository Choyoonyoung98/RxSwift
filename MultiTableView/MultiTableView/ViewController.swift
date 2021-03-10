//
//  ViewController.swift
//  MultiTableView
//
//  Created by 조윤영 on 2021/03/09.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    let animalCell = "AnimalCell"
    let foodCell = "FoodCell"
    let animals = ["고양이", "개", "말", "사자", "곰", "여우", "쥐", "원숭이", "고양이", "개", "말", "사자", "곰", "여우", "쥐", "원숭이"]
    let foods = ["닭발", "파스타", "떡볶이", "치킨", "짬뽕", "짜장면", "족발", "닭발", "파스타", "떡볶이", "치킨", "짬뽕", "짜장면", "족발"]
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTableView()
    }
    
    func bindTableView() {
        bindTableView1()
        bindTableView2()
    }
}

extension ViewController {
    private func bindTableView1() {
        let animalsOb: Observable<[String]> = Observable.of(animals)
        
        animalsOb.bind(to: tableView1.rx.items) {(tableView: UITableView, index: Int, element: String) -> UITableViewCell in
            guard let cell1 = self.tableView1.dequeueReusableCell(withIdentifier: self.animalCell) as? AnimalTVCell else { return UITableViewCell() }
            cell1.titleLabel.text = element //tableViewItems[row]
            cell1.titleLabel.textColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            return cell1
        }
        .disposed(by: disposeBag)
    }
    
    private func bindTableView2() {
        let foodsOb: Observable<[String]> = Observable.of(foods)
        foodsOb.bind(to: tableView2.rx.items) {(tableView: UITableView, index: Int, element: String) -> UITableViewCell in
            guard let cell2 = self.tableView2.dequeueReusableCell(withIdentifier: self.foodCell) as? FoodTVCell else { return UITableViewCell() }
            cell2.titleLabel.text = element
            cell2.titleLabel.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            return cell2
        }
        .disposed(by: disposeBag)
    }
}
