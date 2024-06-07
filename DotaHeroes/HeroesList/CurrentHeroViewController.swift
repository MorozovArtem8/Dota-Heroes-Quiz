import UIKit

protocol HeroesInfoFactoryDelegate: AnyObject {
    func didLoadDataFromServer(heroInfo: CurrentHeroInfo)
    func didFailToLoadData(with error: Error)
    func didFailToLoadImage(with error: Error)
}

class CurrentHeroViewController: UIViewController {
    
    //MARK: View
    private let activityIndicator = UIActivityIndicatorView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let heroNameLabel = UILabel()
    private let textView = UITextView()
    private let imageHero = UIImageView()
    private let backButton = UIButton()
    
    
    private var heroInfoStat: Hero?
    private var heroesInfoFactory: HeroesInfoFactoryProtocol?
    var heroId: String? // id героя которого мы передали по табу на ячейку
    var image: UIImage? {
        didSet {
            guard isViewLoaded else {return}
        }
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        heroNameLabel.text = ""
        setupLayout()
        guard let heroId = heroId else {return}
        print("viewDidLoad")
        heroesInfoFactory = HeroesInfoFactory(heroId: heroId, delegateViewController: self)
        heroesInfoFactory?.loadData()
        
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func addAbilityForContentView() {
        guard let abilities = heroInfoStat?.abilities else {return}
        var previousView: UIView?
        
        for (index, ability) in abilities.enumerated() {
            
           
            print(ability.nameLoc)
            let abilityView = UIView()
            abilityView.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1843137255, blue: 0.2196078431, alpha: 1)
            abilityView.layer.cornerRadius = 10
            abilityView.clipsToBounds = true
            abilityView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(abilityView)
            configureContentInAbilityView(abilityView: abilityView, index: index)
            
            NSLayoutConstraint.activate([
                abilityView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
                abilityView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
                
            ])
            
            if let previousView = previousView {
                NSLayoutConstraint.activate([
                    abilityView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 10)
                ])
            } else {
                abilityView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10).isActive = true
            }
            
            previousView = abilityView
            
            if index == abilities.count - 1 {
                abilityView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true // приравниваем последний элемент к концу contentView
            }
            
        }
    }
    
    func configureContentInAbilityView(abilityView: UIView, index: Int) {
        guard let image = UIImage(named: "dota_icon") else {return}
        let imageView = UIImageView()
        imageView.image = image
        
        let nameAbilityLabel = UILabel()
        nameAbilityLabel.textColor = .white
        nameAbilityLabel.text = heroInfoStat?.abilities[index].nameLoc
        nameAbilityLabel.translatesAutoresizingMaskIntoConstraints = false
        nameAbilityLabel.font = UIFont.boldSystemFont(ofSize: 18)
        abilityView.addSubview(nameAbilityLabel)
        
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.text = heroInfoStat?.abilities[index].descLoc
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        abilityView.addSubview(textView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        abilityView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: abilityView.topAnchor, constant: 4),
            imageView.leadingAnchor.constraint(equalTo: abilityView.leadingAnchor, constant: 4),
            //imageView.bottomAnchor.constraint(equalTo: abilityView.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 75),
            imageView.widthAnchor.constraint(equalToConstant: 75),
            
            nameAbilityLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            nameAbilityLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            nameAbilityLabel.trailingAnchor.constraint(equalTo: abilityView.trailingAnchor, constant: -10),
            
            textView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: abilityView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: abilityView.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: abilityView.bottomAnchor)
           
        ])
        
    }
    
    func configureActivityIndicator() {
        activityIndicator.style = .large
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
    }
    
}

//MARK: HeroesInfoFactoryDelegate func
extension CurrentHeroViewController: HeroesInfoFactoryDelegate {
    func didLoadDataFromServer(heroInfo: CurrentHeroInfo) {
        activityIndicator.stopAnimating()
        self.heroInfoStat = heroInfo.result.data.heroes.first
        guard let name = heroInfoStat?.nameLoc else {return}
        heroNameLabel.text = name
        configureTextViewInfoHero()
        addAbilityForContentView()
        
    }
    
    
    func didFailToLoadData(with error: any Error) {
        
    }
    
    func didFailToLoadImage(with error: any Error) {
        
    }
    
    
}

private extension CurrentHeroViewController {
    func setupLayout() {
        
        configureScrollView()
        configureContentView()
        prepareScrollView()
        configureHeroNameLabel()
        addContentToScrollView()
        configureBackButton()
        configureActivityIndicator()
        
    }
    
    func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
    }
    
    func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }
    
    func configureHeroNameLabel() {
        heroNameLabel.translatesAutoresizingMaskIntoConstraints = false
        heroNameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        heroNameLabel.textColor = .white
    }
    
    func configureImageView() {
        guard let image = image else {return}
        let imageViewWidth = UIScreen.main.bounds.size.width - 32
        let widthRatio = imageViewWidth / image.size.width
        let imageViewHeight = widthRatio * image.size.height
        imageHero.layer.cornerRadius = 15
        imageHero.clipsToBounds = true
        
        imageHero.image = image
        
        imageHero.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageHero)
        NSLayoutConstraint.activate([
            imageHero.topAnchor.constraint(equalTo: heroNameLabel.bottomAnchor, constant: 10),
            imageHero.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageHero.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageHero.heightAnchor.constraint(equalToConstant: imageViewHeight)
        ])
    }
    
    func configureBackButton() {
        backButton.setImage(UIImage(named: "Backward"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8)
        ])
    }
    
    func configureTextViewInfoHero() {
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.text = heroInfoStat?.bioLoc
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textView)
        
        textView.text = heroInfoStat?.bioLoc
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: imageHero.bottomAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
   
    
    func addContentToScrollView() {
        contentView.addSubview(heroNameLabel)
        
        NSLayoutConstraint.activate([
            heroNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            heroNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            //label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor), // приравниваем последний элемент к концу contentView
        ])
        configureImageView()
    }
    
    func prepareScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
    }
}
