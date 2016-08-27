/**
 * Created by alexo on 18-Jun-15.
 */
package story
{
import collections.behavior.BehActivity;
import collections.behavior.BehMenu;
import collections.behavior.BehPositioning;
import collections.behavior.BehResult;
import collections.inHistory.Category;
import collections.inHistory.Collection;
import collections.common.Equiler;
import collections.common.HeroActivity;
import collections.common.HeroRes;
import collections.inHistory.MatrixView;
import collections.common.Message;
import collections.inCity.Building;
import collections.inHistory.Win;
import collections.inWorld.Alliance;
import collections.inWorld.City;
import collections.common.GlobalRes;
import collections.common.Hero;
import collections.inCity.Land;
import collections.inCity.LandRes;
import collections.inWorld.Cloud;
import collections.inWorld.Status;
import collections.common.Modification;
import collections.inCity.ProblemSituation;
import collections.inWorld.TradeCost;
import collections.inWorld.TradeTransaction;

public class Danke
{
    private static var instance:Danke;		//Это будет уникальный экземпляр, созданный классом
    private static var ok2Create:Boolean=false;

    public var nextTurn:uint=0; //передача хода следующему (2 - передача)
    public var smallSkip:uint=0; //скипнуть текущую сценку

    public var landSituation:int=-1; //текущее состояние земель, -1 не обработано, 0 - ожидает нажатия, 1 - что-то показано
    public var darkScreen:int=-1;

    public var lands:Vector.<Land> = new Vector.<Land>(); //хранилище инфы о землях
    public var globalRes:Vector.<GlobalRes> = new Vector.<GlobalRes>(); //перечисление типов существующих ресурсов
    public var landRes:Vector.<LandRes> = new Vector.<LandRes>(); //перечисление типов существующих ресурсов

    public var problemSituation:Vector.<ProblemSituation> = new Vector.<ProblemSituation>();

    public var buildings:Vector.<Building> = new Vector.<Building>();
    public var updates:Vector.<Modification> = new Vector.<Modification>();
    public var updChange:Boolean=false; //показатель, что надо заново проверить вид элементов/доступно/недоступно/открыто
    public var updInfo:String=""; //подсказка о том, что должно быть отражено в окошке подсказки $info
    public var landInfoText:String=""; //подсказка, что пора править текстовку, описывающую землю
    public var updIII:int=-1;
    public var updCost:String=""; //стоимость апдейта
    public var update:Boolean=false; //нажата или нет кнопка апдейта

    public var reIncome:Boolean=false;
    public var lag:int=10;

    public var buildTap:int=-1; //переменная контроля, какое из зданий нажато
    public var buildIII:int=-1;
    public var landTap:int=-1;

    public var landInWork:int=-1; //контроль, какая земля выделена
    public var updWaitReady:Boolean=true;
    public var updReShow:Boolean=false;

    public var madeBuilding:int=-1; //номер IID в векторе subs, здания/земли, где было проведено строительство

    public var globalResChange:Boolean=true;//контролируем, что тип здания на локации был заменён, чтобы очистить список апгрейдов
    public var localResChange:Boolean=true;

    public var updateTap:int=-1;  //сохраняем, какой апдейт выделен игроком в окне покупке апдейта на землю
    public var updateMoney:int=-1;
    public var typeOfUpdatePay:int=-1;

    public var availableHeroes:Vector.<Hero> = new Vector.<Hero>(); //доступные типы героев
    public var currentHeroes:Vector.<Hero> = new Vector.<Hero>(); //уже имеющиеся персонажи
    public var names:Vector.<int> = new Vector.<int>(); //храним айдишники имён
    public var heroActivities:Vector.<HeroActivity> = new Vector.<HeroActivity>();
    public var heroRes:Vector.<HeroRes> = new Vector.<HeroRes>();

    public var numOfMany:int=-1; //порядковый номер в SubBuildingMenu, который был нажат
    public var numOfSub:int=-1; //спец параметр, если надо
    public var downOfMany:int=-1; //порядковый номер в SubBuildingMenu, который был зажат

    public var heroIIIbuyPanel:int=-1; //спец переменная, обозначающая, что по этого III будет храниться панель покупки героев
    public var heroIII:int=-1; //спец переменная, обозначающая, что по этого III будет храниться список панель с героями

    public var heroChoose:int=-1; //номер героя который был выделен
    public var heroOnTyppe:String=""; //над каким из игровых объектов отпустили героя
    public var heroOnNum:int=-1;
    public var heroStart:Boolean=false; //при нажатии на панель доступных героев
    public var outI:int=-1; //элемент вышел за границы области определения своего объекта

    public var heroActChange:Boolean=false;
    public var numActChange:int=0;
    public var newPosActChange:int=0;

    public var heroPanelClose:Boolean=false;
    //public var heroScreenCloseShadow:int=0;

    public var maxHeroNum:int=-1; //максимальное количество героев
    public var maxHeroActionsNum:int=-1; //максимальное количество действий для героя

    public var cities:Vector.<City> = new Vector.<City>();
    public var getsetX:int=-1; //координаты, которые можно брать у одного предмета, чтобы выставить их другому
    public var getsetY:int=-1;
    public var getsetNowX:int=250; //координаты, которые можно брать у одного предмета, чтобы выставить их другому
    public var getsetNowY:int=105;

    public var cityStart:int=-1;
    public var currentCity:int=-1; //номер в векторе
    public var cityClose:Boolean=false;
    public var cityName:int=-1; //номер в векторе предмета с названиями городов
    public var cityPanel:int=-1;
    public var cityDipPanel:int=-1; //панель дипломатии города
    public var heroFramNumInCity:int=-1;

    public var overCity:int=-1; //над каким городом последний раз был герой при перетягивании его мышкой

    public var playerIII:int=-1; //iii города игрока данного клиента
    public var currRelations:int=0;
    public var currPeaceWar:int=0;
    public var status:Vector.<Status> = new Vector.<Status>();

    public var tradeTransactions:Vector.<TradeTransaction> = new Vector.<TradeTransaction>();
    public var buyOffer:String="";
    public var sellOffer:String="";
    public var tradeCost:Vector.<TradeCost> = new Vector.<TradeCost>();

    //набор возможных действий игрока при перетягивании героя
    public var behAct:Vector.<BehActivity> = new Vector.<BehActivity>();
    public var behMenu:Vector.<BehMenu> = new Vector.<BehMenu>();
    public var behPos:Vector.<BehPositioning> = new Vector.<BehPositioning>();
    public var behRes:Vector.<BehResult> = new Vector.<BehResult>();
    public var heroMenuActivity:int=-1; //необходимость вывести меню для выбора действия героя
    public var heroMenuNum:int=-1; //количество пунктов в меню, два или три
    public var behChoice:int=-1; //номер пункта, выбранного пользователем меню выбора

    public var mess:Vector.<Message> = new Vector.<Message>(); //сообщения для игрока
    public var needToMakeMenu:Boolean=false;
    public var behPosFromMess:int=-1;
    public var messMenuPanel:int=-1; // номер в векторе списка сообщений
    public var messWasTap:int=-1; //номер элемента в предмете МенюСообщений, который был выбран игроком
    public var messRefram:Boolean=false; //значение обязательного пересмотра сообщений
    //dan.heroMenuActivity=dan.behPos[numOfRes].resIII; numOfRes???

    public var clouds:Vector.<Cloud> = new Vector.<Cloud>(); //туман войны
    public var cloudsOut:int=-1; //показатель, что одно из олак было удалено с карты мира

    public var shadowPlane:int=-1; //номер элемента с туманом войны

    public var heroMoveX:int=0; ///координаты, куда передвинули героя
    public var heroMoveY:int=0;

    public var governments:Vector.<Equiler> = new Vector.<Equiler>(); //соотношения номера типа правления города к номеру текстовки
    public var characters:Vector.<Equiler> = new Vector.<Equiler>();//соотношения номера типа характера города к номеру текстовки
    public var patrons:Vector.<Equiler> = new Vector.<Equiler>();//соотношения номера типа покровителя города к номеру текстовки
    public var alliances:Vector.<Alliance> = new Vector.<Alliance>();//вектор текущих союзов городов
    public var cityAllianceArmy:Boolean=false; //переменная true -показывает армию альянса, false - армию города

    public var knownCities:Vector.<int> = new Vector.<int>(); //айдишники в векторе городов, которые мы знаем
    public var known:int=0;//число известных городов
    public var dxKnown:int=-57; //сдвиг, на который нужно перемещать панель, когда открыт новый город
    public var specCityPanel:int=-1; //специальная панель для выбора городов
    public var numOfElemsCityPanel:int=0;//количество элементов на панели города

    public var heroChooseMemory:int=-1;

    public var willSave:Vector.<Collection> = new Vector.<Collection>(); //сохраняемые ресурсы
    public var categoryWillSave:int=0; //все цифры кроме 0 показывает, какой график должен построить менеджер по истории
    public var category:Vector.<Category> = new Vector.<Category>(); //параметры вывода категорий сохраняемых значений
    public var currMatrix:MatrixView = new MatrixView();
    public var historyTheHeroIsCome:Boolean=false;

    public var historyHeroChoose:int=-1;
    public var heroHistoryCategory:int=-1;

    public var techLevelTxt:Vector.<String> = new Vector.<String>(); // текстовки для уровня технологии, низкий, средний, высокий

    public var messFramsOfFramCost:Vector.<int> = new Vector.<int>(); //номер фрейма, на котороый должна перейти картинка
    public var messFramsOfNumCost:Vector.<int> = new Vector.<int>(); //цифра, которую должно принять текстовое поле

    public var cityOver:int=-1;//над каким городом отпустили героя

    public var advice:int=0; //номер подсказки, которую должен увидеть игрок

    public var wins:Vector.<Win> = new Vector.<Win>();//коллекция условий победы

    public var difficultyLevel:int=1;


    public function Danke()
    {
        if(!ok2Create) throw new Error(this+" is a Singleton. Access using getInstance()");
    }

    public function unDanke():void
    {
        nextTurn=0; //передача хода следующему (2 - передача)
        smallSkip=0; //скипнуть текущую сценку
        landSituation=-1; //текущее состояние земель, -1 не обработано, 0 - ожидает нажатия, 1 - что-то показано
        darkScreen=-1;
        lands = new Vector.<Land>(); //хранилище инфы о землях
        globalRes = new Vector.<GlobalRes>(); //перечисление типов существующих ресурсов
        landRes = new Vector.<LandRes>(); //перечисление типов существующих ресурсов
        problemSituation = new Vector.<ProblemSituation>();
        buildings = new Vector.<Building>();
        updates = new Vector.<Modification>();
        updChange=false; //показатель, что надо заново проверить вид элементов/доступно/недоступно/открыто
        updInfo=""; //подсказка о том, что должно быть отражено в окошке подсказки $info
        updIII=-1;
        updCost=""; //стоимость апдейта
        update=false; //нажата или нет кнопка апдейта
        reIncome=false;
        lag=10;
        buildTap=-1; //переменная контроля, какое из зданий нажато
        buildIII=-1;
        landTap=-1;
        landInWork=-1; //контроль, какая земля выделена
        updWaitReady=true;
        updReShow=false;
        madeBuilding=-1; //номер IID в векторе subs, здания/земли, где было проведено строительство
        globalResChange=true;//контролируем, что тип здания на локации был заменён, чтобы очистить список апгрейдов
        localResChange=true;
        updateTap=-1;  //сохраняем, какой апдейт выделен игроком в окне покупке апдейта на землю
        updateMoney=-1;
        typeOfUpdatePay=-1;
        availableHeroes = new Vector.<Hero>(); //доступные типы героев
        currentHeroes = new Vector.<Hero>(); //уже имеющиеся персонажи
        names = new Vector.<int>(); //храним айдишники имён
        heroActivities = new Vector.<HeroActivity>();
        heroRes = new Vector.<HeroRes>();
        numOfMany=-1; //порядковый номер в SubBuildingMenu, который был нажат
        numOfSub=-1; //спец параметр, если надо
        downOfMany=-1; //порядковый номер в SubBuildingMenu, который был зажат
        heroIIIbuyPanel=-1; //спец переменная, обозначающая, что по этого III будет храниться панель покупки героев
        heroIII=-1; //спец переменная, обозначающая, что по этого III будет храниться список панель с героями
        heroChoose=-1; //номер героя который был выделен
        heroOnTyppe=""; //над каким из игровых объектов отпустили героя
        heroOnNum=-1;
        heroStart=false; //при нажатии на панель доступных героев
        outI=-1; //элемент вышел за границы области определения своего объекта
        heroActChange=false;
        numActChange=0;
        newPosActChange=0;
        heroPanelClose=false;
        maxHeroNum=-1; //максимальное количество героев
        maxHeroActionsNum=-1; //максимальное количество действий для героя
        cities = new Vector.<City>();
        getsetX=-1; //координаты, которые можно брать у одного предмета, чтобы выставить их другому
        getsetY=-1;
        getsetNowX=250; //координаты, которые можно брать у одного предмета, чтобы выставить их другому
        getsetNowY=152;
        cityStart=-1;
        currentCity=-1; //номер в векторе
        cityClose=false;
        cityName=-1;
        cityPanel=-1;
        heroFramNumInCity=-1;
        playerIII=-1; //iii города игрока данного клиента
        currRelations=0;
        currPeaceWar=0;
        status = new Vector.<Status>();
        tradeTransactions = new Vector.<TradeTransaction>();
        buyOffer="";
        sellOffer="";
        tradeCost = new Vector.<TradeCost>();
        behAct = new Vector.<BehActivity>();
        behMenu = new Vector.<BehMenu>();
        behPos = new Vector.<BehPositioning>();
        behRes = new Vector.<BehResult>();
        heroMenuActivity=-1; //необходимость вывести меню для выбора действия героя
        heroMenuNum=-1;
        behChoice=0;
        mess = new Vector.<Message>();
        messRefram=false;
        needToMakeMenu=false;
        behPosFromMess=-1;
        messMenuPanel=-1;
        messWasTap=-1;
        clouds = new Vector.<Cloud>();
        cloudsOut=-1
        shadowPlane=-1;
        heroMoveX=0;
        heroMoveY=0;

        governments = new Vector.<Equiler>();
        characters = new Vector.<Equiler>();
        patrons = new Vector.<Equiler>();
        alliances = new Vector.<Alliance>();
        cityAllianceArmy = false;

        knownCities = new Vector.<int>();
        known=0;//число известных городов
        dxKnown=0;
        specCityPanel=-1;

        cityDipPanel=-1;

        heroChooseMemory=-1;

        willSave = new Vector.<Collection>();
        categoryWillSave=0;
        currMatrix = new MatrixView();
        historyTheHeroIsCome=true;
        historyHeroChoose=-1;
        heroHistoryCategory=-1;

        techLevelTxt = new Vector.<String>();
        messFramsOfFramCost = new Vector.<int>();
        messFramsOfNumCost = new Vector.<int>();
        cityOver=-1;

        advice=0;
        overCity=-1;

        wins = new Vector.<Win>();
    }

    public static function getInstance():Danke
    {
        //Если нет экземпляра, создаем его
        if(!instance)
        {
            //Разрешить создание экземпляра, а после его создания запретить
            ok2Create = true;
            instance = new Danke();
            ok2Create = false;
            trace('Exemplar "Danke" is done!');
        }
        return instance;
    }
}
}