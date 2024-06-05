import UIKit

class CurrentHeroViewController: UIViewController {
    
    //MARK: View
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let label = UILabel()
    private let imageHero = UIImageView()
    private let backButton = UIButton()
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else {return}
        }
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
}

private extension CurrentHeroViewController {
    func setupLayout() {
        configureScrollView()
        configureContentView()
        prepareScrollView()
        configureLabel()
        addContentToScrollView()
        configureBackButton()
        
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
    
    func configureLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hero Name"
        label.textColor = .white
    }
    
    func configureImageView() {
        guard let image = image else {return}
        let imageViewWidth = UIScreen.main.bounds.size.width - 16
        let widthRatio = imageViewWidth / image.size.width
        let imageViewHeight = widthRatio * image.size.height
        imageHero.layer.cornerRadius = 15
        imageHero.clipsToBounds = true
        
        imageHero.image = image
        
        imageHero.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageHero)
        NSLayoutConstraint.activate([
            imageHero.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            imageHero.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageHero.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
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
    
    func addContentToScrollView() {
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
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
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
    }
}
