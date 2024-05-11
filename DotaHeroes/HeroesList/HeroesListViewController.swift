import UIKit



class HeroesListViewController: UIViewController {
    
    private var heroesStat = Heroes()
    private var questionFactory: QuestionFactoryProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controllers = tabBarController?.viewControllers?[0]
        if let controller1 = controllers as? HeroesQuizViewController {
            questionFactory = controller1.passQuestionFactory()
            heroesStat = questionFactory?.getHeroes() ?? Heroes()
            print(heroesStat.count)
        }
        
    }
    


}

extension HeroesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroesStat.count + 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell
        
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier) {
            cell = reusedCell as! TableViewCell
        } else {
            cell = TableViewCell(style: .default, reuseIdentifier: TableViewCell.reuseIdentifier)
        }
        
        var content = cell.defaultContentConfiguration()
        content.text = heroesStat[indexPath.row].localizedName
        content.secondaryText = heroesStat[indexPath.row].roles.description
        cell.contentConfiguration = content
        return cell
    }
    
    
}
