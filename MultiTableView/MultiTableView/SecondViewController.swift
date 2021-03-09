//
//  SecondViewController.swift
//  MultiTableView
//
//  Created by 조윤영 on 2021/03/09.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    
    let animalCell = "AnimalCell"
    let foodCell = "FoodCell"
    let animals = ["고양이", "개", "말", "사자", "곰", "여우", "쥐", "원숭이", "고양이", "개", "말", "사자", "곰", "여우", "쥐", "원숭이"]
    let foods = ["닭발", "파스타", "떡볶이", "치킨", "짬뽕", "짜장면", "족발", "닭발", "파스타", "떡볶이", "치킨", "짬뽕", "짜장면", "족발"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView1.tag = 0
//        tableView2.tag = 1
    }
}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 { return animals.count }
        else if tableView == tableView2 { return foods.count }
        //tableView.tag == 0
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableView1 {
            guard let cell1: AnimalTVCell = tableView1.dequeueReusableCell(withIdentifier: animalCell, for: indexPath ) as? AnimalTVCell else { return UITableViewCell() }
            cell1.titleLabel.text = animals[indexPath.row]
            cell1.titleLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            return cell1
        } else if tableView == tableView2 {
            guard let cell2: FoodTVCell = tableView2.dequeueReusableCell(withIdentifier: foodCell, for: indexPath ) as? FoodTVCell else { return UITableViewCell() }
            cell2.titleLabel.text = foods[indexPath.row]
            cell2.titleLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            return cell2
        } else { return UITableViewCell() }
    }
}
