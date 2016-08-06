/**
 * Created by alexo on 29.07.2016.
 */
package collections.common
{
public class Equiler
{
    //выбирается только один флаг, который должен определять какой тип переменной с какой должен сопоставляться
    public var intint:Boolean; //первая часть - что на входе
    public var strstr:Boolean;
    public var intstr:Boolean;
    public var strint:Boolean;

    public var fint:int;
    public var sint:int;

    public function Equiler()
    {
        intint=false;
        strstr=false;
        intstr=false;
        strint=false;

        fint=-1;
        sint=-1;
    }
}
}
