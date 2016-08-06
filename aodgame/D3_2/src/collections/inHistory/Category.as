/**
 * Created by alexo on 05.08.2016.
 */
package collections.inHistory
{
public class Category
{
    public var iii:int; //порядковый номер категории
    public var out:String; //тип вывода
    public var col:Vector.<String>; //набор цветов для разных коллекций

    public function Category()
    {
        iii=-1;
        out="";
        col = new Vector.<String>();
    }
}
}
