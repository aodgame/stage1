/**
 * Created by alexo on 02.06.2016.
 */
package story.managers
{
import D3.Bitte;
import story.Danke;

public class CheafManager
{
    private var landsManager:LandsManager;
    private var resManager:ResManager;
    private var buildingManager:BuildingManager;
    private var updManager:UpdatesManager;
    private var heroManager:HeroManager;
    private var cityManager:CityManager;
    private var activityManager:ActivityManager;

    private var messanger:Messanger;

    private var infoStory:InfoStoryManager;

    private var dan:Danke;
    private var bit:Bitte;

    public function CheafManager()
    {
        landsManager = new LandsManager();
        resManager = new ResManager();
        buildingManager = new BuildingManager();
        updManager = new UpdatesManager();
        heroManager = new HeroManager();
        cityManager = new CityManager();
        activityManager = new ActivityManager();
        messanger = new Messanger();
        infoStory = new InfoStoryManager();

        dan = Danke.getInstance();
        bit=Bitte.getInstance();
    }

    public function work(sub):void
    {
        buildingManager.work(sub);
        landsManager.work();
        resManager.work();
        updManager.work();
        cityManager.work(sub);
        activityManager.work(sub);
        heroManager.work(sub);
        messanger.work(sub);

        infoStory.work(sub);

        dan.outI=-1;
        bit.underOne=-1;
    }

    public function unwork(sub):void
    {
        resManager.laggy(2);
    }
}
}
