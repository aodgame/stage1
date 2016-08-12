/**
 * Created by alexo on 27.06.2016.
 */
package collections.behavior
{
public class BehMenu
{
    public var iii:int;
    public var txt:String;

    public var choicerBehActivity:Vector.<int>;
    public var choicerTxt:Vector.<String>;

    public var fram:Vector.<int>;
    public var framNum:Vector.<int>;

    /*<behMenu iii="1" txt="">
        <!-- пункты меню, которые может выбрать игрок,
        с указанием на последующую активность,
        а также с текстовкой, которую надо отобрюазить по каждому пункту.
         В самом behMebu общая текстовка на меню для пояснения окошка игроку-->
        <choicer behActivity="1" txt="">
     <fram fr="1" num="0"/>
     <fram fr="2" num="4"/>
     <fram fr="1" num="0"/>
     </choicer>
        <choicer behActivity="2" txt="">
     <fram fr="1" num="0"/>
     <fram fr="2" num="4"/>
     <fram fr="1" num="0"/>
     </choicer>
        <choicer behActivity="3" txt="">
     <fram fr="1" num="0"/>
     <fram fr="2" num="4"/>
     <fram fr="1" num="0"/>
     </choicer>
    </behMenu>*/

    public function BehMenu()
    {
        iii=0;
        txt="";
        choicerBehActivity = new Vector.<int>();
        choicerTxt = new Vector.<String>();
        fram = new Vector.<int>();
        framNum = new Vector.<int>();
    }
}
}
