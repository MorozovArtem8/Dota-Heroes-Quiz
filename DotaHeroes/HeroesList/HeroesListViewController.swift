import UIKit



class HeroesListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var heroesStat = Heroes()
    private var questionFactory: QuestionFactoryProtocolGet?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controllers = tabBarController?.viewControllers?[0]
        if let controller1 = controllers as? HeroesQuizViewController {
            questionFactory = controller1.passQuestionFactory()
            heroesStat = questionFactory?.getHeroes() ?? Heroes()
            print(heroesStat.count)
        }
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
    }
    
    private func downloadImage(cell: TableViewCell, indexPath: IndexPath) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            var imageData = Data()
            
            do {
                
                if let heroesImageUrl = heroesStat[indexPath.row].imageURL {
                    imageData = try Data(contentsOf: heroesImageUrl)
                }
                
            } catch {
                print("Не получилось")
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: imageData) {
                    cell.heroIconImageView.image = image.roundedImageWithBottomCorners(radius: 16)
                    cell.descriptionView.roundCorners(corners: [.topLeft, .topRight], radius: 16)
                }
               
            }
        }
    }
    
    private func configureCell(cell: TableViewCell, indexPath: IndexPath) {
        cell.heroNameLabel.text = heroesStat[indexPath.row].localizedName
        cell.atributeImageView.image = UIImage(named: "att_\(heroesStat[indexPath.row].primaryAttr.rawValue)") ?? UIImage()
        downloadImage(cell: cell, indexPath: indexPath)
    }
    


}

extension HeroesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroesStat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath)
        
        guard let cell = cell as? TableViewCell else {
            return UITableViewCell()
        }
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    
}

extension HeroesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageWidth: CGFloat = 256
        let imageHeight: CGFloat = 144
        let imageViewConstraints = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageViewConstraints.left - imageViewConstraints.right
        let widthRatio = imageViewWidth / imageWidth
        let imageViewHeight = widthRatio * imageHeight + 8
        return imageViewHeight + 30
        
    }
}
