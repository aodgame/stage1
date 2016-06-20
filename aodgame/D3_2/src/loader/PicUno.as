package loader
{
	import D3.*;
	import collections.Stats;
	import flash.display.MovieClip;
		
	import flash.display.Loader;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	import flash.system.ApplicationDomain;

	public class PicUno
	{
		private var bit:Bitte;
		public var id:int; //идентификационный номер графического файла
		public var picName:String;
		
		private var pic:MovieClip; //картинка, которая будет возвращаться пользователю
			private var picAddr:String;
			private var ldr1:Loader = new Loader();
			private var urlReq1:URLRequest;

		private var appDomain:ApplicationDomain; //хранилище загруженного файла
						
		private var inReady1:Boolean=false; //переменная, показывающая, что загрузка всех нужных элементов завершена.
		private var problemInLoad:uint=Stats.ZERO; //переменная, показывающая, была ли загрузка завершена нормально (0) или с ошибками (1)
		
		public function PicUno(bio)
		{
			bit = Bitte.getInstance();
			//trace(bio);
			id=bio.@id; //присваиваем индекс изображения
			picName=bio;
			picAddr=bit.addr+"/subs/"+bio;
			//trace("picAddr="+picAddr);
	
			//подгружаем изображения
			if (picAddr.length>0)
			{
				urlReq1 = new URLRequest(picAddr);
				ldr1 = new Loader();
				ldr1.load(urlReq1);			
				ldr1.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded1);
				ldr1.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progress1);
				ldr1.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				ldr1.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, onError);
			} else //если загружать нечего
			{
				forced_end_load();
			}
			
			function loaded1(event:Event):void
			{
				// получаем ApplicationDomain у загруженной флешки
				appDomain = ldr1.contentLoaderInfo.applicationDomain;
				inReady1=true; //подтверждаем, что базовая обработка предмета так или иначе завершена				
			}
			function progress1(event:Event):void
			{
				bit.subLoad=ldr1.contentLoaderInfo.bytesLoaded/ldr1.contentLoaderInfo.bytesTotal*100;
			}
			function onError(event:Event):void
			{
				forced_end_load();
			}
		}
		
		private function forced_end_load() //вставляем заранее созданный элемент в случае, если не удаётся подгрузить ресурсы
		{
			pic=null;
			problemInLoad+=Stats.ONE;
			pic.visible=false;
			inReady1=true; //подтверждаем, что базовая обработка предмета так или иначе завершена
		}

		public function inReady():uint
		{
			if (inReady1)
			{
				return Stats.ONE;
			} else
			{
				return Stats.ZERO;
			}
		}
		
		public function takeYourMovie(picAddr):MovieClip
		{			
			// проверяем, загрузился ли файл без ошибок и есть ли в домене ресурс с именем picAddr
			if (problemInLoad==Stats.ZERO && appDomain.hasDefinition(picAddr))
			{
				// получаем класс нашего ресурса
				var logoClass:Class = appDomain.getDefinition(picAddr) as Class;
				pic = new logoClass();
			}
			return pic;
		}
		
		public function takeYourDomain():ApplicationDomain
		{
			return appDomain;
		}
	}	
}