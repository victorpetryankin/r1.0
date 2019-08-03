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
	
	МетаданныеДокумента = Метаданные.Документы.ПланОбученияРазвития;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДанныеДляПроведения(Ссылка)Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПланОбученияРазвития.Подразделение КАК Подразделение,
		|	ПланОбученияРазвитияМероприятия.Мероприятие КАК Мероприятие,
		|	ПланОбученияРазвитияМероприятия.ДатаНачала КАК ДатаНачала,
		|	ПланОбученияРазвитияМероприятия.ДатаОкончания КАК ДатаОкончания,
		|	ПланОбученияРазвитияМероприятия.КоличествоУчебныхЧасов КАК КоличествоУчебныхЧасов,
		|	ПланОбученияРазвитияМероприятия.КоличествоСотрудников КАК КоличествоСотрудников,
		|	ПланОбученияРазвитияМероприятия.СуммаРасходов КАК СуммаРасходов,
		|	ПланОбученияРазвития.ДатаНачалаПланирования КАК ДатаНачалаПланирования,
		|	ПланОбученияРазвития.ДатаОкончанияПланирования КАК ДатаОкончанияПланирования,
		|	ПланОбученияРазвитияМероприятия.Заявка КАК Заявка,
		|	ПланОбученияРазвитияМероприятия.Подразделение КАК ЦелевоеПодразделение
		|ИЗ
		|	Документ.ПланОбученияРазвития.Мероприятия КАК ПланОбученияРазвитияМероприятия
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПланОбученияРазвития КАК ПланОбученияРазвития
		|		ПО ПланОбученияРазвитияМероприятия.Ссылка = ПланОбученияРазвития.Ссылка
		|ГДЕ
		|	ПланОбученияРазвитияМероприятия.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПланОбученияРазвития.Подразделение КАК Подразделение,
		|	ПланОбученияРазвитияМероприятия.Мероприятие КАК Мероприятие,
		|	ПланОбученияРазвитияМероприятия.ДатаНачала КАК ДатаНачала,
		|	ПланОбученияРазвитияМероприятия.ДатаОкончания КАК ДатаОкончания,
		|	ПланОбученияРазвитияСотрудники.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ПланОбученияРазвитияМероприятия.КоличествоУчебныхЧасов КАК КоличествоУчебныхЧасов,
		|	ПланОбученияРазвитияСотрудники.СуммаНаСотрудника КАК СуммаРасходов,
		|	ПланОбученияРазвитияСотрудники.Сотрудник КАК Сотрудник,
		|	ПланОбученияРазвитияМероприятия.Подразделение КАК ЦелевоеПодразделение
		|ИЗ
		|	Документ.ПланОбученияРазвития.Мероприятия КАК ПланОбученияРазвитияМероприятия
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПланОбученияРазвития КАК ПланОбученияРазвития
		|		ПО ПланОбученияРазвитияМероприятия.Ссылка = ПланОбученияРазвития.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПланОбученияРазвития.Сотрудники КАК ПланОбученияРазвитияСотрудники
		|		ПО ПланОбученияРазвитияМероприятия.НомерСтрокиМероприятия = ПланОбученияРазвитияСотрудники.НомерСтрокиМероприятия
		|ГДЕ
		|	ПланОбученияРазвитияМероприятия.Ссылка = &Ссылка
		|	И ПланОбученияРазвитияСотрудники.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ПлановыеДвиженияМероприятий = РезультатЗапроса[РезультатЗапроса.Количество()-2].Выгрузить();
	ПлановыеДвиженияСотрудников = РезультатЗапроса[РезультатЗапроса.Количество()-1].Выгрузить();
	
	ДанныеДляПроведения = Новый Структура;
	ДанныеДляПроведения.Вставить("ПлановыеДвиженияМероприятий", ПлановыеДвиженияМероприятий);
	ДанныеДляПроведения.Вставить("ПлановыеДвиженияСотрудников", ПлановыеДвиженияСотрудников);
	
	Возврат ДанныеДляПроведения;

КонецФункции	

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// План обучения
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Документ.ПланОбученияРазвития";
	КомандаПечати.Идентификатор = "ПланОбучения";
	КомандаПечати.Представление = НСтр("ru = 'План обучения'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь; 
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПланОбучения");
	Если НужноПечататьМакет Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ПланОбучения",
			НСтр("ru = 'План обучения'"),
			ПечатьПланаОбучения(МассивОбъектов, ОбъектыПечати),
			,
			"Документ.ПланОбученияРазвития.ПФ_MXL_ПланОбучения");
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьПланаОбучения(МассивОбъектов, ОбъектыПечати)
	
	// Создаем табличный документ и устанавливаем имя параметров печати.
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ПланОбучения";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПланОбученияРазвития.ПФ_MXL_ПланОбучения");
	ОбластьМакетаШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакетаМероприятие = Макет.ПолучитьОбласть("Мероприятие");
	ОбластьМакетаСотрудники = Макет.ПолучитьОбласть("Сотрудники"); 
	ОбластьМакетаПодвал = Макет.ПолучитьОбласть("Подвал"); 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		  "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		  |	ПланОбученияРазвитияМероприятия.Ссылка КАК ПланСсылка,
		  |	ПланОбученияРазвитияМероприятия.НомерСтрокиМероприятия КАК НомерСтрокиМероприятия,
		  |	ПланОбученияРазвитияМероприятия.Мероприятие КАК Мероприятие,
		  |	ПланОбученияРазвитияМероприятия.КоличествоСотрудников КАК КоличествоСотрудников,
		  |	ПланОбученияРазвитияМероприятия.КоличествоУчебныхЧасов КАК КоличествоУчебныхЧасов,
		  |	ПланОбученияРазвитияМероприятия.СуммаРасходов КАК СуммаРасходов,
		  |	ПланОбученияРазвитияМероприятия.ДатаНачала КАК ДатаНачала,
		  |	ПланОбученияРазвитияМероприятия.ДатаОкончания КАК ДатаОкончания,
		  |	ПланОбученияРазвития.Дата,
		  |	ПланОбученияРазвития.ДатаНачалаПланирования,
		  |	ПланОбученияРазвития.ДатаОкончанияПланирования,
		  |	ПланОбученияРазвития.Утвердил,
		  |	ПланОбученияРазвитияСотрудники.Сотрудник,
		  |	ПланОбученияРазвитияМероприятия.НомерСтроки КАК НомерСтроки
		  |ИЗ
		  |	Документ.ПланОбученияРазвития.Мероприятия КАК ПланОбученияРазвитияМероприятия
		  |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПланОбученияРазвития КАК ПланОбученияРазвития
		  |		ПО ПланОбученияРазвитияМероприятия.Ссылка = ПланОбученияРазвития.Ссылка
		  |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПланОбученияРазвития.Сотрудники КАК ПланОбученияРазвитияСотрудники
		  |		ПО ПланОбученияРазвитияМероприятия.Ссылка = ПланОбученияРазвитияСотрудники.Ссылка
		  |			И ПланОбученияРазвитияМероприятия.НомерСтрокиМероприятия = ПланОбученияРазвитияСотрудники.НомерСтрокиМероприятия
		  |ГДЕ
		  |	ПланОбученияРазвитияМероприятия.Ссылка В(&МассивОбъектов)
		  |
		  |УПОРЯДОЧИТЬ ПО
		  |	ПланСсылка,
		  |	НомерСтроки,
		  |	НомерСтрокиМероприятия";
		
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("ПланСсылка") Цикл
		// Вывод шапки документа.
		ЗаполнитьЗначенияСвойств(ОбластьМакетаШапка.Параметры, Выборка);
		ОбластьМакетаШапка.Параметры.ДатаНачалаПланирования = Формат(Выборка.ДатаНачалаПланирования,"ДЛФ=D");
		ОбластьМакетаШапка.Параметры.ДатаОкончанияПланирования = Формат(Выборка.ДатаОкончанияПланирования,"ДЛФ=D");
		ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
		// Вывод мероприятий.
		НомерСтроки = 1;
		Пока Выборка.СледующийПоЗначениюПоля("НомерСтрокиМероприятия") Цикл
			ЗаполнитьЗначенияСвойств(ОбластьМакетаМероприятие.Параметры, Выборка);
			ОбластьМакетаМероприятие.Параметры.НомерСтроки = НомерСтроки;
			ТабличныйДокумент.Вывести(ОбластьМакетаМероприятие);
			// Выборка по сотрудникам.
			Пока Выборка.Следующий() Цикл
				Если ЗначениеЗаполнено(Выборка.Сотрудник) Тогда
					ЗаполнитьЗначенияСвойств(ОбластьМакетаСотрудники.Параметры, Выборка);
					ТабличныйДокумент.Вывести(ОбластьМакетаСотрудники);
				КонецЕсли;
			КонецЦикла;
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;	
		ЗаполнитьЗначенияСвойств(ОбластьМакетаПодвал.Параметры, РеквизитыУтвердившего(Выборка.Утвердил, Выборка.Дата));
		ТабличныйДокумент.Вывести(ОбластьМакетаПодвал);
	КонецЦикла;

	Возврат ТабличныйДокумент;
	
КонецФункции

Функция РеквизитыУтвердившего(ПользовательУтвердил, ДатаДокумента)

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Пользователи.ФизическоеЛицо КАК Ссылка,
		|	&ДатаДокумента КАК Дата
		|ПОМЕСТИТЬ ВТФизическоеЛицо
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.Ссылка = &ПользовательУтвердил";
		
	Запрос.УстановитьПараметр("ПользовательУтвердил",ПользовательУтвердил);
	Запрос.УстановитьПараметр("ДатаДокумента",ДатаДокумента);
	Запрос.Выполнить();
	
	ИменаПолейОтветственныхЛиц = Новый Массив;
	ИменаПолейОтветственныхЛиц.Добавить("Ссылка");

	ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Ложь, ИменаПолейОтветственныхЛиц, "ВТФизическоеЛицо");
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ЕСТЬNULL(Сотрудники.Ссылка, ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка)) КАК Сотрудник,
	|	ВТФИООтветственныхЛиц.РасшифровкаПодписи
	|ПОМЕСТИТЬ ВТСотрудник
	|ИЗ
	|	ВТФизическоеЛицо КАК ВТФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИООтветственныхЛиц
	|		ПО ВТФизическоеЛицо.Ссылка = ВТФИООтветственныхЛиц.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
	|		ПО ВТФизическоеЛицо.Ссылка = Сотрудники.ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	КадроваяИсторияСотрудниковСрезПоследних.Должность КАК ДолжностьРуководителя,
	|	ВТСотрудник.РасшифровкаПодписи КАК РуководительРасшифровкаПодписи
	|ИЗ
	|	ВТСотрудник КАК ВТСотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних(
	|				&НаДату,
	|				Сотрудник В
	|					(ВЫБРАТЬ
	|						ВТСотрудник.Сотрудник
	|					ИЗ
	|						ВТСотрудник КАК ВТСотрудник)) КАК КадроваяИсторияСотрудниковСрезПоследних
	|		ПО ВТСотрудник.Сотрудник = КадроваяИсторияСотрудниковСрезПоследних.Сотрудник";
	
	Запрос.УстановитьПараметр("НаДату",ДатаДокумента);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	РезультатСтруктура = Новый Структура("ДолжностьРуководителя, РуководительРасшифровкаПодписи");
	Если РезультатЗапроса.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(РезультатСтруктура, РезультатЗапроса[0]);
	КонецЕсли;
	
	Возврат РезультатСтруктура;

КонецФункции
 
#КонецОбласти

#КонецОбласти

#КонецЕсли