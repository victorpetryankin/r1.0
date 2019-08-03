#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ЭтотОбъект.Список,
		"ПодтвержденияПолучены",
		НСтр("ru = 'Подтверждения получены'"),
		Истина);
	
	ОписаниеТипаФизическоеЛицо = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица");
	СтруктураПараметраФизическоеЛицо = Новый Структура("ТипПараметра, ИмяПараметра", ОписаниеТипаФизическоеЛицо, "ФизическоеЛицо");
	СтруктураПараметровОтбора = Новый Структура(НСтр("ru = 'Сотрудник'"), СтруктураПараметраФизическоеЛицо);
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список", "СписокНастройкиОтбора",
		СтруктураПараметровОтбора, "СписокКритерииОтбора");
	
	ОбменСБанкамиПоЗарплатнымПроектам.КомандыОбменаДополнитьФорму(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельФормы;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ПрисоединенныйФайл" И Параметр.ЭтоНовый Тогда
		ТипыОбъектовДляОповещенияОбИзменении = ТипыОбъектовДляОповещенияОЗаписиФайла(Источник);
		Для каждого ТипОбъектаДляОповещенияОбИзменении Из ТипыОбъектовДляОповещенияОбИзменении Цикл
			ОповеститьОбИзменении(ТипОбъектаДляОповещенияОбИзменении);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_ПараметрОтбораПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ПараметрОтбораНаФормеСДинамическимСпискомПриИзменении(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	ОбменСБанкамиПоЗарплатнымПроектамКлиент.ОбновитьКомандыОбмена(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.СостоянияДокументовЗачисленияЗарплаты"));
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Параметр = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	
	ЗарплатаКадрыКлиент.ДинамическийСписокПередНачаломДобавления(ЭтотОбъект, ПараметрыОткрытия, Параметр);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ПараметрыОткрытия.ЗначенияЗаполнения);
	
	Отказ = Истина;
	ОткрытьФорму(ПараметрыОткрытия.ОписаниеФормы, ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
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

&НаКлиенте
Процедура ОтправитьВБанк(Команда)
	
	МассивДокументов = Новый Массив;
	Для каждого СсылкаНаДокумент Из Элементы.Список.ВыделенныеСтроки Цикл
		МассивДокументов.Добавить(СсылкаНаДокумент);
	КонецЦикла;
	ОбменСБанкамиКлиент.СформироватьПодписатьОтправитьЭД(МассивДокументов);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСинхронизациюСБанком(Команда)
	
	МассивДокументов = Новый Массив;
	Для каждого СсылкаНаДокумент Из Элементы.Список.ВыделенныеСтроки Цикл
		МассивДокументов.Добавить(СсылкаНаДокумент);
	КонецЦикла;
	
	ДанныеДокументов = ДанныеДокументовДляВыполненияСинхронизации(МассивДокументов);
	Для каждого ДанныеЗарплатногоПроекта Из ДанныеДокументов Цикл
		ОбменСБанкамиКлиент.СинхронизироватьСБанком(ДанныеЗарплатногоПроекта.Значение.Организация, ДанныеЗарплатногоПроекта.Значение.Банк);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтправленныйДокумент(Команда)
	
	МассивДокументов = Новый Массив;
	Для каждого СсылкаНаДокумент Из Элементы.Список.ВыделенныеСтроки Цикл
		МассивДокументов.Добавить(СсылкаНаДокумент);
	КонецЦикла;
	
	ОбменСБанкамиКлиент.ОткрытьАктуальныйЭД(МассивДокументов, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ДанныеДокументовДляВыполненияСинхронизации(МассивДокументов)
	
	ДанныеДокументов = Новый Соответствие;
	
	ЗначенияРеквизитовОбъектов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивДокументов, "Организация, ЗарплатныйПроект");
	Для каждого ЗначенияРеквизитовОбъекта Из ЗначенияРеквизитовОбъектов Цикл
		СтруктураЗначений = ЗначенияРеквизитовОбъекта.Значение;
		Если ДанныеДокументов.Получить(СтруктураЗначений.ЗарплатныйПроект) = Неопределено Тогда
			ДанныеДокументов.Вставить(СтруктураЗначений.ЗарплатныйПроект,
				Новый Структура("Организация, Банк", СтруктураЗначений.Организация, ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктураЗначений.ЗарплатныйПроект, "Банк")));
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДанныеДокументов;
	
КонецФункции

&НаСервере
Функция ТипыОбъектовДляОповещенияОЗаписиФайла(Источник)
	
	МассивТипов = Новый Массив;
	ТипОбъекта = ТипЗнч(ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ЭтотОбъект.ИмяФормы));
	МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипОбъекта);
	
	Если ТипЗнч(Источник) = Тип("Массив") Тогда
		Для каждого ПрисоединенныйФайл Из Источник Цикл
			Если МетаданныеОбъекта.РегистрируемыеДокументы.Содержит(ПрисоединенныйФайл.ВладелецФайла.Метаданные()) Тогда
				ТипДокумента = ТипЗнч(ПрисоединенныйФайл.ВладелецФайла);
				Если МассивТипов.Найти(ТипДокумента) = Неопределено Тогда
					МассивТипов.Добавить(ТипДокумента);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Если МетаданныеОбъекта.РегистрируемыеДокументы.Содержит(Источник.ВладелецФайла.Метаданные()) Тогда
			ТипДокумента = ТипЗнч(Источник.ВладелецФайла);
			Если МассивТипов.Найти(ТипДокумента) = Неопределено Тогда
				МассивТипов.Добавить(ТипДокумента);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат МассивТипов;
	
КонецФункции

#КонецОбласти
