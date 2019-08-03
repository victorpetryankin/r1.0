
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОписаниеТипаПодразделения = Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия");
	СтруктураПараметраПодразделения = Новый Структура("ТипПараметра, ИмяПараметра", ОписаниеТипаПодразделения, "МассивДокументов");
	СтруктураПараметровОтбора = Новый Структура("Подразделение", СтруктураПараметраПодразделения);
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список", "СписокНастройкиОтбора",
		СтруктураПараметровОтбора, "СписокКритерииОтбора");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельФормы;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПланПоказателейЭффективностиПодразделения"
		ИЛИ ИмяСобытия = "Запись_ПланПоказателейЭффективностиПозиции"
		ИЛИ ИмяСобытия = "Запись_ПланПоказателейЭффективностиСотрудника"
		ИЛИ ИмяСобытия = "Запись_ПланПоказателяЭффективностиПодразделений"
		ИЛИ ИмяСобытия = "Запись_ПланПоказателяЭффективностиПозиций" Тогда
	
		ОбновитьФормыСДинамическимСпискомНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура Подключаемый_ПараметрОтбораПриИзменении(Элемент)
	ПараметрКритерияОтбораНаФормеСДинамическимСпискомПриИзмененииНаСервере(Элемент.Имя);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПараметрКритерияОтбораНаФормеСДинамическимСпискомПриИзмененииНаСервере(ИмяЭлемента)
	КлючевыеПоказателиЭффективностиФормы.ПараметрКритерияОтбораНаФормеСДинамическимСпискомПриИзменении(ЭтаФорма, ИмяЭлемента, "План");
КонецПроцедуры

&НаСервере
Процедура ОбновитьФормыСДинамическимСпискомНаСервере()
	КлючевыеПоказателиЭффективностиФормы.ОбновитьФормыСДинамическимСписком(ЭтаФорма, "План");
КонецПроцедуры

#КонецОбласти