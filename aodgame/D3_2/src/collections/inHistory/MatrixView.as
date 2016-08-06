/**
 * Created by alexo on 05.08.2016.
 */
package collections.inHistory
{
public class MatrixView
{
    public var category:int; //информационный параметр - категория матрицы
    public var needToRefram:Boolean; //необходимо заменить

    public var tip:Vector.<int>; //тип хода, 0-тип линии, 1-lineTo, 2-moveTo
    public var first:Vector.<String>; //тип линии-цвет, 1 или 2 - x-координата
    public var second:Vector.<int>;//тип линии-0, 1 или 2 - y-координата

    public var maxy:int; //максимальное значение по вертикали и горизонтали в значениях
    public var maxx:int;


    public function MatrixView()
    {
        tip = new Vector.<int>();
        first = new Vector.<String>();
        second = new Vector.<int>();
        maxy=0;
        maxx=0;
    }
}
}
