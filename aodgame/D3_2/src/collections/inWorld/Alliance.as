/**
 * Created by alexo on 01.08.2016.
 */
package collections.inWorld
{
public class Alliance
{
    public var iii:int;
    public var members:Vector.<int>; //участники альянса
    public var leader:int; //лидер альянса
    public var warWith:Vector.<int>; //с кем из городов альянс воюет

    public function Alliance()
    {
        iii=-1;
        members = new Vector.<int>();
        leader=-1;
        warWith = new Vector.<int>();
    }
}
}
