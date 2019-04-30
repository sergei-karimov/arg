//
//  ARScineViewController.swift
//  ARG
//
//  Created by Sergei Karimov on 27/01/2019.
//  Copyright © 2019 Sergei Karimov. All rights reserved.
//

import UIKit
import ARKit

class ARScineViewController: UIViewController, ARSCNViewDelegate {
    /// Primary SceneKit view that renders the AR session
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var exit: UIButton!
    var selectedImage : ImageInformation?
    
    let images = [
//        "Picture1" : ImageInformation(name: "ЛИТЕРАТУРНЫЙ МУЗЕЙ М.И. ЦВЕТАЕВОЙ", description: "Открыт 29 декабря 2003\nЭкспозиция музея рассказывает о литературном творчестве Марины Цветаевой, её творческих и дружеских связях с литературными деятелями эпохи: М. Волошиным, О. Мандельштамом, Б. Пастернаком, В. Маяковским, А. Белым, В. Ходасевичем и др., отношении современников к личности и творчеству поэта и о знаковых событиях в жизни Марины Цветаевой.", image: UIImage(named: "1")!),
//         "Picture2" : ImageInformation(name: "Библиотека Серебряного века", description: "Елабужского государственного музея-заповедника\nБиблиотека Серебряного века была создана в 2005 году. Она располагается в одном из исторических зданий города и входит в Мемориальный комплекс М.И. Цветаевой Елабужского государственного музея-заповедника. Основу её книжных фондов (порядка 6 тысяч томов) составляют произведения современников М.И. Цветаевой: Б. Пастернака, О. Мандельштама, Н. Гумилева, А. Ахматовой и других, литературные и биографические исследования.", image: UIImage(named: "2")!),
//         "Picture3" : ImageInformation(name: "дом памяти м.и.цветаевой", description: "В 2005 году при поддержке Министерства культуры и по распоряжению Кабинета министров и лично премьер-министра РТ Р.Н. Минниханова был выкуплен из частной собственности и музеефицирован жилой дом постройки 1925 года — бывший дом семьи Бродельщиковых, в котором прошли последние 10 дней жизни эвакуированной из Москвы Марины Цветаевой.\nМемориальная экспозиция Дома памяти М.И. Цветаевой воспроизводит обстановку дома елабужской семьи начала 1940-х гг. Представлены предметы быта семьи Бродельщиковых: сундук, швейная машинка, настенное зеркало, посуда.\nГлавная ценность — записная книжка, принадлежавшая Цветаевой.", image: UIImage(named: "3")!),
//         "Picture4" : ImageInformation(name: "памятник бюст м.и. цветаевой", description: "В целях увековечения памяти М.И.Цветаевой в г. Елабуге на основе восстановления мемориального пространства и мест, связанных с ее именем, создан Мемориальный комплекс ее имени.Бюст работы московских скульпторов А. Головачева и В. Демченко.", image: UIImage(named: "4")!),
//         "Picture5" : ImageInformation(name: "Музей «Портомойня»", description: "В старинном здании из природного бутового камня располагалась общественная прачечная. Здесь брали воду жители ближайшей округи. В музее всё, как в XIX веке: пол из бутового камня, деревянные трубы, чугунная печь, сохранивша¬яся с 1870 г., фрагмент трубы водопровода, построенного в 1833 г.\nДополняют интерьер музея корзины для белья, деревянные корыта и чаны, старинные инструменты для стирки: валек, стиральная доска, рубель. В августе 1941 г. М.И. Цветаева, живя неподалёку в доме Бродельщиковых, приходила в портомойню за водой.", image: UIImage(named: "5")!),
//         "Picture6" : ImageInformation(name: "Покровский собор", description: "Год постройки: 1806—1820\nАрхитектурный стиль: Ампир, Классицизм, Барокко\nОснование Покровской церкви г.Елабуги во второй половине XVI века предание связывает с именем царя ИоаннаIV Васильевича Грозного. В одном из них говорится, что царь Иоанн IVпосле покорения Казани отправился по р. Каме в Соликамск. Но из-за болезни вынужден был остановиться в устье р. Тоймы, на том месте, где стоит теперь Елабуга. По выздоровлении, желая ознаменовать место своего временного пребывания, Иоанн Васильевич приказал заложить тут церковь в честь Покрова Божией Матери.\nВ 1990-м году Патриарх Всея Руси Алексий Второй дал письменное благословение на отпевание «рабы Божией Марины». Произошло это в церкви Покрова Божьей Матери здесь же, в Елабуге. И с тех пор каждый год 31 августа - в день ее смерти - настоятель этой церкви служит панихиду по Марине Цветаевой.\nК празднованию 1000-летия города Елабуги, которое состоялось в августе 2007 год, были проведены большие восстановительные работы Покровского собора. Был произведен ремонт фасада, заменена кровля купола храма и шпиля колокольни. Также были изготовлены и установлены кресты под позолоту на куполе, колокольне и над входом в храм.", image: UIImage(named: "6")!),
//         "Picture7" : ImageInformation(name: "Могила М.И. Цветаевой", description: "В 1941 году в южной части Петропавловского кладбища была похоронена Марина Ивановна Цветаева, без ритуальных церемоний и креста. Со временем место захоронения стёрлось из памяти местных жителей. В 1960 году в Елабугу приехала сестра поэтессы Анастасия Ивановна Цветаева и после долгих поисков могилы устанавливает на произвольном месте крест с надписью: \"В этой стороне кладбища была похоронена М.И. Цветаева\". По решению Союза писателей Татарии в 1970 году крест был заменен на гранитное надгробие. В августе 1990 года с письменного благословения Патриарха Всея Руси Алексия II было совершено долгожданное отпевание \"рабы божией Марины\". В августе 2010 года, в день памяти Цветаевой, была установлена кованая скамья с декоративными ветками рябины и памятная стела.\nВ наши дни могила М.И.Цветаевой является памятником культуры федерального значения и местом паломничества почитателей творчества великой поэтессе. В разные времена могилу Цветаевой посещали: Владимир Высоцкий, Евгений Евтушенко и другие известные люди искусства.", image: UIImage(named: "7")!),
         "TeatrKukol10" : ImageInformation(name: "Театр кукол", description: "Театр кукол.", image: UIImage(named: "8")!),
         "TeatrKukol_11" : ImageInformation(name: "Театр кукол", description: "Театр кукол.", image: UIImage(named: "8")!),
         "TeatrKukol_12" : ImageInformation(name: "Театр кукол", description: "Театр кукол.", image: UIImage(named: "8")!),
         "TeatrKukol_13" : ImageInformation(name: "Театр кукол", description: "Театр кукол.", image: UIImage(named: "8")!),
         "TeatrKukol_14" : ImageInformation(name: "Театр кукол", description: "Театр кукол.", image: UIImage(named: "8")!),
         "TeatrKukol_15" : ImageInformation(name: "Театр кукол", description: "Театр кукол.", image: UIImage(named: "8")!),
         "TeatrKukol_16" : ImageInformation(name: "Театр кукол", description: "Театр кукол.", image: UIImage(named: "8")!),
         "TeatrKukol_17" : ImageInformation(name: "Театр кукол", description: "Театр кукол.", image: UIImage(named: "8")!),
         "TeatrKukol_18" : ImageInformation(name: "Театр кукол", description: "Театр кукол.", image: UIImage(named: "8")!),
         "TeatrKukol_19" : ImageInformation(name: "Театр кукол", description: "Театр кукол.", image: UIImage(named: "8")!),
         "TeatrKukol_20" : ImageInformation(name: "Театр кукол", description: "Театр кукол.", image: UIImage(named: "8")!),
         "teatrkukol_21" : ImageInformation(name: "Театр кукол", description: "Театр кукол.", image: UIImage(named: "8")!),
         "teatrkukol_22" : ImageInformation(name: "Театр кукол", description: "Театр кукол.", image: UIImage(named: "8")!),
         "teatrkukol_23" : ImageInformation(name: "Театр кукол", description: "Театр кукол.", image: UIImage(named: "8")!),
         "teatr" : ImageInformation(name: "Театр кукол", description: "Театр кукол.", image: UIImage(named: "8")!),
         "sud" : ImageInformation(name: "Театр кукол", description: "Театр кукол.", image: UIImage(named: "8")!),
    ]
    
    /// A serial queue for thread safety when modifying SceneKit's scene graph.
    let updateQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).serialSCNQueue")
    
    // MARK: - Lifecycle
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        guard let _ = anchor as? ARImageAnchor else { return }
//        self.performSegue(withIdentifier: "showImageInformation", sender: self)
        
        if let imageAnchor = anchor as? ARImageAnchor,
            let referenceImageName = imageAnchor.referenceImage.name,
            let scannedImage = self.images[referenceImageName] {
            self.selectedImage = scannedImage
            self.performSegue(withIdentifier: "showImageInformation", sender: self)
        }
    }
    
    // Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as FPS and timing information (useful during development)
//        sceneView.showsStatistics = true
        
        // Enable environment-based lighting
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageInformation"{
            if let imageInformationVC = segue.destination as? ImageInformationViewController,
                let actualSelectedImage = selectedImage {
                imageInformationVC.imageInformation = actualSelectedImage
            }
        }
    }

    // Notifies the view controller that its view is about to be added to a view hierarchy.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let refImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = refImages
        configuration.maximumNumberOfTrackedImages = 1
        
        // Run the view's session
        sceneView.session.run(configuration, options: ARSession.RunOptions(arrayLiteral: [.resetTracking, .removeExistingAnchors]))
    }
    
    // Notifies the view controller that its view is about to be removed from a view hierarchy.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    @IBAction func exitTouchUpInside(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
