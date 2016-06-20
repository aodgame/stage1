/**
 * Created by alexo on 18.05.2016.
 */
package collections.common
{
public class Modification
{
    public var iii:int=-1; //порядковый номер исследования
    public var name:String="";
    public var description:String="";
    public var isOpened:int=-1; //изучен или нет (-1 - недоступен к изучению)
    public var needToOpen:Vector.<int> = new Vector.<int>(); //порядковые номера исследований, необходимых для текущего
    public var tip:Vector.<String> = new Vector.<String>(); //типы эффектов
    public var iid:Vector.<int> = new Vector.<int>(); //вспомогательный набор элементов, необходимых для задания ээфекта модификации
    public var res:Vector.<String> = new Vector.<String>();
    public var num:Vector.<int> = new Vector.<int>();
    public var cost:int=0;
    public var costRes:String="";

    public var upResName:Vector.<String> = new Vector.<String>(); //стоимость апдейта при покупке на здании
    public var upResNum:Vector.<int> = new Vector.<int>();

    // <typpe tip="openBuilding" id="9"/>
    // <typpe tip="increaseResource" id="5" res="craft" num="2" />

    public function Modification()
    {
    }

    public function analyzeOfOpen(updates):void //проверяем статус улучшения
    {
        //trace(updates.length+"; analyzeOfOpen="+isOpened)
        if (isOpened<1)
        {
            var i:int = 0;
            var j:int = 0;
            var res:int=1;

            for (j = 0; j < needToOpen.length; j++)
            {
                if (res==0)
                {
                    break;
                }
                for (i = 0; i < updates.length; i++)
                {
                    if (updates[i].iii==needToOpen[j])
                    {
                        if (updates[i].isOpened==1)
                        {
                            res=1;
                        } else
                        {
                            res=0;
                        }
                        break;
                    }
                }
            }
            //trace("res="+res);
            if (res==0)
            {
                isOpened=-1;
            } else
            {
                isOpened=0;
            }
        }
    }

}
}
