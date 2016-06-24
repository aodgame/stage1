/**
 * Created by alexo on 18-Jun-15.
 */
package story
{
import collections.common.HeroActivity;
import collections.common.HeroRes;
import collections.inCity.Building;
import collections.inWorld.City;
import collections.common.GlobalRes;
import collections.common.Hero;
import collections.inCity.Land;
import collections.inCity.LandRes;
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
    public var getsetNowY:int=152;

    public var cityStart:int=-1;
    public var currentCity:int=-1; //номер в векторе
    public var cityClose:Boolean=false;
    public var cityPanel:int=-1;
    public var heroFramNumInCity:int=-1;

    public var playerIII:int=-1; //iii города игрока данного клиента
    public var currRelations:int=0;
    public var currPeaceWar:int=0;
    public var status:Vector.<Status> = new Vector.<Status>();

    public var tradeTransactions:Vector.<TradeTransaction> = new Vector.<TradeTransaction>();
    public var buyOffer:String="";
    public var sellOffer:String="";
    public var tradeCost:Vector.<TradeCost> = new Vector.<TradeCost>();

    public function Danke()
    {
        if(!ok2Create) throw new Error(this+" is a Singleton. access using getInstance()");
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