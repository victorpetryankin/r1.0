#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ВключениеВКадровыйРезерв;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

Функция ПолучитьДанныеДляПроведения(Ссылка)Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВключениеВКадровыйРезерв.ДатаРассмотрения КАК Период,
		|	ВключениеВКадровыйРезервСотрудники.ПозицияРезерва КАК ПозицияРезерва,
		|	ВключениеВКадровыйРезерв.ВидРезерва КАК ВидРезерва,
		|	ВключениеВКадровыйРезервСотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ВключениеВКадровыйРезервСотрудники.ДатаОкончания КАК ДатаОкончания,
		|	ВЫБОР
		|		КОГДА ВключениеВКадровыйРезервСотрудники.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСКадровымиРезервистами.Утвердить)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияСогласования.Согласовано)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СостоянияСогласования.ПустаяСсылка)
		|	КОНЕЦ КАК Статус
		|ИЗ
		|	Документ.ВключениеВКадровыйРезерв.Сотрудники КАК ВключениеВКадровыйРезервСотрудники
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВключениеВКадровыйРезерв КАК ВключениеВКадровыйРезерв
		|		ПО ВключениеВКадровыйРезервСотрудники.Ссылка = ВключениеВКадровыйРезерв.Ссылка
		|ГДЕ
		|	ВключениеВКадровыйРезерв.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	ДвиженияИсторииКадровогоРезерва = РезультатЗапроса.Выгрузить();
	
	ДанныеДляПроведения = Новый Структура;
	ДанныеДляПроведения.Вставить("ДвиженияИсторииКадровогоРезерва", ДвиженияИсторииКадровогоРезерва);
	
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