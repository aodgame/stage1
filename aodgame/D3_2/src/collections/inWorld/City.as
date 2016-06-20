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

    public function City()
    {
        iii=-1;
        name="";
        sub=-1;
        elem=-1;
    }
}
}
