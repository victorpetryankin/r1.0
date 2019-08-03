&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРеквизита 			= Параметры.ИмяРеквизита;
	НаименованиеРеквизита 	= Параметры.НаименованиеРеквизита; 
	ЗначениеРеквизита		= Параметры.ЗначениеРеквизита;
	ОписаниеТипаРеквизита 	= Параметры.ОписаниеТипаРеквизита;
	МаскаРеквизита 			= Параметры.МаскаРеквизита;
	Элементы.ЗначениеРеквизита.ОграничениеТипа = ОписаниеТипаРеквизита;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭтаФорма.Заголовок = НаименованиеРеквизита;
	Если МаскаРеквизита <> Неопределено Тогда
		Элементы.ЗначениеРеквизита.Маска = МаскаРеквизита;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КнопкаОК(Команда)
	
	ВведеноВерноеЗначение = Истина;
	
	// проверки введенных значений
	Если ИмяРеквизита = "КодРосстата" Тогда
		// Росстат
		Если СтрДлина(СокрЛП(ЗначениеРеквизита))<> 5 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Код органа Росстата должен состоять из 4 цифр'"), ,"ЗначениеРеквизита");
			ВведеноВерноеЗначение = Ложь;
		КонецЕсли;
		
	ИначеЕсли ИмяРеквизита = "КодПФР" Тогда
		// Код ПФР
		Если СтрДлина(СокрЛП(ЗначениеРеквизита))<> 7 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Код отделения ПФР должен состоять из 6 цифр'"), ,"КодПФР");
			ВведеноВерноеЗначение = Ложь;
		КонецЕсли;

	КонецЕсли;
	
	Если ВведеноВерноеЗначение Тогда
		Закрыть(ЗначениеРеквизита);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаОтмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти
