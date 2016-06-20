/**
 * Created by alexo on 15-May-15.
 */
package D3
{
import collections.common.Timmer;
import loader.ScenLoader;
import story.*;
import story.managers.CheafManager;

public class Scenario
{
    private static var instance:Scenario;		//Это будет уникальный экземпляр, созданный классом
    private static var ok2Create:Boolean=false;

    private var bit:Bitte;
    private var sub:Subjects;
    private var levering:ScenLoader;

    private var quest:Vector.<Quest> = new Vector.<Quest>(); //хранилище блоков заданий
    private var movie:Movie; //действия с триггерами

    private var i:uint; //порядковая переменная для счёта

    private var saver:Saver;
    private var cheafManager:CheafManager;
    private var timmer:Timmer;

    public function Scenario(stage)
    {
        if(!ok2Create) throw new Error(this+" is a Singleton. access using getInstance()");

        bit = Bitte.getInstance();
        sub=Subjects.getInstance(stage);

        levering = new ScenLoader();
        movie = new Movie(stage);
        saver = new Saver();
        cheafManager = new CheafManager();
        timmer = new Timmer();
    }

    public static function getInstance(stage):Scenario
    {
        //Если нет экземпляра, создаем его
        if(!instance)
        {
            //Разрешить создание экземпляра, а после его создания запретить
            ok2Create = true;
            instance = new Scenario(stage);
            ok2Create = false;
            trace('An example of "Scenario" created!');
        }
        return instance;
    }

    public function workControl ():void
    {
        if (bit.nextLevel > 0) //готовим фильм
        {
            levering.levelGo(quest, timmer);
            cheafManager.unwork(sub.sub);
        }
        if (bit.nextLevel == 0) //снимаем фильм
        {
            movie.work(quest);
            cheafManager.work(sub.sub);
            saver.work(sub);
            upDate();
        }
    }

    private function upDate() //обновляем значения информационных параметров
    {
        if (bit.sMovieChangeTurn)
        {
            bit.sMovieChangeTurn=false;
        }

        if (bit.sTimmer!=timmer.show())
        {
            bit.sTimmer=timmer.show();
            trace("bit.sTimmer="+bit.sTimmer);
        }

        if (bit.sChangeTurn)
        {
            bit.sMovieChangeTurn=true;
            bit.sChangeTurn=false;
            bit.sCurrentTurn++;
            bit.sTimmer=timmer.changeDate();
        }
    }
}
}
