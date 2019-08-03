#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Подтверждение списка на открытие лицевых счетов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ПодтверждениеСпискаНаОткрытиеЛицевыхСчетов";
	КомандаПечати.Представление = НСтр("ru = 'Подтверждение списка на открытие лицевых счетов'");
	
КонецПроцедуры

// Формирует печатные формы
//
// Параметры:
//  (входные)
//    МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//    ПараметрыПечати - Структура - дополнительные настройки печати;
//  (выходные)
//   КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы.
//   ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                             представление - имя области в которой был выведен объект;
//   ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПодтверждениеСпискаНаОткрытиеЛицевыхСчетов") Тогда
		ТабличныйДокумент = ПечатьПодтвержденияСпискаНаОткрытиеЛицевыхСчетовПоДокументам(МассивОбъектов, ОбъектыПечати);
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПодтверждениеСпискаНаОткрытиеЛицевыхСчетов"
			, НСтр("ru = 'Подтверждение списка на открытие лицевых счетов'"), ТабличныйДокумент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ПодтверждениеОткрытияЛицевыхСчетовСотрудников;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

Функция ПечатьПодтвержденияСпискаНаОткрытиеЛицевыхСчетовПоДокументам(МассивОбъектов, ОбъектыПечати) Экспорт
	
	// получаем данные для печати
	ДанныеДляПечати = ДанныеПодтвержденияОткрытияЛицевыхСчетов(МассивОбъектов);
	
	ТабличныйДокумент = ПечатьПодтвержденияСпискаНаОткрытиеЛицевыхСчетов(МассивОбъектов, ОбъектыПечати, ДанныеДляПечати);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатьПодтвержденияСпискаНаОткрытиеЛицевыхСчетовПоXML(МассивОбъектов, ОбъектыПечати) Экспорт
	
	// получаем данные для печати
	ДанныеДляПечати = ОбменСБанкамиПоЗарплатнымПроектам.ДанныеПодтвержденияОткрытияЛицевыхСчетовПоXML(МассивОбъектов);
	
	ТабличныйДокумент = ПечатьПодтвержденияСпискаНаОткрытиеЛицевыхСчетов(МассивОбъектов, ОбъектыПечати, ДанныеДляПечати);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатьПодтвержденияСпискаНаОткрытиеЛицевыхСчетов(МассивОбъектов, ОбъектыПечати, ДанныеДляПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПодтверждениеОткрытияЛицевыхСчетовСотрудников_ПодтверждениеСпискаНаОткрытиеЛицевыхСчетов";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПодтверждениеОткрытияЛицевыхСчетовСотрудников.ПФ_MXL_ПодтверждениеСпискаНаОткрытиеЛицевыхСчетов");
	
	ПервыйДокумент = Истина;
	
	Для Каждого ДанныеДокументаДляПечати Из ДанныеДляПечати Цикл
		
		ДанныеДокумента = ДанныеДокументаДляПечати.Значение;
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подсчитываем количество страниц документа - для корректного разбиения на страницы.
		ВсегоСтрокДокумента = ДанныеДокумента.Сотрудники.Количество();
		
		ОбластьМакетаЗаголовок	= Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакетаШапка		= Макет.ПолучитьОбласть("Шапка");
		ОбластьМакетаСтрока 	= Макет.ПолучитьОбласть("Строка");
		ОбластьМакетаПодвал 	= Макет.ПолучитьОбласть("Подвал");
		
		// Массив с двумя строками - для разбиения на страницы.
		ВыводимыеОбласти = Новый Массив();
		ВыводимыеОбласти.Добавить(ОбластьМакетаСтрока);
		
		// выводим данные о документе
		ОбластьМакетаЗаголовок.Параметры.Дата = Формат(ДанныеДокумента.Дата, "ДЛФ=D");
		ОбластьМакетаЗаголовок.Параметры.НомерДоговора = СокрЛП(ДанныеДокумента.НомерДоговора);
		ОбластьМакетаЗаголовок.Параметры.Организация = СокрЛП(ДанныеДокумента.ПолноеНаименованиеОрганизации);
		ОбластьМакетаЗаголовок.Параметры.РасчетныйСчетОрганизации = СокрЛП(ДанныеДокумента.НомерРасчетногоСчетаОрганизации);
		ОбластьМакетаЗаголовок.Параметры.ПервичныйДокумент = ДанныеДокумента.ПервичныйДокумент;
		
		ТабличныйДокумент.Вывести(ОбластьМакетаЗаголовок);
		
		ВыведеноСтраниц = 1; ВыведеноСтрок = 0;
		
		ОбластьМакетаШапка.Параметры.НомерСтраницы = ВыведеноСтраниц;
		ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
		
		// Выводим данные по строкам документа.
		Для Каждого ДанныеДляПечатиСтроки Из ДанныеДокумента.Сотрудники Цикл
			
			ОбластьМакетаСтрока.Параметры.Заполнить(ДанныеДляПечатиСтроки);
			ОбластьМакетаСтрока.Параметры.ФИОСотрудника = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 %2 %3'"), ДанныеДляПечатиСтроки.Фамилия, ДанныеДляПечатиСтроки.Имя, ДанныеДляПечатиСтроки.Отчество);
			
			
			// разбиение на страницы
			ВыведеноСтрок = ВыведеноСтрок + 1;
			
			// Проверим, уместится ли строка на странице или надо открывать новую страницу.
			ВывестиПодвалЛиста = Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ВыводимыеОбласти);
			Если Не ВывестиПодвалЛиста И ВыведеноСтрок = ВсегоСтрокДокумента Тогда
				ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
				ВывестиПодвалЛиста = Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ВыводимыеОбласти);
			КонецЕсли;
			Если ВывестиПодвалЛиста Тогда
				
				ТабличныйДокумент.Вывести(ОбластьМакетаПодвал);
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				
				ВыведеноСтраниц = ВыведеноСтраниц + 1;
				
				ОбластьМакетаШапка.Параметры.НомерСтраницы = ВыведеноСтраниц;
				ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
				
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакетаСтрока);
			
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ОбластьМакетаПодвал);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеДокумента.Ссылка);
		
	КонецЦикла; // по документам
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

Процедура ЗаполнитьПериодРегистрации() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Ссылка КАК Документ,
	|	НАЧАЛОПЕРИОДА(ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Дата, ДЕНЬ) КАК МесяцОткрытия
	|ИЗ
	|	Документ.ПодтверждениеОткрытияЛицевыхСчетовСотрудников КАК ПодтверждениеОткрытияЛицевыхСчетовСотрудников
	|ГДЕ
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.МесяцОткрытия = ДАТАВРЕМЯ(1, 1, 1)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДокументОбъект = Выборка.Документ.ПолучитьОбъект();
		ДокументОбъект.МесяцОткрытия = Выборка.МесяцОткрытия;
		ДокументОбъект.ОбменДанными.Загрузка = Истина;
		ДокументОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ФормированиеФайлаОбмена

// Получает данные документа.
//
// Параметры:
//		МассивДокументов - Массив ссылок на документы, по которым требуется получить данные.
//
// Возвращаемое значение:
//		Соответствие - где Ключ - ссылка на документ, Значение - структура документа.
//
Функция ДанныеПодтвержденияОткрытияЛицевыхСчетов(МассивДокументов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Ссылка,
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Дата КАК Период,
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудниковСотрудники.НомерСтроки,
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудниковСотрудники.ФизическоеЛицо,
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудниковСотрудники.НомерЛицевогоСчета,
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудниковСотрудники.Сумма,
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудниковСотрудники.РезультатОткрытияСчета,
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудниковСотрудники.КомментарийРезультата
	|ПОМЕСТИТЬ ВТСписокФизическихЛиц
	|ИЗ
	|	Документ.ПодтверждениеОткрытияЛицевыхСчетовСотрудников КАК ПодтверждениеОткрытияЛицевыхСчетовСотрудников
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Сотрудники КАК ПодтверждениеОткрытияЛицевыхСчетовСотрудниковСотрудники
	|		ПО ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Ссылка = ПодтверждениеОткрытияЛицевыхСчетовСотрудниковСотрудники.Ссылка
	|ГДЕ
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Ссылка В(&МассивДокументов)";
	
	Запрос.Выполнить();
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеФизическихЛиц(Запрос.МенеджерВременныхТаблиц, "ВТСписокФизическихЛиц");
	КадровыйУчет.СоздатьВТКадровыеДанныеФизическихЛиц(ОписательВременныхТаблиц, Истина, "Фамилия,Имя,Отчество");
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Ссылка,
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Номер,
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Дата,
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.МесяцОткрытия,
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Организация,
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Подразделение,
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.ПервичныйДокумент,
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.ЗарплатныйПроект,
	|	ВЫБОР
	|		КОГДА Организации.НаименованиеПолное ПОДОБНО """"
	|			ТОГДА Организации.Наименование
	|		ИНАЧЕ Организации.НаименованиеПолное
	|	КОНЕЦ КАК ПолноеНаименованиеОрганизации,
	|	Организации.ИНН КАК ИННОрганизации,
	|	ЗарплатныеПроекты.НомерДоговора КАК НомерДоговора,
	|	ЗарплатныеПроекты.ДатаДоговора КАК ДатаДоговора,
	|	ЗарплатныеПроекты.РасчетныйСчет КАК НомерРасчетногоСчетаОрганизации,
	|	ЗарплатныеПроекты.ОтделениеБанка КАК ОтделениеБанка,
	|	ЗарплатныеПроекты.ФилиалОтделенияБанка КАК ФилиалОтделенияБанка,
	|	ЗарплатныеПроекты.ФорматФайла КАК ФорматФайла
	|ИЗ
	|	Документ.ПодтверждениеОткрытияЛицевыхСчетовСотрудников КАК ПодтверждениеОткрытияЛицевыхСчетовСотрудников
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Организация = Организации.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗарплатныеПроекты КАК ЗарплатныеПроекты
	|		ПО ПодтверждениеОткрытияЛицевыхСчетовСотрудников.ЗарплатныйПроект = ЗарплатныеПроекты.Ссылка
	|ГДЕ
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Ссылка В(&МассивДокументов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокФизическихЛиц.Ссылка,
	|	СписокФизическихЛиц.НомерСтроки,
	|	СписокФизическихЛиц.ФизическоеЛицо,
	|	СписокФизическихЛиц.НомерЛицевогоСчета,
	|	СписокФизическихЛиц.Сумма,
	|	СписокФизическихЛиц.РезультатОткрытияСчета,
	|	СписокФизическихЛиц.КомментарийРезультата,
	|	КадровыеДанныеФизическихЛиц.Фамилия КАК Фамилия,
	|	КадровыеДанныеФизическихЛиц.Имя КАК Имя,
	|	КадровыеДанныеФизическихЛиц.Отчество КАК Отчество
	|ИЗ
	|	ВТСписокФизическихЛиц КАК СписокФизическихЛиц
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК КадровыеДанныеФизическихЛиц
	|		ПО СписокФизическихЛиц.ФизическоеЛицо = КадровыеДанныеФизическихЛиц.ФизическоеЛицо
	|			И СписокФизическихЛиц.Период = КадровыеДанныеФизическихЛиц.Период
	|
	|УПОРЯДОЧИТЬ ПО
	|	СписокФизическихЛиц.Ссылка,
	|	СписокФизическихЛиц.НомерСтроки";
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ДанныеДокументов = Новый Соответствие;
	ВыборкаДокументов = РезультатыЗапроса[РезультатыЗапроса.ВГраница()-1].Выбрать();
	ВыборкаСтрокДокументов = РезультатыЗапроса[РезультатыЗапроса.ВГраница()].Выбрать();
	Пока ВыборкаДокументов.Следующий() Цикл
		ДанныеДокумента = ДанныеЗаполненияПодтвержденияОткрытияЛицевыхСчетов();
		ЗаполнитьЗначенияСвойств(ДанныеДокумента, ВыборкаДокументов);
		ВыборкаСтрокДокументов.Сбросить();
		Пока ВыборкаСтрокДокументов.НайтиСледующий(ВыборкаДокументов.Ссылка, "Ссылка") Цикл
			ДанныеСтрокиДокумента = ДанныеЗаполненияСтрокиПодтвержденияОткрытияЛицевыхСчетов();
			ЗаполнитьЗначенияСвойств(ДанныеСтрокиДокумента, ВыборкаСтрокДокументов);
			ДанныеДокумента.Сотрудники.Добавить(ДанныеСтрокиДокумента);
		КонецЦикла;
		ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ОпределитьДанныеДокументаПодтверждения(ДанныеДокумента, ДанныеДокумента.Ссылка);
		ДанныеДокументов.Вставить(ДанныеДокумента.Ссылка, ДанныеДокумента);
	КонецЦикла;
	
	Возврат ДанныеДокументов;
	
КонецФункции

// Возвращает структуру документа, используемую для формирования печатного документа.
//
Функция ДанныеЗаполненияПодтвержденияОткрытияЛицевыхСчетов() Экспорт
	
	ДанныеЗаполнения = Новый Структура();
	ДанныеЗаполнения.Вставить("Ссылка", Документы.ПодтверждениеОткрытияЛицевыхСчетовСотрудников.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("Номер", "");
	ДанныеЗаполнения.Вставить("Дата", Дата("00010101"));
	ДанныеЗаполнения.Вставить("МесяцОткрытия", Дата("00010101"));
	ДанныеЗаполнения.Вставить("Организация", Справочники.Организации.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("Подразделение", Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("ПервичныйДокумент", Документы.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("ЗарплатныйПроект", Справочники.ЗарплатныеПроекты.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("ПолноеНаименованиеОрганизации", "");
	ДанныеЗаполнения.Вставить("ИННОрганизации", "");
	ДанныеЗаполнения.Вставить("НомерДоговора", "");
	ДанныеЗаполнения.Вставить("ДатаДоговора", Дата("00010101"));
	ДанныеЗаполнения.Вставить("НомерРасчетногоСчетаОрганизации", "");
	ДанныеЗаполнения.Вставить("ОтделениеБанка", "");
	ДанныеЗаполнения.Вставить("ФилиалОтделенияБанка", "");
	ДанныеЗаполнения.Вставить("ФорматФайла", Перечисления.ФорматыФайловОбменаПоЗарплатномуПроекту.ПустаяСсылка());
	
	ДанныеЗаполнения.Вставить("Сотрудники", Новый Массив);
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

// Возвращает структуру строки документа, используемую для формирования печатного документа.
//
Функция ДанныеЗаполненияСтрокиПодтвержденияОткрытияЛицевыхСчетов() Экспорт
	
	ДанныеЗаполнения = Новый Структура();
	ДанныеЗаполнения.Вставить("ФизическоеЛицо", Справочники.ФизическиеЛица.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("Фамилия", "");
	ДанныеЗаполнения.Вставить("Имя", "");
	ДанныеЗаполнения.Вставить("Отчество", "");
	ДанныеЗаполнения.Вставить("НомерЛицевогоСчета", "");
	ДанныеЗаполнения.Вставить("Сумма", 0);
	ДанныеЗаполнения.Вставить("РезультатОткрытияСчета", "");
	ДанныеЗаполнения.Вставить("КомментарийРезультата", "");
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли