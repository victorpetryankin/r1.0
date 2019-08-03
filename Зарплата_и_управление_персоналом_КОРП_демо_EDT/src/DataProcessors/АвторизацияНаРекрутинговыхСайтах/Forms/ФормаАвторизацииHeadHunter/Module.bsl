
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Сайт = ИнтеграцияРекрутинговыхСайтовКлиентСервер.HeadHunter();
	СсылкаНаСайт = ИнтеграцияРекрутинговыхСайтов.СтрокаАвторизацииHeadHunter();
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Авторизация на %1 не доступна в веб-клиенте.'"), Сайт);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		
	КонецЕсли;
	
	АвторизацияУжеПроведена = Ложь;
	СтруктураМаркеровПолучена = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СсылкаНаСайтДокументСформирован(Элемент)
	
	Документ = Элемент.Документ;
	
	Если Документ.url = "about:blank" Тогда
		Возврат;
	КонецЕсли; 
	
	ТекстШапки = "";
	Для Каждого Шапка Из Документ.getElementsByTagName("head") Цикл
		СписокЭлементов = Шапка.getElementsByTagName("script");
		Для Каждого УзелДляУдаления Из СписокЭлементов Цикл
			УзелДляУдаления.parentNode.removeChild(УзелДляУдаления);
		КонецЦикла;
		ТекстШапки = Шапка.outerHTML;
		Прервать;
	КонецЦикла;

	Если Найти(Документ.url, "account/login") > 0 Тогда
		
		Если Найти(Документ.url, "mismatch") > 0 Тогда
			Закрыть();
			ВызватьИсключение НСтр("ru = 'Указаны неверные параметры доступа на сайт.'");
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не СтруктураМаркеровПолучена Тогда
		АвторизацияHeadHunter(Документ, Шапка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура АвторизацияHeadHunter(Документ, Шапка)
	
	Попытка
		ЗаголовокОкна	= Шапка.document.URLUnencoded;
	Исключение
		Возврат;
	КонецПопытки;
	
	// Анализируем заголовок выделяем из строки КодАвторизации.
	НомерСимвола = Найти(ЗаголовокОкна, "?code=");
	Если НомерСимвола<>0  Тогда
		КодАвторизации = Сред(ЗаголовокОкна, НомерСимвола + 6);
	Иначе
		Возврат;
	КонецЕсли;
	
	СтруктураМаркеров = СтруктураМаркеров(КодАвторизации);
	
	Закрыть(СтруктураМаркеров <> Неопределено); 
	
	СтруктураМаркеровПолучена = СтруктураМаркеров <> Неопределено;
	
КонецПроцедуры

&НаСервере
Функция СтруктураМаркеров(КодАвторизации)
	Возврат ИнтеграцияРекрутинговыхСайтов.СтруктураМаркеров(Сайт, КодАвторизации);
КонецФункции

&НаКлиенте
Процедура ПредупреждениеЗавершение(ДополнительныеПараметры) Экспорт
	ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(ДополнительныеПараметры.URL);
КонецПроцедуры

#КонецОбласти
