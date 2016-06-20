package loader
{
import collections.Room;
import collections.Stats;
import collections.Texto;

import flash.net.URLRequest;

public class SubjLoader extends ParentLoader
{
    public function SubjLoader()
    {
    }

    public function levelGo(sub, el, pics, adder) //функция загрузки графики
    {
        trace("!sub_level_go="+level_go);
        if (level_go==Stats.ZERO) //загрузка XML игры
        {
            if (bit.needToClear) //предварительно нужно убрать существующие предметы
            {
                clearAll(sub, el, pics);
            }
            level_go+=Stats.ONE; //ждём завершения загрузки конфига
            bit.wait_subjects=true; //даём сигнал для прелодера

            t1=bit.addr+bit.subPath; //?rnd="+Math.random();
            //trace(t1);
            _request = new URLRequest(t1);

            GoLoad();
        }
        if (level_go==Stats.TWO) //загрузка графики
        {
            GoLoadImages(pics);
            level_go+=Stats.ONE;
        }
        if (level_go==Stats.THREE) //ожидание окончания загрузки графики
        {
            //ждём окончания загрузки
            WaitUntilLoadImages(pics);
        }
        if (level_go==Stats.FOUR) //процесс создания всех элементов
        {
            GoCreateParams();
            GoCreateSubjects(sub, el, pics);
            level_go+=Stats.ONE;
        }
        if (level_go==Stats.FIVE) //процесс ожидания настройки всех элементов
        {
            WaitUntilCreatSubs(sub, el);
        }
        if (level_go==Stats.SIX) //чистим хвосты для выхода
        {
            bit.nextLevel-=Stats.ONE; //убираем пункт ожидания в загрузке
            level_go+=Stats.ONE;
            bit.wait_subjects=false; //убираем загрузочную ширму для графики

            adder.push(-1);

            if (!bit.wait_scenario) //если загрузка завершена, убираем триггер зачистки
            {
                bit.needToClear=false;
            }
        }
        if (level_go==Stats.SEVEN && !bit.wait_subjects) //ничего не происходит
        {
        }
        if (level_go==Stats.SEVEN && bit.wait_subjects) //ничего не происходит
        {
            level_go=Stats.ZERO;
        }
    }

    //
    private function clearAll(sub, el, pics)
    {

    }

    //создаём массив с загружающимися изображениями
    private function GoLoadImages(pics)
    {
        //trace(myXML);
        var j:uint=pics.length; //текущая длина массива с картинками
        var k:uint=pics.length+myXML.picload.length(); //количество загружаемых графических файлов
        //здесь всё ок
        for (i=0; i<myXML.picload.length(); i++)
        {
            pics.push (new PicUno(myXML.picload[i]));
        }
    }
    //проверяем, загрузились ли все изображения
    private function WaitUntilLoadImages(pics)
    {
        var pic_ready:uint=0;
        for (i=0; i<pics.length; i++)
        {
            pic_ready+=pics[i].inReady();
        }
        if (pic_ready==pics.length)
        {
            level_go+=Stats.ONE;
        }
    }

    private function GoCreateParams()
    {
        //trace("remorce");
        for (i=0; i<myXML.room.length(); i++)
        {
            //trace("i="+i);
            bit.room.push (new Room());
            bit.room[i].iii=myXML.room[i];
            bit.room[i].xx=myXML.room[i].@xx;
            bit.room[i].yy=myXML.room[i].@yy;
        }
        for (i=0; i<bit.room.length; i++)
        {
            //trace("iii="+bit.room[i].iii+": xx="+bit.room[i].xx);
        }



    }

    //создаём предметы, явно указанные по игре
    private function GoCreateSubjects(sub, el, pics)
    {
        var c:int;
        c=sub.length;
        for (i=0; i<myXML.subject.length(); i++) //создаём предметы
        {
            plant.makeS(i, myXML.subject[i], sub, el, pics);
        }
        for (i=c; i<sub.length; i++) //создаём элементы графики под предметы
        {
            plant.makeE(sub[i], el, pics);
        }
    }
    private function WaitUntilCreatSubs(sub, el)
    {
        var pic_ready:uint=0;
        for (i=0; i<sub.length; i++)
        {
            pic_ready+=sub[i].ready;
        }
        if (pic_ready==sub.length)
        {
            pic_ready=0;
            for (i=0; i<el.length; i++)
            {
                pic_ready+=el[i].ready;
            }
            if (pic_ready==el.length)
            {
                level_go += Stats.ONE;
            }
        }
    }
}
}