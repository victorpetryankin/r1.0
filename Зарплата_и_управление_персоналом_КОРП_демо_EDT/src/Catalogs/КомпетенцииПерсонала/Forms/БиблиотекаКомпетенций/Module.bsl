
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗакрыватьПриВыборе = Ложь;
	ЗаполнитьТаблицуКомпетенций();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКомпетенции

&НаКлиенте
Процедура КомпетенцииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработатьВыборВСпискеКомпетенций(СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ОбработатьВыборВСпискеКомпетенций();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуКомпетенций()
	
	БиблиотекаXML = Справочники.КомпетенцииПерсонала.ПолучитьМакет("Библиотека").ПолучитьТекст();
	
	БиблиотекаТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(БиблиотекаXML).Данные;
	
	Для Каждого ТекущаяСтрока Из БиблиотекаТаблица Цикл
		НоваяСтрока = ХарактеристикиКомпетенций.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
	КонецЦикла;
	
	БиблиотекаТаблица.Свернуть("Наименование, ОписаниеКомпетенции");
	Для Каждого ТекущаяСтрока Из БиблиотекаТаблица Цикл
		НоваяСтрока = Компетенции.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьВыбранныеСтроки(Знач ВыбранныеСтроки, ТекущаяСсылка)
	
	БиблиотекаХарактеристикXML = ПланыВидовХарактеристик.ХарактеристикиПерсонала.ПолучитьМакет("Библиотека").ПолучитьТекст();
	БиблиотекаХарактеристикТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(БиблиотекаХарактеристикXML).Данные;
	
	Для каждого НомерСтроки Из ВыбранныеСтроки Цикл
		ТекущиеДанные = Компетенции[НомерСтроки];
		
		СтрокаВБазе = Справочники.КомпетенцииПерсонала.НайтиПоНаименованию(ТекущиеДанные.Наименование, Истина);
		Если ЗначениеЗаполнено(СтрокаВБазе) Тогда
			Если НомерСтроки = Элементы.Компетенции.ТекущаяСтрока Или ТекущаяСсылка = Неопределено Тогда
				ТекущаяСсылка = СтрокаВБазе;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Справочники.КомпетенцииПерсонала.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные);
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Наименование", ТекущиеДанные.Наименование);
		СтрокиЗначений = ХарактеристикиКомпетенций.НайтиСтроки(СтруктураПоиска);
		Для Каждого ТекущаяСтрока Из СтрокиЗначений Цикл
			Если Не ЗначениеЗаполнено(ТекущаяСтрока.Характеристика) Тогда
				Продолжить;
			КонецЕсли;
			СтруктураХарактеристики = ХарактеристикиПерсонала.ХарактеристикаИзМакета(ТекущаяСтрока.Характеристика, ТекущаяСтрока.Значение, БиблиотекаХарактеристикТаблица);
			Если СтруктураХарактеристики = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			НоваяСтрокаТЧ = НоваяСтрока.ХарактеристикиПерсонала.Добавить();
			НоваяСтрокаТЧ.Характеристика = СтруктураХарактеристики.Характеристика;
			НоваяСтрокаТЧ.Значение = СтруктураХарактеристики.Значение;
			НоваяСтрокаТЧ.Вес = ТекущаяСтрока.Вес;
			НоваяСтрокаТЧ.ВесЗначения = ТекущаяСтрока.ВесЗначения;
			НоваяСтрокаТЧ.ТребуетсяОбучение = ТекущаяСтрока.ТребуетсяОбучение;
			НоваяСтрокаТЧ.ТребуетсяПроверка = ТекущаяСтрока.ТребуетсяПроверка;
		КонецЦикла;
		НоваяСтрока.Записать();
		
		Если НомерСтроки = Элементы.Компетенции.ТекущаяСтрока Или ТекущаяСсылка = Неопределено Тогда
			ТекущаяСсылка = НоваяСтрока.Ссылка;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборВСпискеКомпетенций(СтандартнаяОбработка = Неопределено)
	
	СтандартнаяОбработка = Ложь;
	
	НовыхХарактеристик = 0;
	ПроверитьНеобходимостьСозданияНовых(Элементы.Компетенции.ВыделенныеСтроки, НовыхХарактеристик); 
	Если НовыхХарактеристик > 0 Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'При создании компетенций из библиотеки также будут созданы новые характеристики персонала.
			|Количество новых элементов: %1
			|Продолжить?'"), Строка(НовыхХарактеристик));
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьВыборВСпискеКомпетенцийЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;

	ТекущаяСсылка = Неопределено;
	СохранитьВыбранныеСтроки(Элементы.Компетенции.ВыделенныеСтроки, ТекущаяСсылка);
	ПоказатьОповещениеПользователя(НСтр("ru = 'Добавлены компетенции'"));
	ОповеститьОВыборе(ТекущаяСсылка);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборВСпискеКомпетенцийЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСсылка = Неопределено;
	СохранитьВыбранныеСтроки(Элементы.Компетенции.ВыделенныеСтроки, ТекущаяСсылка);
	ПоказатьОповещениеПользователя(НСтр("ru = 'Добавлены компетенции'"));
	ОповеститьОВыборе(ТекущаяСсылка);
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНеобходимостьСозданияНовых(Знач ВыбранныеСтроки, НовыхХарактеристик)
	
	МассивХарактеристик = Новый Массив;
	Для каждого НомерСтроки Из ВыбранныеСтроки Цикл
		ТекущиеДанные = Компетенции[НомерСтроки];
		
		СтрокаВБазе = Справочники.КомпетенцииПерсонала.НайтиПоНаименованию(ТекущиеДанные.Наименование, Истина);
		Если ЗначениеЗаполнено(СтрокаВБазе) Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Наименование", ТекущиеДанные.Наименование);
		СтрокиЗначений = ХарактеристикиКомпетенций.НайтиСтроки(СтруктураПоиска);
		Для Каждого ТекущаяСтрока Из СтрокиЗначений Цикл
			Если (Не ЗначениеЗаполнено(ТекущаяСтрока.Характеристика)) Или (МассивХарактеристик.Найти(ТекущаяСтрока.Характеристика) <> Неопределено) Тогда
				Продолжить;
			КонецЕсли;
			ЭлектронноеИнтервью.ПроверитьНовуюХарактеристику(ТекущаяСтрока.Характеристика, МассивХарактеристик);
		КонецЦикла;		
	КонецЦикла;
	
	НовыхХарактеристик = МассивХарактеристик.Количество();
	
КонецПроцедуры

#КонецОбласти