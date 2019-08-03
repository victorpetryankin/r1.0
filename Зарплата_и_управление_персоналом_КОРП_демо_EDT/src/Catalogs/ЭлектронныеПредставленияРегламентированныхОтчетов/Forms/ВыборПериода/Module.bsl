&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("НачалоПериода") Тогда
		НачалоПериода = Параметры.НачалоПериода;
	КонецЕсли;
	Если Параметры.Свойство("КонецПериода") Тогда
		КонецПериода = Параметры.КонецПериода;
	КонецЕсли;
	
	Если Параметры.Свойство("Периодичность") Тогда
		ВидПериода = Параметры.Периодичность;
	Иначе
		ВидПериода = Перечисления.Периодичность.Год;
	КонецЕсли;
	
	Если Параметры.Свойство("СНачалаГода") Тогда
		НарастающимИтогомСНачалаГода = Параметры.СНачалаГода;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НачалоПериода) ИЛИ Не ЗначениеЗаполнено(КонецПериода) Тогда
		ВидПериода = Перечисления.Периодичность.Квартал;
		НачалоПериода = НачалоКвартала(ДобавитьМесяц(НачалоКвартала(ТекущаяДатаСеанса()), -1));
		КонецПериода = КонецКвартала(НачалоПериода);
	КонецЕсли;
	
	ОпределитьИнтервал();
	
	ТекДата = ТекущаяДатаСеанса();
	ЗаполнитьСпискиВыбора(ЭтаФорма, ТекДата);
	УправлениеФормой(ЭтаФорма);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВидПериодаКвартал(Команда)
	
	Интервал = 0;
	ВидПериода = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал");
	ЗаполнитьИнтервал();
	ТекДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	ЗаполнитьСпискиВыбора(ЭтаФорма, ТекДата);
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПериодаПолугодие(Команда)
	
	Интервал = 0;
	ВидПериода = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие");
	ЗаполнитьИнтервал();
	ТекДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	ЗаполнитьСпискиВыбора(ЭтаФорма, ТекДата);
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПериодаГод(Команда)
	
	Интервал = 0;
	ВидПериода = ПредопределенноеЗначение("Перечисление.Периодичность.Год");
	ЗаполнитьИнтервал();
	ТекДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	ЗаполнитьСпискиВыбора(ЭтаФорма, ТекДата);
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПериодаМесяц(Команда)
	
	Интервал = 0;
	ВидПериода = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц");
	ЗаполнитьИнтервал();
	ТекДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	ЗаполнитьСпискиВыбора(ЭтаФорма, ТекДата);
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если ВидПериода = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		НачалоПериода = НачалоГода(КонецПериода);
		КонецПериода = КонецГода(КонецПериода);
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		Если Интервал = 1 Тогда
			НачалоПериода = НачалоГода(КонецПериода);
			КонецПериода = КонецМесяца(Дата(Год(НачалоПериода), 6, 1));
		Иначе
			НачалоПериода = Дата(Год(КонецПериода), 7, 1);
			КонецПериода = КонецГода(КонецПериода);
		КонецЕсли;
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		НачалоПериода = НачалоКвартала(Дата(Год(КонецПериода), Интервал * 3, 1));
		КонецПериода = КонецКвартала(НачалоПериода);
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		НачалоПериода = НачалоМесяца(Дата(Год(КонецПериода), Интервал, 1));
		КонецПериода = КонецМесяца(НачалоПериода);
	КонецЕсли;
	
	Если НарастающимИтогомСНачалаГода Тогда
		НачалоПериода = НачалоГода(НачалоПериода);
	КонецЕсли;
 
	Закрыть(Новый Структура("НачалоПериода,КонецПериода,Периодичность", НачалоПериода, КонецПериода, ВидПериода));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИнтервал()
	
	ТекДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	
	Если Не ЗначениеЗаполнено(Интервал) Тогда
		Если ВидПериода = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
			Интервал = Месяц(ТекДата);
		ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
			Если Месяц(ТекДата) < 4 Тогда
				Интервал = 1;
			ИначеЕсли Месяц(ТекДата) > 3 И Месяц(ТекДата) < 7 Тогда
				Интервал = 2;
			ИначеЕсли Месяц(ТекДата) > 6 И Месяц(ТекДата) < 10 Тогда
				Интервал = 3;
			Иначе
				Интервал = 4;
			КонецЕсли;	
		ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
			Если Месяц(ТекДата) < 7 Тогда
				Интервал = 1;
			Иначе
				Интервал = 2;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Форма.ВидПериода = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		Элементы.ПодменюВидПериода.Заголовок = Элементы.ВидПериодаГод.Заголовок;
		УстановитьПометку(Форма, "ВидПериодаГод");
	ИначеЕсли Форма.ВидПериода = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		Элементы.ПодменюВидПериода.Заголовок = Элементы.ВидПериодаПолугодие.Заголовок;
		УстановитьПометку(Форма, "ВидПериодаПолугодие");
	ИначеЕсли Форма.ВидПериода = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		Элементы.ПодменюВидПериода.Заголовок = Элементы.ВидПериодаКвартал.Заголовок;
		УстановитьПометку(Форма, "ВидПериодаКвартал");
	ИначеЕсли Форма.ВидПериода = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		Элементы.ПодменюВидПериода.Заголовок = Элементы.ВидПериодаМесяц.Заголовок;
		УстановитьПометку(Форма, "ВидПериодаМесяц");
	КонецЕсли;
	
	Элементы.Интервал.Видимость = Форма.ВидПериода <> ПредопределенноеЗначение("Перечисление.Периодичность.Год");
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПометку(Форма, ИмяКнопки)
	
	Элементы = Форма.Элементы;
	
	СписокИменКнопок = Новый Массив;
	СписокИменКнопок.Добавить("ВидПериодаГод");
	СписокИменКнопок.Добавить("ВидПериодаПолугодие");
	СписокИменКнопок.Добавить("ВидПериодаКвартал");
	СписокИменКнопок.Добавить("ВидПериодаМесяц");
	
	// Снять пометки
	Для Каждого ТекущееИмяКнопки Из СписокИменКнопок Цикл
		Элементы[ТекущееИмяКнопки].Пометка = Ложь;	
	КонецЦикла;
	
	Элементы[ИмяКнопки].Пометка = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСпискиВыбора(Форма, ТекущаяДатаНаСервере)
	
	ЗаполнитьСписокВыбораГод(Форма, ТекущаяДатаНаСервере);
	ЗаполнитьСписокВыбораИнтервал(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораГод(Форма, ТекущаяДатаНаСервере)
	
	Форма.Элементы.Год.СписокВыбора.Очистить();
	
	ТекущийГод = КонецГода(ТекущаяДатаНаСервере);
	
	Индекс = 0;
	Пока Индекс < 4 Цикл
		Значение = ДобавитьМесяц(ТекущийГод, - Индекс * 12);
		Форма.Элементы.Год.СписокВыбора.Вставить(0, Значение, Формат(Год(Значение), "ЧГ="));
		Индекс = Индекс + 1;	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораИнтервал(Форма)
	
	Элементы = Форма.Элементы;
	СписокВыбора = Элементы.Интервал.СписокВыбора;
	СписокВыбора.Очистить();
	Если Форма.ВидПериода = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		СписокВыбора.Добавить(1, НСтр("ru = '1 полугодие'"));
		СписокВыбора.Добавить(2, НСтр("ru = '2 полугодие'"));
	ИначеЕсли Форма.ВидПериода = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		СписокВыбора.Добавить(1, НСтр("ru = '1 квартал'"));
		СписокВыбора.Добавить(2, НСтр("ru = '2 квартал'"));
		СписокВыбора.Добавить(3, НСтр("ru = '3 квартал'"));
		СписокВыбора.Добавить(4, НСтр("ru = '4 квартал'"));
	ИначеЕсли Форма.ВидПериода = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		СписокВыбора.Добавить(1, НСтр("ru = 'Январь'"));
		СписокВыбора.Добавить(2, НСтр("ru = 'Февраль'"));
		СписокВыбора.Добавить(3, НСтр("ru = 'Март'"));
		СписокВыбора.Добавить(4, НСтр("ru = 'Апрель'"));
		СписокВыбора.Добавить(5, НСтр("ru = 'Май'"));
		СписокВыбора.Добавить(6, НСтр("ru = 'Июнь'"));
		СписокВыбора.Добавить(7, НСтр("ru = 'Июль'"));
		СписокВыбора.Добавить(8, НСтр("ru = 'Август'"));
		СписокВыбора.Добавить(9, НСтр("ru = 'Сентябрь'"));
		СписокВыбора.Добавить(10, НСтр("ru = 'Октябрь'"));
		СписокВыбора.Добавить(11, НСтр("ru = 'Ноябрь'"));
		СписокВыбора.Добавить(12, НСтр("ru = 'Декабрь'"));
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ОпределитьИнтервал()
	
	Если ВидПериода = Перечисления.Периодичность.Полугодие Тогда
		Если Месяц(КонецПериода) < 7 Тогда
			Интервал = 1;
		Иначе
			Интервал = 2;
		КонецЕсли;
	ИначеЕсли ВидПериода = Перечисления.Периодичность.Квартал Тогда
		Если Месяц(КонецПериода) < 4 Тогда
			Интервал = 1;
		ИначеЕсли Месяц(КонецПериода) > 3 И Месяц(КонецПериода) < 7 Тогда
			Интервал = 2;
		ИначеЕсли Месяц(КонецПериода) > 6 И Месяц(КонецПериода) < 10 Тогда
			Интервал = 3;
		Иначе
			Интервал = 4;
		КонецЕсли;
	ИначеЕсли ВидПериода = Перечисления.Периодичность.Месяц Тогда
		Интервал = Месяц(КонецПериода);
	Иначе
		Интервал = 1;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

