package loader
{
import elements.*;
import subjects.*;

public class SubjPlant
{
    public function SubjPlant()
    {

    }
    public function makeS(i, myXML, sub, el, pics, moduleName:String):void
    {
        if (myXML.type == "preloader" )
        {
            sub.push(new SubPreloader(myXML, pics, el, i, moduleName));
        }
        if (myXML.type == "camera" )
        {
            sub.push(new SubCamera(myXML, pics, el, i, moduleName));
        }
        if (myXML.type == "background" )
        {
            sub.push(new SubBackground(myXML, pics, el, i, moduleName));
        }
        if (myXML.type == "activeBackground" )
        {
            sub.push(new SubBackActive(myXML, pics, el, i, moduleName));
        }
        if (myXML.type == "button" )
        {
            sub.push(new SubButton(myXML, pics, el, i, moduleName));
        }
        if (myXML.type == "viewGround" ) //ролик
        {
            sub.push(new SubViewGround(myXML, pics, el, i, moduleName));
        }
        if (myXML.type == "land" )
        {
            sub.push(new SubLand(myXML, pics, el, i, moduleName));
        }
        if (myXML.type == "mover" )
        {
            sub.push(new SubMovement(myXML, pics, el, i, moduleName));
        }
        if (myXML.type == "buildingMenu" )
        {
            sub.push(new SubElementsMenu(myXML, pics, el, i, moduleName));
        }
        if (myXML.type == "resFiller" )
        {
            sub.push(new SubResFiller(myXML, pics, el, i, moduleName));
        }
        if (myXML.type == "texter" )
        {
            sub.push(new SubTextoActive(myXML, pics, el, i, moduleName));
        }
        if (myXML.type == "graph" )
        {
            sub.push(new SubGraph(myXML, pics, el, i, moduleName));
        }
    }

    public function makeE(sub, el, pics):void
    {
        if (sub.subs.length>0)
        {
            //trace("sub.subs.length="+ sub.subs.length);
            for (var i:int = 0; i < sub.subs.length; i++)
            {
                el.push(elem(sub.subs[i], pics[sub.picIndex], sub.picAddr[i], sub.iii, sub.moduleName, i)); //создаём элемент
                sub.idOfEl.push(el[el.length - 1].iii); //уточняем для предмета индекс элемента
                sub.numOfEl.push(el.length - 1); //уточняем для предмета положение элемента в векторе
                sub.realW.push(el[el.length - 1].pic.width);
                sub.realH.push(el[el.length - 1].pic.height);

                el[el.length - 1].atChild = sub.atChild; //слой видимости элемента
                if (sub.specID.length>i)
                {
                    el[el.length - 1].specInfo = sub.specID[i]; //передаём элементу его тип
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
                        el[el.length - 1].tid=sub.specID[i];
                        el[el.length - 1].parse();
                    }
                }
                if (sub.subs[i]=="txt")
                {
                    el[el.length - 1].tid=sub.specID[i];
                    el[el.length - 1].parse();
                }

            }
        }
    }

    public function elem(inf, picContainer, picAddr, subIII, moduleName, i):ParentElement
    {
        if (inf=="mclow")
        {
            return (new ElemMCLow(picContainer, picAddr, subIII, "mclow", moduleName, i));
        }
        if (inf=="mc")
        {
            return (new ElemMC(picContainer, picAddr, subIII, "mc", moduleName, i));
        }
        if (inf=="pic")
        {
            return (new ElemPic(picContainer, picAddr, subIII, "pic", moduleName, i));
        }
        if (inf=="txt")
        {
            return (new ElemTxt(picContainer, picAddr, subIII, "txt", moduleName, i));
        }
        if (inf=="sha")
        {
            return (new ElemShape(picContainer, picAddr, subIII, "sha", moduleName, i));
        }
        return null;
    }
    //mc - мувик с несколкьими картинками
    //pic - мувик с картинкой
}
}
