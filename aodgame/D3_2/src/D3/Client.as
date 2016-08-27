/**
 * Created by alexo on 16.08.2016.
 */
package D3
{
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

public class Client
{
    private var bit:Bitte;

    private var exmpl:Array;

    private var externalXML:XML; //для возвращаемого значения от сервера

    public function Client()
    {
        bit = Bitte.getInstance();
        exmpl = ["\"", "\'", "\\", "/", " "];

    }

    public function workControl():void
    {
        if (bit.serverCommand!="")
        {
            var out:Boolean=false;

            if (!control(bit.userLogin) || !control(bit.userPass))
            {
                bit.serverCommand="";
                bit.serverCode=7;
                return;
            }
            clientAsk();
            bit.serverCommand="";
        }
    }

    private function clientAsk():void
    {
        var info:String =
                "clientCommand=" + bit.serverCommand +
                "&first=" + bit.userLogin +
                "&second=" + bit.userPass +
                "&third=" + bit.userName +
                "&fourth=" + bit.userEmail +
                "&fifth=" + bit.textMode;
        trace("bit.serverCommand="+bit.serverCommand);
        switch (bit.serverCommand)
        {
            case "regNew":
                trace("regNew");
                break;
            case "comeIn":
                trace("comeIn");
                break;
            case "logOff":
            {
                bit.logged=false;
                bit.userName="";
                bit.userEmail="";
                bit.userLogin="";
                bit.userPass="//";
                bit.serverCommand="";
                return;
                break;
            }
            case "correct":
                trace("comeIn");
                break;
            default:
                trace("unknown command");
                return;
                break;
        }

        var URL_vars:URLVariables = new URLVariables(info);
        URL_vars.dataFormat = URLLoaderDataFormat.TEXT;

        trace("client-server sending");
        bit.waiting=true;
        sendAndLoadData(bit.serverAddr, URL_vars);
    }

    public function sendAndLoadData(_url:String, _variables:URLVariables = null):URLLoader
    {
        try
        {
            var url:URLRequest = new URLRequest(_url);
            url.method = URLRequestMethod.POST;
            //trace("look at it:");
            //trace(_url + (_variables != null ? "?" + _variables.toString() : ""));
            //trace("...");
            var loa:URLLoader = new URLLoader();
            loa.dataFormat = URLLoaderDataFormat.TEXT;
            if (_variables)
            {
                url.data = _variables;
            }

            loa.addEventListener(Event.COMPLETE, loaderCompleteHandler);
            loa.addEventListener(ProgressEvent.PROGRESS, hnProgress);
            loa.addEventListener(SecurityErrorEvent.SECURITY_ERROR, hnSecurityError);
            loa.addEventListener(IOErrorEvent.IO_ERROR, hnIoError);
        } catch(error:Error)
        {
            trace("not excelent");
        }
        try
        {
            loa.load(url);
        } catch (error:Error)
        {
            trace("not excelent2");
        }
        return loa;
    }

    private function loaderCompleteHandler(event:Event):void
    {
        trace("loaderCompleteHandler");
        try
        {
            trace("start");
            trace(event.target.data);
            var s:String=event.target.data;
            var num:int=0;
            while (s.length>0)
            {
                if (s.substr(0,5)=="<?xml")
                {
                    break;
                }
                s=s.substr(1, s.length-1);

            }
            while (s.substr(num,6)!="<br />")
            {
                num++;
            }
            s=s.substr(0, num);
            trace("end");
            trace(s);
            trace("---");
            externalXML = new XML(s);

            trace("xml="+externalXML);

            bit.serverCode=externalXML.code;
            if (bit.serverCode==0 || bit.serverCode==5) //команда успешности
            {
                bit.logged=true;
                bit.userName=externalXML.nm;
                bit.userEmail=externalXML.em;
                bit.textMode=externalXML.lg;
            }
            trace("userName="+externalXML.nm);
            trace("userEmail="+externalXML.em);
            trace("textMode="+externalXML.lg);
            trace("serverCode="+bit.serverCode);
        } catch (e:TypeError)
        {
            trace("Could not parse the XML file.");
            bit.serverCode=3;
        }
    }
    private function hnSecurityError(event:Event):void
    {
        bit.serverCode=4;
    }
    private function hnIoError(event:Event):void
    {
        bit.serverCode=4;
    }
    private function hnProgress(event:Event):void
    {
    }

    private function control(param:String):Boolean  //контроль запрещённых символов
    {
        var res:Boolean=true;

        for (var i:int=0; i<param.length; i++)
        {
            for (var j:int=0; j<exmpl.length; j++)
            {
                if (exmpl[j]==param.substr(i, 1))
                {
                    trace("Unreasonable symbol");
                    res=false;
                    break;
                }
            }
            if (!res)
            {
                break;
            }
        }
        return res;
    }
}
}
