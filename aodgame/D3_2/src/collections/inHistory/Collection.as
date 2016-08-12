/**
 * Created by alexo on 04.08.2016.
 */
package collections.inHistory
{
import collections.common.Hero;

public class Collection
{
    public var num:Vector.<int>; //списк значений
    public var iii:int; //порядковый номер сохраняемой записи
    public var res:String; //текстовая кодировка ресурса
    public var max:int; //максимальное значение
    public var category:int; //категория, позволяет сводить параметры в danke в группу

    public var heroStory:Vector.<Hero>; //для хранения действий героев. needTyppe - потрачено, heroResTyppe - заработано

    public function Collection()
    {
        num = new Vector.<int>();
        iii=-1;
        res="";
        max=-1;
        category=0;
        heroStory = new Vector.<Hero>();
    }
}
}
