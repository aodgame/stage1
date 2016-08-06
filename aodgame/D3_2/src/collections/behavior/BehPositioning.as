/**
 * Created by alexo on 27.06.2016.
 */
package collections.behavior
{
public class BehPositioning
{
    public var iii:int; //id позиционирующего элемента

    public var weAre:int; //номер комнаты
    public var where:String; //тип объекта над которым находился герой
    public var warning:String;

    public var empty:String;

    public var resTyppe:String;
    public var resIII:int;

    /*<behPositioning iii="1" weAre="3">
     <!-- Позиционирование героя: пложение на картах weAre - 3,
     где - на земле,
     тип события на земле - восстание граждан.
     В качестве результата - вызов меню
     -->
     <where num="land"/>
     <warning res="rebelionCitizen"/>
     <empty i="no"/>
     <res typpe="menu" iii="1"/>
     </behPositioning>*/

    public function BehPositioning()
    {
        iii=0;
        weAre=0;
        where="";
        warning="";
        resTyppe="";
        empty="";
        resIII=0;
    }
}
}
