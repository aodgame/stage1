/**
 * Created by alexo on 22-May-15.
 */
package loader
{
    import D3.*;

    import collections.Stats;

    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

public class ParentLoader
{
//объявление переменнных участвующих в загрузке списка игровых предметов
    protected var _request:URLRequest;
    protected var urlLoader:URLLoader = new URLLoader();
    protected var myXML:XML;

    protected var level_go:uint=Stats.ZERO; //переменная для контроля последовательности загрузки

    protected var t1:String; //адрес, по которому будет проводиться загрузка xml

    protected var i:uint; //порядковая переменная для счёта

    protected var plant:SubjPlant = new SubjPlant();

    protected var bit:Bitte;

    public function ParentLoader()
    {
        bit = Bitte.getInstance();
    }

    //загружаем xml с информацией о предметах и запускаем таймер
    protected function GoLoad()
    {
        urlLoader = new URLLoader();
        myXML = new XML();

        urlLoader.addEventListener (Event.COMPLETE,fileLoaded);
        urlLoader.addEventListener(ProgressEvent.PROGRESS, fileProgress);
        urlLoader.load (_request);
        myXML.ignoreWhitespace = true;

        function fileLoaded (e:Event):void
        {
            myXML = XML(e.target.data);
            level_go+=Stats.ONE; //запускаем следующий этап после загрузки конфига
            urlLoader.removeEventListener (Event.COMPLETE,fileLoaded);
            urlLoader.removeEventListener (Event.COMPLETE,fileProgress);
        }
        function fileProgress (event:Event):void
        {
            bit.subLoad=urlLoader.bytesLoaded/urlLoader.bytesTotal*100;
        }
    }
}
}
