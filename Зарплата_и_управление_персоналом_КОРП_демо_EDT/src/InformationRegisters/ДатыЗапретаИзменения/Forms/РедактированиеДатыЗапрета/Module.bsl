
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПользовательПредставление = Параметры.ПользовательПредставление;
	РазделПредставление       = Параметры.РазделПредставление;
	Объект                    = Параметры.Объект;
	ОписаниеДатыЗапрета       = Параметры.ОписаниеДатыЗапрета;
	КоличествоДнейРазрешения  = Параметры.КоличествоДнейРазрешения;
	ДатаЗапрета               = Параметры.ДатаЗапрета;
	
	РазрешитьИзменениеДанныхДоДатыЗапрета = КоличествоДнейРазрешения > 0;
	
	Если Не ЗначениеЗаполнено(РазделПредставление)
	   И Не ЗначениеЗаполнено(Объект) Тогда
	   
		Элементы.РазделПредставление.Видимость = Ложь;
		Элементы.ОбъектПредставление.Видимость = Ложь;
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "БезРазделаИОбъекта");
		
	ИначеЕсли Не ЗначениеЗаполнено(РазделПредставление) Тогда
		Элементы.РазделПредставление.Видимость = Ложь;
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "БезРаздела");
	
	ИначеЕсли Не ЗначениеЗаполнено(Объект) Тогда
		Элементы.ОбъектПредставление.Видимость = Ложь;
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "БезОбъекта");
		
	ИначеЕсли ЗначениеЗаполнено(Объект) Тогда
		Если ТипЗнч(Объект) = Тип("Строка") Тогда
			Элементы.ОбъектПредставление.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			Элементы.ОбъектПредставление.Гиперссылка = Ложь;
		Иначе
			ПредставлениеОбъекта = Объект.Метаданные().ПредставлениеОбъекта;
			Если ПустаяСтрока(ПредставлениеОбъекта) Тогда
				ПредставлениеОбъекта = Объект.Метаданные().Представление();
			КонецЕсли;
			Элементы.ОбъектПредставление.Заголовок = ПредставлениеОбъекта;
		КонецЕсли;
	КонецЕсли;
	
	Если ОписаниеДатыЗапрета = "" Тогда // не установлен
		ОписаниеДатыЗапрета = "ПроизвольнаяДата";
	КонецЕсли;
	
	// Кэширование текущей даты на сервере.
	НачалоДня = ТекущаяДатаСеанса();
	ДатыЗапретаИзмененияСлужебныйКлиентСервер.УточнитьНастройкуДатыЗапретаПриИзменении(ЭтотОбъект);
	ДатыЗапретаИзмененияСлужебныйКлиентСервер.ОбновитьОтображениеДатыЗапретаПриИзменении(ЭтотОбъект);
	
	Если ОписаниеДатыЗапрета = "ПроизвольнаяДата" Тогда
		ТекущийЭлемент = Элементы.ДатаЗапретаПростойРежим;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОповеститьОВыборе(ВозвращаемоеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

////////////////////////////////////////////////////////////////////////////////
// Одинаковые обработчики событий форм ДатыЗапретаИзменения и РедактированиеДатыЗапрета.

&НаКлиенте
Процедура ОписаниеДатыЗапретаПриИзменении(Элемент)
	
	ДатыЗапретаИзмененияСлужебныйКлиентСервер.УточнитьНастройкуДатыЗапретаПриИзменении(ЭтотОбъект);
	ПодключитьОбработчикОжидания("ОбновитьОтображениеДатыЗапретаПриИзмененииОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеДатыЗапретаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОписаниеДатыЗапрета = Элементы.ОписаниеДатыЗапрета.СписокВыбора[0].Значение;
	ДатыЗапретаИзмененияСлужебныйКлиентСервер.УточнитьНастройкуДатыЗапретаПриИзменении(ЭтотОбъект);
	ПодключитьОбработчикОжидания("ОбновитьОтображениеДатыЗапретаПриИзмененииОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаЗапретаПриИзменении(Элемент)
	
	ДатыЗапретаИзмененияСлужебныйКлиентСервер.УточнитьНастройкуДатыЗапретаПриИзменении(ЭтотОбъект);
	ПодключитьОбработчикОжидания("ОбновитьОтображениеДатыЗапретаПриИзмененииОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьИзменениеДанныхДоДатыЗапретаПриИзменении(Элемент)
	
	ДатыЗапретаИзмененияСлужебныйКлиентСервер.УточнитьНастройкуДатыЗапретаПриИзменении(ЭтотОбъект);
	ПодключитьОбработчикОжидания("ОбновитьОтображениеДатыЗапретаПриИзмененииОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоДнейРазрешенияПриИзменении(Элемент)
	
	ДатыЗапретаИзмененияСлужебныйКлиентСервер.УточнитьНастройкуДатыЗапретаПриИзменении(ЭтотОбъект);
	ПодключитьОбработчикОжидания("ОбновитьОтображениеДатыЗапретаПриИзмененииОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоДнейРазрешенияАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоДнейРазрешения = Текст;
	ДатыЗапретаИзмененияСлужебныйКлиентСервер.УточнитьНастройкуДатыЗапретаПриИзменении(ЭтотОбъект);
	ПодключитьОбработчикОжидания("ОбновитьОтображениеДатыЗапретаПриИзмененииОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура БольшеВозможностейНажатие(Элемент)
	
	ВыбранРасширенныйРежим = Истина;
	Элементы.РасширенныйРежим.Видимость = Истина;
	Элементы.ГруппаРежимыРаботы.ТекущаяСтраница = Элементы.РасширенныйРежим;
	
КонецПроцедуры

&НаКлиенте
Процедура МеньшеВозможностейНажатие(Элемент)
	
	ВыбранРасширенныйРежим = Ложь;
	Элементы.РасширенныйРежим.Видимость = Ложь;
	Элементы.ГруппаРежимыРаботы.ТекущаяСтраница = Элементы.ПростойРежим;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ОписаниеДатыЗапрета", ОписаниеДатыЗапрета);
	
	Если ОписаниеДатыЗапрета = "" Тогда
		ВозвращаемоеЗначение.Вставить("КоличествоДнейРазрешения", 0);
		ВозвращаемоеЗначение.Вставить("ДатаЗапрета",              '00010101');
	Иначе
		ВозвращаемоеЗначение.Вставить("КоличествоДнейРазрешения", КоличествоДнейРазрешения);
		ВозвращаемоеЗначение.Вставить("ДатаЗапрета",              ДатаЗапрета);
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьОтображениеДатыЗапретаПриИзмененииОбработчикОжидания()
	
	ДатыЗапретаИзмененияСлужебныйКлиентСервер.ОбновитьОтображениеДатыЗапретаПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
