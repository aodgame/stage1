/**
 * Created by alexo on 15-May-15.
 */
package story
{
public class Quest
{
    private var i:uint; //порядковая переменная для счёта

    public var qid:uint; //ид действия

    public var activ:Boolean; //активно ли действие в данный момент
    public var afterActiv:Boolean; //активно ли действие после завершения

    public var screen_work:uint; //комната, в которой будет работать квест

    public var action:Array = new Array(); //ряд условий выполнения действия
    public var rready:Boolean=false; //выполнены ли все условия

    public var effect:Array = new Array(); // ряд результатов выполнения действий

    public var isGoing:uint=0; //для зацикленных квестов, работающих вне зависимости от того, выполнены они или нет
    //или для условий, требующих выполнения действий обратных заданным

    public var  willSave:Boolean;

    public var moduleName:String="";

    public function Quest(adv, cid)
    {
        main(adv, cid);
        act(adv);
        eff(adv);
    }

    public function main(adv, cid):void
    {
        moduleName=cid;
        qid=adv.qid;
        //trace("!!qid="+qid);
        if (adv.qid.@activ==1)
        {
            activ=true;
        } else
        {
            activ=false;
        }
        if (adv.qid.@after_work=="1")
        {
            afterActiv=true;
        } else
        {
            afterActiv=false;
        }
        screen_work=adv.qid.@screenWork;

        if (adv.qid.@willSave=="1")
        {
            willSave=true;
        } else
        {
            willSave=false;
        }
    }

    public function act(adv):void
    {
        //определяем требуемые действия
        for (i = 0; i < adv.action.length(); i++)
        {
            action.push(new Object());
            action[i].typpe = adv.action[i];

            if (adv.action[i] == "no")
            {
                //безусловное задание, рапортующее о своём успешном совершении
            }

            if (adv.action[i] == "tap")
            {
                action[i].iii=adv.action[i].@iii;
            }

            if (adv.action[i]=="nextTurn")
            {//следующий ход
                action[i].num=adv.action[i].@num;
            }

            if (adv.action[i]=="resEnd")
            {//закончился ресурс
                action[i].num=adv.action[i].@num;
                action[i].vectorI=-1;
            }

            if (adv.action[i]=="curDate")
            {//точная дата, в которую должно произойти событие
                action[i].first=adv.action[i].@first;
                action[i].second=adv.action[i].@second;
            }
            if (adv.action[i]=="timeMoreThan")
            {//в игре прошло ходов больше, чем...
                action[i].iii=adv.action[i].@iii;
            }

            if (adv.action[i] == "positionIt")
            {
                //спозиционировать предметы
            }
            if (adv.action[i] == "visIt")
            {
                //визуализировать предметы
            }
            if (adv.action[i] == "darken")
            {
                //проверка параметра в danke
            }
            if (adv.action[i] == "workActivity")
            {
                //передвинут человек
            }
            if (adv.action[i] == "madeBuild")
            {
                //проведено строительство, надо создать препятствие build на земле
            }
            if (adv.action[i] == "res")
            {
                //проверяем потребность одного глобального ресурса в другом
            }
            if (adv.action[i]=="updWaitReady")
            {//режим покупки апдейтов работает
                action[i].res=adv.action[i].@res;
            }
            if (adv.action[i] == "changeTurn")
            {
                //новый ход
            }
            if (adv.action[i] == "resLevelLowerThan")
            { //уровень ресурса меньше, чем
                action[i].tip=adv.action[i].@tip;
                action[i].level=adv.action[i].@level;
                action[i].chance=adv.action[i].@chance;
                action[i].vectorI=-1;
            }
            if (adv.action[i] == "resLevelMoreThan")
            { //уровень ресурса больше, чем
                action[i].tip=adv.action[i].@tip;
                action[i].level=adv.action[i].@level;
                action[i].chance=adv.action[i].@chance;
                action[i].vectorI=-1;
            }
            if (adv.action[i] == "heroMenuActivity") //данная переменная активна
            {
                action[i].iii=adv.action[i].@iii;
            }

            if (adv.action[i]=="numOfMany") //номер элемента в списке элементов
            {
                action[i].iii = adv.action[i].@iii;
            }

            if (adv.action[i] == "tapDown") //зажат предмет
            {
                action[i].iii = adv.action[i].@iii;
            }
            if (adv.action[i]=="outOfPosition")
            {//элементы предмета сдвинуты с места
                action[i].iii=adv.action[i].@iii;
                action[i].num=adv.action[i].@num;
                action[i].tip=adv.action[i].@tip;
            }
            if (adv.action[i] == "heroPanelClose") //директивное закрытие панели героя
            {
            }

            if (adv.action[i] == "noBuilding")
            {   //ни на одной из земель нет строения
                action[i].tip = adv.action[i].@tip;
            }
            if (adv.action[i] == "haveBuilding")
            {   //хотя бы на одной из земель есть строение
                action[i].tip = adv.action[i].@tip;
            }
            if (adv.action[i] == "randi") //процент от числа, который будет считаться успешным
            {
                action[i].num = adv.action[i].@num;
            }
            if (adv.action[i] == "logged") //залогинены или нет
            {
                action[i].iii = adv.action[i].@iii;
            }
            if (adv.action[i] == "waiting") //ожидание, экран перекрыт
            {
                action[i].iii = adv.action[i].@iii;
            }
            if (adv.action[i] == "serverCode") //серверный код
            {
                action[i].iii = adv.action[i].@iii;
            }
        }
    }
    public function eff(adv):void
    {
        //trace(adv.effect[i]);
        //определяем возникающие эффекты
        for (i = 0; i < adv.effect.length(); i++)
        {
            effect.push(new Object());
            effect[i].typpe = adv.effect[i];

            if (adv.effect[i] == "activate")
            {
                //активируем тот или иной квест
                effect[i].qid = adv.effect[i].@qid;
            }
            if (adv.effect[i] == "deactivate")
            {
                //деактивируем тот или иной квест
                effect[i].qid = adv.effect[i].@qid;
            }
            if (adv.effect[i] == "load")
            {
                //грузим файлы
                effect[i].sub = adv.effect[i].@sub;
                effect[i].scen = adv.effect[i].@scen;
                effect[i].texto = adv.effect[i].@texto;
            }
            if (adv.effect[i] == "flyTo")
            {
                //переходим в комнату
                effect[i].room = adv.effect[i].@room;
            }
            if (adv.effect[i] == "flyToPlane")
            {
                //переходим на слой
                effect[i].plane = adv.effect[i].@plane;
            }
            if (adv.effect[i] == "no")
            {

            }
            if (adv.effect[i]=="makeSkip")
            { //пропускаем один из кусочков ролика
            }

            if (adv.effect[i]=="reposition")
            { //даём существующему предмету другую комнату
                effect[i].room = adv.effect[i].@room;
                effect[i].iii = adv.effect[i].@iii;
            }
            if (adv.effect[i]=="buttonRepos")
            { //даём существующей кнопки другую комнату как цель
                effect[i].pos = adv.effect[i].@pos;
                effect[i].iii = adv.effect[i].@iii;
                effect[i].tip = adv.effect[i].@tip;

            }

            if (adv.effect[i] == "positionIt")
            {
                //спозиционировать предметы
            }
            if (adv.effect[i] == "visIt")
            {
                //визуализировать предметы
            }

            if (adv.effect[i]=="visOn")
            { //сделать видимым определённый предмет
                effect[i].iii = adv.effect[i].@iii;
            }

            if (adv.effect[i]=="visOff")
            { //сделать не видимым определённый предмет
                effect[i].iii = adv.effect[i].@iii;
            }

            if (adv.effect[i]=="vis")
            { //сделать не видимым определённый предмет
                effect[i].iii = adv.effect[i].@iii;
            }

            if (adv.effect[i]=="simpleVis") //простая смена видимости
            {
                effect[i].iii = adv.effect[i].@iii;
            }

            if (adv.effect[i]=="help")
            { //просим запуска подсказки игроку
            }

            if (adv.effect[i] == "turnOut")
            {
                //заканчиваем действие перехода
            }

            if (adv.effect[i] == "darken")
            {
                effect[i].mode = adv.effect[i].@mode;
            }

            if (adv.effect[i] == "resChoose") //выбран рес
            {
                effect[i].tip = adv.effect[i].@tip;
            }

            if (adv.effect[i] == "workerChange")
            {
                //передвинут человек
            }

            if (adv.effect[i] == "buildTap")
            {
                //нажат один из элементов меню строительства
            }

            if (adv.effect[i] == "problemSituation")
            {
                //проведено строительство, надо создать препятствие build на земле
                effect[i].tip = adv.effect[i].@tip;
                effect[i].where = adv.effect[i].@where;
                effect[i].timme = adv.effect[i].@timme;
            }


            if (adv.effect[i] == "res_need")
            {
                //проверяем потребность одного глобального ресурса в другом
            }

            if (adv.effect[i] == "update")
            {
                //нажата или нет кнопка апдейт
            }
            if (adv.effect[i] == "clearUpdates")
            {
                //зачищаем все окна с инфой о апдейтах
            }

            if (adv.effect[i] == "buyUpdate")
            {
                //отплата приобретения апдейта на землю/здание в виде ресурса по его номеру в массиве
                effect[i].res = adv.effect[i].@res;
            }

            if (adv.effect[i] == "updWaitReady")
            {
                //1 - показываем доступные апдейты, 0 - купленные
                effect[i].res = adv.effect[i].@res;
            }

            if (adv.effect[i] == "resChange")
            { //меняем значение ресурса на величину
                effect[i].tip = adv.effect[i].@tip;
                effect[i].num = adv.effect[i].@num;
            }

            if (adv.effect[i] == "getCoords")
            { //взять координаты предмета
                effect[i].iii = adv.effect[i].@iii;
            }
            if (adv.effect[i] == "setCoords")
            { //выставить координаты предмету
                effect[i].iii = adv.effect[i].@iii;
                effect[i].xx = adv.effect[i].@xx;
                effect[i].yy = adv.effect[i].@yy;
            }
            if (adv.effect[i] == "setNowCoords")
            { //выставить текущие координаты предмету
                effect[i].iii = adv.effect[i].@iii;
            }
            if (adv.effect[i] == "cityClose")
            { //выставляем значение для закрытия города в менеджере
            }

            if (adv.effect[i] == "heroControl")
            { //выделяем выбранного героя для контроля
                effect[i].iii = adv.effect[i].@iii;
            }

            if (adv.effect[i] == "heroOut") //убираем у героя активность определённого типа (которая сейчас в фокусе)
            {
                effect[i].tip = adv.effect[i].@tip;
            }

            if (adv.effect[i] == "tradeOffer")
            { //изменения торговли для клиента
                effect[i].buy = adv.effect[i].@buy;
                effect[i].sell = adv.effect[i].@sell;
            }

            if (adv.effect[i] == "needFram")
            { //требуется перепроверить картинки в соответствии с кадрами
                effect[i].iii = adv.effect[i].@iii;
            }

            if (adv.effect[i] == "heroStartFinish")
            { //стартуем или выключаем экран героя
                effect[i].res = adv.effect[i].@res;
            }

            if (adv.effect[i] == "gotoFram")
            { //устанавливаем другой кадр элементу предмета
                effect[i].iii = adv.effect[i].@iii;
                effect[i].eee = adv.effect[i].@eee;
                effect[i].num = adv.effect[i].@num;
            }

            if (adv.effect[i] == "clickLike")
            { //меняем индекс нажатого родителя-элемента
                effect[i].iii = adv.effect[i].@iii;
            }

            if (adv.effect[i] == "deleteModule")
            { //удаляем модуль
                effect[i].moduleName = adv.effect[i].@txt;
                effect[i].moduleParams = adv.effect[i].@cmd;
            }

            if (adv.effect[i] == "changeLanguage")
            { //смена языка: английский
                effect[i].txt = adv.effect[i].@txt;
            }

            if (adv.effect[i] == "behChoice")
            { //переменная dan.behChoice!=0
            }

            if (adv.effect[i] == "behPosFromMess")
            { //заминусовываем переменную, отвечающую за очистку мессенджера
                effect[i].iii = adv.effect[i].@iii;
            }

            if (adv.effect[i] == "messWasTap")
            { //номер элемента в предмете МенюСообщений, который был выбран игроком
            }

            if (adv.effect[i] == "makeMessage")
            { //создаём сообщение в векторе сообщений
                effect[i].iii = adv.effect[i].@iii;
                effect[i].behMenu = adv.effect[i].@behMenu;
                effect[i].activeShow = adv.effect[i].@activeShow;
                effect[i].out = adv.effect[i].@out;
                effect[i].stil = adv.effect[i].@stil;
                //<effect iii="1" behMenu="102" activeShow="0" out="0">makeMessage</effect>
            }

            if (adv.effect[i]=="cityAllianceArmy") //смена логической переменной, отвечающей за то, показывается город или целиком альянс
            {
                effect[i].res=adv.effect[i].@res;
            }

            if (adv.effect[i]=="dxKnown") //сдвиг, на который нужно перемещать панель, когда открыт новый город
            {
                effect[i].num=adv.effect[i].@num;
            }

            if (adv.effect[i]=="relationChange") //город: влиять на отношения, улучшить
            {
                effect[i].res=adv.effect[i].@res;
            }


            if (adv.effect[i]=="fromAdditionalCityPanel") //меняет состояние отображаемой панели города при выборе в доп.панели
            {

            }


            if (adv.effect[i] == "nextTurn")
            {
                //нажата кнопка нового хода
            }

            if (adv.effect[i]=="categoryWillSave") //сменяем категорию показа истории//сменяем категорию показа истории
            {
                effect[i].num=adv.effect[i].@num;
            }

            if (adv.effect[i]=="heroHistoryChange") //меняем героя при показе истории
            {
                effect[i].iii=adv.effect[i].@iii;
            }

            if (adv.effect[i]=="serverCommand") //команда на сервер для исполнения
            {
                effect[i].com=adv.effect[i].@com;
            }
            if (adv.effect[i]=="serverCode") //код-результат выполнения серверной команды
            {

            }
            if (adv.effect[i]=="advice") //меняем код текстовки-подсказки
            {
                effect[i].iii=adv.effect[i].@iii;
            }
            if (adv.effect[i]=="messageOut") //убираем сообщение из списка
            {
                effect[i].behMenu=adv.effect[i].@behMenu;
            }
            if (adv.effect[i]=="diffLevel") //уровень сложности
            {
                effect[i].iii=adv.effect[i].@iii;
            }
            if (adv.effect[i]=="wins") //меняем состояние задания
            {
                effect[i].iii=adv.effect[i].@iii;
                effect[i].res=adv.effect[i].@res;
            }
            if (adv.effect[i]=="message") //меняем состояние текущего сообщения
            {
                effect[i].iii=adv.effect[i].@iii;
                effect[i].activeShow=adv.effect[i].@activeShow;
                effect[i].out=adv.effect[i].@out;
                effect[i].wasShowed=adv.effect[i].@wasShowed;
            }
        }
    }
}
}
