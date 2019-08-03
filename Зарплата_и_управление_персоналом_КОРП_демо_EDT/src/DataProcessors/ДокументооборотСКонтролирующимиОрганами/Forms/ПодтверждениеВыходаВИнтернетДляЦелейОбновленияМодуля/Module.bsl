&НаКлиенте
Перем КонтекстЭДО;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МакетHTMLДокумента = Обработки.ДокументооборотСКонтролирующимиОрганами.ПолучитьМакет("ПодтверждениеВыходаВИнтернетДляЦелейОбновленияМодуля");
	ТекстHTMLДокумента = МакетHTMLДокумента.ПолучитьТекст();
	РеквизитHTMLДокументаСообщение = ТекстHTMLДокумента;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КнопкаРазрешитьНажатие(Элемент)
	
	СохранитьНастройкиВХранилище("ДокументооборотСКонтролирующимиОрганами_РазрешитьОнлайнОбновление", Истина);
	
	ПрерватьПопыткиСоединения = Ложь;
	ПроверитьДоступВИнтернет(ПрерватьПопыткиСоединения);
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаЗапретитьНажатие(Элемент)
	
	СохранитьНастройкиВХранилище("ДокументооборотСКонтролирующимиОрганами_РазрешитьОнлайнОбновление", Ложь);
	
	Закрыть(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаНапомнитьПозжеНажатие(Элемент)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СохранитьНастройкиВХранилище(ИмяНастройки, ЗначениеНастройки)
	
	ХранилищеОбщихНастроек.Сохранить(ИмяНастройки, , ЗначениеНастройки);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьДоступВИнтернет(ПрерватьПопыткиСоединения)
	
	Если ПрерватьПопыткиСоединения Тогда
		
		Закрыть();
		
	ИначеЕсли ДоступВИнтернетОткрыт() Тогда
		
		Закрыть(Истина);
		
	Иначе
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"КнопкаРазрешитьНажатиеПослеОтображенияОшибки", 
			ЭтотОбъект);
			
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ПоказатьДиалогОшибкиДоступаВИнтернет("Ошибка доступа к серверу обновлений модуля документооборота с контролирующими органами.", ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаРазрешитьНажатиеПослеОтображенияОшибки(ПовторитьПопыткуСоединения, ДополнительныеПараметры) Экспорт
	
	ПроверитьДоступВИнтернет(НЕ ПовторитьПопыткуСоединения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДО = Результат.КонтекстЭДО;
	
КонецПроцедуры

&НаСервере
Функция ДоступВИнтернетОткрыт()
	
	// Инициализируем КонтексЭДО для...
	КонтекстЭДО = Обработки.ДокументооборотСКонтролирующимиОрганами.Создать();
	ПараметрыСервераИнтернета = КонтекстЭДО.ПолучитьПараметрыИнтернета();
	
	URLСервера 					= ПараметрыСервераИнтернета.URLСервера;
	КаталогФайловНаСервере 		= ПараметрыСервераИнтернета.КаталогФайловНаСервере;
	ИмяКлючевогоФайлаНаСервере 	= ПараметрыСервераИнтернета.ИмяКлючевогоФайлаНаСервере;
	
	ОписаниеОшибки = "";
	Соединение = ДокументооборотСКО.УстановитьСоединениеССерверомИнтернета(ПараметрыСервераИнтернета.URLСервера, ОписаниеОшибки);
	Если Соединение = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КлючевойФайл = ПолучитьИмяВременногоФайла();
	Попытка
		Соединение.Получить(КаталогФайловНаСервере + 
			ИмяКлючевогоФайлаНаСервере, 
			КлючевойФайл);
		УдалитьФайлы(КлючевойФайл);
		Возврат Истина;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

#КонецОбласти