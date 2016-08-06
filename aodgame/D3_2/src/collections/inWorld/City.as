/**
 * Created by alexo on 02.06.2016.
 */
package collections.inWorld
{
public class City
{

    public var iii:int;
    public var name:String;
    public var sub:int;
    public var elem:int;

    public var peacewarIII:Vector.<int> = new Vector.<int>(); //с каким из городов по ИД
    public var peacewarRelations:Vector.<int> = new Vector.<int>(); //уровень отношений
    public var peacewar:Vector.<int> = new Vector.<int>(); //мир или война

    public var status:Vector.<int> = new Vector.<int>(); //статус текущего города по отношению к городу из peacewarIII

    public var character:int; //тип характера персонажа, 0-дружелюбный, 1-спокойный, 2-коварный, 3-вспыльчивый,  4-агрессивный
    public var characterTxt:int; //номер текстовки в списке текстов

    public var government:int; //тип правильтельства, 0 - царство, 1 - тирания, 2 - олигополия, 3 - республика
    public var governmentTxt:int; //номер текстовки в списке текстов

    public var army:int; //армия и флот городов
    public var modifArmy:int; //модификаторы успешности использования
    public var fleet:int;
    public var modifFleet:int;

    public var alliance:int;//альянс, в который входит игрок по его iii, -1 - не входит ни в один
    public var leader:Boolean; //лидер союза или нет

    public function City()
    {
        iii=-1;
        name="";
        sub=-1;
        elem=-1;
        character=-1;
        characterTxt=-1;
        government=-1;
        governmentTxt=-1;
        army=0;
        fleet=0;
        modifArmy=1;
        modifFleet=1;
        alliance=-1;
        leader=false;
    }
}
}
