package loader
{
import elements.*;
import subjects.*;

public class SubjPlant
{
    public function SubjPlant()
    {

    }
    public function makeS(i, myXML, sub, el, pics):void
    {
        if (myXML.type == "preloader" )
        {
            sub.push(new SubPreloader(myXML, pics, el, i));
        }
        if (myXML.type == "camera" )
        {
            sub.push(new SubCamera(myXML, pics, el, i));
        }
        if (myXML.type == "background" )
        {
            sub.push(new SubBackground(myXML, pics, el, i));
        }
        if (myXML.type == "activeBackground" )
        {
            sub.push(new SubBackActive(myXML, pics, el, i));
        }
        if (myXML.type == "button" )
        {
            sub.push(new SubButton(myXML, pics, el, i));
        }
        if (myXML.type == "viewGround" ) //ролик
        {
            sub.push(new SubViewGround(myXML, pics, el, i));
        }
        if (myXML.type == "land" )
        {
            sub.push(new SubLand(myXML, pics, el, i));
        }
        if (myXML.type == "mover" )
        {
            sub.push(new SubMovement(myXML, pics, el, i));
        }
        if (myXML.type == "buildingMenu" )
        {
            sub.push(new SubBuldingMenu(myXML, pics, el, i));
        }
        if (myXML.type == "resFiller" )
        {
            sub.push(new SubResFiller(myXML, pics, el, i));
        }
        if (myXML.type == "texter" )
        {
            sub.push(new SubTextoActive(myXML, pics, el, i));
        }
    }

    public function makeE(sub, el, pics):void
    {
        if (sub.subs.length>0)
        {
            //trace("sub.subs.length="+ sub.subs.length);
            for (var i:int = 0; i < sub.subs.length; i++)
            {
                i/*f (sub.typpe=="land")
                {
                    trace("Land:"+sub.iii);
                    trace("sub.picAddr[i]="+sub.picAddr[i])
                    trace("sub.picIndex="+sub.picIndex);
                }*/
                el.push(elem(sub.subs[i], pics[sub.picIndex], sub.picAddr[i], sub.iii)); //создаём элемент
                sub.idOfEl.push(el[el.length - 1].iii); //уточняем для предмета индекс элемента
                sub.numOfEl.push(el.length - 1); //уточняем для предмета положение элемента в векторе
                sub.realW.push(el[el.length - 1].pic.width);
                sub.realH.push(el[el.length - 1].pic.height);

                el[el.length - 1].atChild = sub.atChild; //слой видимости элемента
                if (sub.specID.length>i)
                {
                    el[el.length - 1].specInfo = sub.specID[i]; //передаём элементу его тип
                    //trace("el[el.length - 1].specInfo=" + el[el.length - 1].specInfo);
                }

                if (sub.subs[i]=="pic")
                {
                    el[el.length - 1].sizes(sub.sw[i], sub.sh[i]);
                }
                if (sub.subs[i]=="mc")
                {
                    el[el.length - 1].sizes(sub.sw[i], sub.sh[i]);
                    if (sub.specID[i]=="unselect")
                    {
                        //trace("unselect");
                        el[el.length - 1].tid=sub.specID[i];
                        el[el.length - 1].parse();
                    }
                }

                if (sub.subs[i]=="txt")
                {
                    //trace("i="+i);
                    el[el.length - 1].tid=sub.specID[i];
                    el[el.length - 1].parse();
                    //trace("sub.specID[i]="+sub.specID[i]);
                }

            }
        }
    }

    public function elem(inf, picContainer, picAddr, subIII):ParentElement
    {
        if (inf=="mclow")
        {
            return (new ElemMCLow(picContainer, picAddr, subIII, "mclow"));
        }
        if (inf=="mc")
        {
            return (new ElemMC(picContainer, picAddr, subIII, "mc"));
        }
        if (inf=="pic")
        {
            return (new ElemPic(picContainer, picAddr, subIII, "pic"));
        }
        if (inf=="txt")
        {
            return (new ElemTxt(picContainer, picAddr, subIII, "txt"));
        }
        return null;
    }
    //mc - мувик с несколкьими картинками
    //pic - мувик с картинкой
}
}
