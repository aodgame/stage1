/**
 * Created by alexo on 11.05.2016.
 */
package loader
{
import collections.Stats;
import collections.Texto;

import D3.Bitte;
import flash.net.URLRequest;

public class TextoLoader extends ParentLoader
{
    public function TextoLoader()
    {
        bit=Bitte.getInstance();
    }

    public function levelGo():void //функция загрузки графики
    {
        trace("!texto_level_go="+level_go);
        if (level_go==Stats.ZERO) //загрузка XML игры
        {
            if (bit.needToClear) //предварительно нужно убрать существующие тексты
            {
                clearAll();
            }
            level_go+=Stats.ONE; //ждём завершения загрузки конфига
            bit.wait_texto=true; //даём сигнал для прелодера

            trace("bit.textoPath="+bit.textoPath);
            if (bit.textoPath!=null && bit.textoPath.length>3)
            {
                t1 = bit.addr + bit.textoPath; //?rnd="+Math.random();
                trace("t1="+t1);
                _request = new URLRequest(t1);

                GoLoad();
            } else
            {
                level_go=Stats.THREE;
            }
        }
        if (level_go==Stats.TWO) //рзабираем переменные
        {
            GoRead();
        }
        if (level_go==Stats.THREE) //
        {
            bit.nextLevel-=Stats.ONE; //убираем пункт ожидания в загрузке
            level_go+=Stats.ONE;
            bit.wait_texto=false; //убираем загрузочную ширму для графики

            if (!bit.wait_texto) //если загрузка завершена, убираем триггер зачистки
            {
                bit.needToClear=false;
            }
        }
        if (level_go==Stats.FOUR && !bit.wait_texto) //ничего не происходит
        {
        }
        if (level_go==Stats.FOUR && bit.wait_texto) //ничего не происходит
        {
            level_go=Stats.ZERO;
        }
    }

    private function clearAll():void
    {

    }

    private function GoRead():void
    {
        trace("==texto==");
        for (i=0; i<myXML.texto.length(); i++)
        {
            bit.texto.push (new Texto());
            bit.texto[bit.texto.length-1].tid=myXML.texto[i].@tid;
            for (var j:int=0; j<myXML.texto[i].txt.length();j++)
            {
                bit.texto[bit.texto.length - 1].txt.push(new String(myXML.texto[i].txt[j]));
                bit.texto[bit.texto.length - 1].mode.push(new String(myXML.texto[i].txt[j].@mode));
                bit.texto[bit.texto.length - 1].moduleName=myXML.cid;
            }
        }
        level_go+=Stats.ONE;
    }
}
}

