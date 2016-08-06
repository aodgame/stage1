/**
 * Created by alexo on 27.06.2016.
 */
package collections.behavior
{
public class BehActivity
{
    public var iii:int;

    public var resChance:Vector.<int>;
    public var resBehRes:Vector.<int>;

    /*<behActivity iii="1"> <!-- активность, с вероятностями выпадения того или иного результата -->
        <res chance="100" behRes="1"/>
    </behActivity>*/


    public function BehActivity()
    {
        iii=0;
        resChance = new Vector.<int>();
        resBehRes = new Vector.<int>();
    }
}
}
