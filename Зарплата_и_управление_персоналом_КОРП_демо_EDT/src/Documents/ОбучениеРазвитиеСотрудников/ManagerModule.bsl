#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс		
	
// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ОбучениеРазвитиеСотрудников;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

Процедура ЗаполнитьПервичныйЭтап(ПараметрыОбновления = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1000
		|	ОбучениеРазвитиеСотрудников.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ОбучениеРазвитиеСотрудников КАК ОбучениеРазвитиеСотрудников
		|ГДЕ
		|	ОбучениеРазвитиеСотрудников.ПервичныйЭтапОбучения = ЗНАЧЕНИЕ(Документ.ОбучениеРазвитиеСотрудников.ПустаяСсылка)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(ПараметрыОбновления, "Документ.ОбучениеРазвитиеСотрудников", "Ссылка", Выборка.Ссылка) Тогда
			Продолжить;
		КонецЕсли;
		
		ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ДокументОбъект.ПервичныйЭтапОбучения = Выборка.Ссылка;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект);
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
	КонецЦикла;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Выборка.Количество() = 0);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДанныеДляПроведения(Ссылка)Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОбучениеРазвитиеСотрудников.ДатаНачала КАК Период,
		|	ОбучениеРазвитиеСотрудников.ДатаОкончания КАК ДоступенДо,
		|	СправочникСотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
		|	МероприятияОбученияРазвития.ЭлектронныйКурс КАК ЭлектронныйКурс,
		|	ОбучениеРазвитиеСотрудниковСотрудники.Сотрудник КАК Сотрудник
		|ИЗ
		|	Документ.ОбучениеРазвитиеСотрудников.Сотрудники КАК ОбучениеРазвитиеСотрудниковСотрудники
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОбучениеРазвитиеСотрудников КАК ОбучениеРазвитиеСотрудников
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.МероприятияОбученияРазвития КАК МероприятияОбученияРазвития
		|			ПО ОбучениеРазвитиеСотрудников.Мероприятие = МероприятияОбученияРазвития.Ссылка
		|		ПО ОбучениеРазвитиеСотрудниковСотрудники.Ссылка = ОбучениеРазвитиеСотрудников.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК СправочникСотрудники
		|		ПО ОбучениеРазвитиеСотрудниковСотрудники.Сотрудник = СправочникСотрудники.Ссылка
		|ГДЕ
		|	ОбучениеРазвитиеСотрудников.Ссылка = &Ссылка
		|	И МероприятияОбученияРазвития.СпособПроведения = ЗНАЧЕНИЕ(Перечисление.СпособыПроведенияМероприятийОбученияРазвития.ЭлектронныйКурс)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОбучениеРазвитиеСотрудников.Подразделение КАК Подразделение,
		|	ОбучениеРазвитиеСотрудников.Мероприятие КАК Мероприятие,
		|	ОбучениеРазвитиеСотрудников.ДатаНачала КАК ДатаНачала,
		|	ОбучениеРазвитиеСотрудников.ДатаОкончания КАК ДатаОкончания,
		|	СправочникСотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ОбучениеРазвитиеСотрудников.КоличествоУчебныхЧасов КАК КоличествоУчебныхЧасов,
		|	ОбучениеРазвитиеСотрудниковСотрудники.СуммаНаСотрудника КАК СуммаРасходов,
		|	МероприятияОбученияРазвития.УчебноеЗаведение КАК УчебноеЗаведение,
		|	ВЫРАЗИТЬ(МероприятияОбученияРазвития.Преподаватель КАК Справочник.Сотрудники).ФизическоеЛицо КАК Преподаватель,
		|	ОбучениеРазвитиеСотрудников.Контрагент КАК Контрагент,
		|	ОбучениеРазвитиеСотрудников.ПервичныйЭтапОбучения КАК ПервичныйЭтапОбучения,
		|	ОбучениеРазвитиеСотрудниковСотрудники.Сотрудник КАК Сотрудник,
		|	ВЫБОР
		|		КОГДА МероприятияОбученияРазвития.ФормаЗачета = ЗНАЧЕНИЕ(Справочник.ФормыЗачетаМероприятийОбучения.ПустаяСсылка)
		|			ТОГДА NULL
		|		ИНАЧЕ ОценкиОбучения.Ссылка
		|	КОНЕЦ КАК Оценка,
		|	ВЫБОР
		|		КОГДА МероприятияОбученияРазвития.ФормаЗачета = ЗНАЧЕНИЕ(Справочник.ФормыЗачетаМероприятийОбучения.ПустаяСсылка)
		|			ТОГДА NULL
		|		ИНАЧЕ ОценкиОбучения.Балл
		|	КОНЕЦ КАК Балл,
		|	ВЫБОР
		|		КОГДА МероприятияОбученияРазвития.ФормаЗачета = ЗНАЧЕНИЕ(Справочник.ФормыЗачетаМероприятийОбучения.ПустаяСсылка)
		|			ТОГДА NULL
		|		ИНАЧЕ ОбучениеРазвитиеСотрудниковСотрудники.КомментарийКОценке
		|	КОНЕЦ КАК КомментарийКОценке
		|ИЗ
		|	Документ.ОбучениеРазвитиеСотрудников.Сотрудники КАК ОбучениеРазвитиеСотрудниковСотрудники
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОценкиОбучения КАК ОценкиОбучения
		|		ПО ОбучениеРазвитиеСотрудниковСотрудники.Оценка = ОценкиОбучения.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОбучениеРазвитиеСотрудников КАК ОбучениеРазвитиеСотрудников
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.МероприятияОбученияРазвития КАК МероприятияОбученияРазвития
		|			ПО ОбучениеРазвитиеСотрудников.Мероприятие = МероприятияОбученияРазвития.Ссылка
		|		ПО ОбучениеРазвитиеСотрудниковСотрудники.Ссылка = ОбучениеРазвитиеСотрудников.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК СправочникСотрудники
		|		ПО ОбучениеРазвитиеСотрудниковСотрудники.Сотрудник = СправочникСотрудники.Ссылка
		|ГДЕ
		|	ОбучениеРазвитиеСотрудников.Ссылка = &Ссылка
		|	И ВЫБОР
		|			КОГДА МероприятияОбученияРазвития.ФормаЗачета = ЗНАЧЕНИЕ(Справочник.ФормыЗачетаМероприятийОбучения.ПустаяСсылка)
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ВЫБОР
		|					КОГДА ОбучениеРазвитиеСотрудниковСотрудники.Оценка = ЗНАЧЕНИЕ(Справочник.ОценкиОбучения.ПустаяСсылка)
		|						ТОГДА ЛОЖЬ
		|					ИНАЧЕ ИСТИНА
		|				КОНЕЦ
		|		КОНЕЦ";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	РезультатЭлектронныхКурсов = РезультатыЗапроса[РезультатыЗапроса.Количество() - 2];
	РезультатОбучения = РезультатыЗапроса[РезультатыЗапроса.Количество() - 1];
	
	ДанныеДляПроведения = Новый Структура;
	ДанныеДляПроведения.Вставить("ЭлектронныеКурсы", РезультатЭлектронныхКурсов.Выгрузить());
	ДанныеДляПроведения.Вставить("ДвиженияОбучения", РезультатОбучения.Выгрузить());
	
	Возврат ДанныеДляПроведения;

КонецФункции	

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли