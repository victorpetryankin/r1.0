#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Подсистема "Управление доступом".

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора.
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИСотрудникам(ЭтотОбъект, Таблица, "Организация", "Сотрудники.Сотрудник");
	
КонецПроцедуры

// Подсистема "Управление доступом".

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру параметров для ограничения регистрации объекта при обмене
// Вызывается ПередЗаписью объекта.
//
// Возвращаемое значение:
//	ОграниченияРегистрации - Структура - Описание см. ОбменДаннымиЗарплатаКадры.ОграниченияРегистрации.
//
Функция ОграниченияРегистрации() Экспорт
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый Структура("Сотрудники", "Сотрудник"));
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИСотрудникам(ЭтотОбъект, Организация, МассивПараметров, ДатаИзменения);
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ЗарплатаКадрыРасширенный.ИнициализироватьОтложеннуюРегистрациюВторичныхДанныхПоДвижениямДокумента(Движения);
	
	ДанныеДляПроведения = ПолучитьДанныеДляПроведения();
	
	ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента(Движения, ДанныеДляПроведения.СотрудникиДаты, Ссылка);
	
	СтруктураПлановыхНачислений = Новый Структура;
	СтруктураПлановыхНачислений.Вставить("ДанныеОПлановыхНачислениях", ДанныеДляПроведения.ПлановыеНачисления);
	СтруктураПлановыхНачислений.Вставить("ЗначенияПоказателей", ДанныеДляПроведения.ЗначенияПоказателей);
	
	РасчетЗарплаты.СформироватьДвиженияПлановыхНачислений(ЭтотОбъект, Движения, СтруктураПлановыхНачислений);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьИндексациюЗаработка")
		И УчитыватьКакИндексациюЗаработка Тогда
		Движения.КоэффициентИндексацииЗаработка.Загрузить(ДанныеДляПроведения.КоэффициентыИндексации);
		Движения.КоэффициентИндексацииЗаработка.Записывать = Истина;
	КонецЕсли;
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетов(Движения, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетовПриОтменеПроведения(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаИзменения, "Объект.ДатаИзменения", Отказ, НСтр("ru='Дата изменения'"), , , Ложь);
	
	Если ЗначениеЗаполнено(ДатаОкончания)
		И ДатаОкончания < ДатаИзменения Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Дата окончания должна быть больше даты изменения'"),
			Ссылка,
			"ДатаОкончания",
			"Объект",
			Отказ)
		
	КонецЕсли;
	
	ДатыИзмененияСотрудников = Новый Соответствие;
	ИндексСтроки = 0;
	Для каждого СтрокаСотрудника Из Сотрудники Цикл
		
		ДатыИзмененияСотрудников.Вставить(СтрокаСотрудника.Сотрудник, СтрокаСотрудника.ДатаИзменения);
		
		Если ЗначениеЗаполнено(СтрокаСотрудника.ДатаОкончания)
		И СтрокаСотрудника.ДатаОкончания < СтрокаСотрудника.ДатаИзменения Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Дата окончания должна быть больше даты изменения'"),
				Ссылка,
				"Сотрудники[" + ИндексСтроки + "].ДатаОкончания",
				"Объект",
				Отказ)
			
		КонецЕсли;
		
		ИндексСтроки = ИндексСтроки + 1;
		
	КонецЦикла;
	
	Документы.ИзменениеПлановыхНачислений.ПроверитьПересечениеПериодовДействия(
		ЭтотОбъект, "Сотрудники", "Сотрудник", "ДатаИзменения", "ДатаОкончания", Отказ);
	
	УстановитьПривилегированныйРежим(Истина);
	
	КадровыйУчет.ПроверитьРаботающихСотрудниковТабличнойЧастиДокумента(ЭтотОбъект, "Сотрудники", "ДатаИзменения", "ДатаИзменения", Отказ);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание") Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Подразделение");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает данные для формирования движений.
// Возвращает Структуру с полями.
//		ПлановыеНачисления - данные, необходимые для формирования истории плановых начислений.
//		(см. РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений)
//		ЗначенияПоказателей (см. там же).
//
Функция ПолучитьДанныеДляПроведения()
	
	ДанныеДляПроведения = Новый Структура; 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ИзменениеПлановыхНачисленийСотрудники.Ссылка,
		|	ИзменениеПлановыхНачисленийСотрудники.Ссылка.Организация КАК Организация,
		|	ИзменениеПлановыхНачисленийСотрудники.ДатаИзменения КАК ДатаСобытия,
		|	ИзменениеПлановыхНачисленийСотрудники.Сотрудник КАК Сотрудник,
		|	ВЫБОР
		|		КОГДА ИзменениеПлановыхНачисленийСотрудники.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ИзменениеПлановыхНачисленийСотрудники.ДатаОкончания
		|		ИНАЧЕ ДОБАВИТЬКДАТЕ(ИзменениеПлановыхНачисленийСотрудники.ДатаОкончания, ДЕНЬ, 1)
		|	КОНЕЦ КАК ДействуетДо,
		|	ИзменениеПлановыхНачисленийСотрудники.СовокупнаяТарифнаяСтавка,
		|	ИзменениеПлановыхНачисленийСотрудники.ВидТарифнойСтавки,
		|	ИзменениеПлановыхНачисленийСотрудники.КоэффициентИндексации,
		|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Сотрудники.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ИзменениеПлановыхНачисленийСотрудники.ИдентификаторСтрокиСотрудника
		|ПОМЕСТИТЬ ВТСотрудникиДокумента
		|ИЗ
		|	Документ.ИзменениеПлановыхНачислений.Сотрудники КАК ИзменениеПлановыхНачисленийСотрудники
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
		|		ПО ИзменениеПлановыхНачисленийСотрудники.Сотрудник = Сотрудники.Ссылка
		|ГДЕ
		|	ИзменениеПлановыхНачисленийСотрудники.Ссылка = &Ссылка";
	
	Запрос.Выполнить();
	
	// Подготовка данных для проведения.
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИзменениеПлановыхНачисленийСотрудники.ДатаСобытия,
		|	ИзменениеПлановыхНачисленийСотрудники.ДействуетДо,
		|	ИзменениеПлановыхНачисленийСотрудники.Сотрудник,
		|	ИзменениеПлановыхНачисленийСотрудники.ФизическоеЛицо,
		|	ИзменениеПлановыхНачисленийСотрудники.ГоловнаяОрганизация,
		|	НачисленияСотрудников.Начисление КАК Начисление,
		|	НачисленияСотрудников.ДокументОснование КАК ДокументОснование,
		|	ВЫБОР
		|		КОГДА НачисленияСотрудников.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Используется,
		|	ВЫБОР
		|		КОГДА НачисленияСотрудников.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|			ТОГДА ИСТИНА
		|		КОГДА НачисленияСотрудников.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Утвердить)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ИспользуетсяПоОкончании,
		|	НачисленияСотрудников.Размер КАК Размер
		|ИЗ
		|	ВТСотрудникиДокумента КАК ИзменениеПлановыхНачисленийСотрудники
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеПлановыхНачислений.НачисленияСотрудников КАК НачисленияСотрудников
		|		ПО ИзменениеПлановыхНачисленийСотрудники.Ссылка = НачисленияСотрудников.Ссылка
		|			И ИзменениеПлановыхНачисленийСотрудники.ИдентификаторСтрокиСотрудника = НачисленияСотрудников.ИдентификаторСтрокиСотрудника";
	
	// Таблица для формирования плановых начислений.
	ПлановыеНачисления = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("ПлановыеНачисления", ПлановыеНачисления);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИзменениеПлановыхНачисленийСотрудники.Организация,
		|	ИзменениеПлановыхНачисленийСотрудники.Сотрудник,
		|	ИзменениеПлановыхНачисленийСотрудники.ДатаСобытия,
		|	ИзменениеПлановыхНачисленийСотрудники.ДействуетДо,
		|	ИзменениеПлановыхНачисленийСотрудники.ФизическоеЛицо,
		|	ПоказателиСотрудников.Показатель,
		|	ПоказателиСотрудников.ДокументОснование,
		|	МАКСИМУМ(ПоказателиСотрудников.Значение) КАК Значение
		|ИЗ
		|	ВТСотрудникиДокумента КАК ИзменениеПлановыхНачисленийСотрудники
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеПлановыхНачислений.ПоказателиСотрудников КАК ПоказателиСотрудников
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПоказателиРасчетаЗарплаты КАК Показатели
		|			ПО ПоказателиСотрудников.Показатель = Показатели.Ссылка
		|		ПО ИзменениеПлановыхНачисленийСотрудники.Ссылка = ПоказателиСотрудников.Ссылка
		|			И ИзменениеПлановыхНачисленийСотрудники.ИдентификаторСтрокиСотрудника = ПоказателиСотрудников.ИдентификаторСтрокиСотрудника
		|ГДЕ
		|	ПоказателиСотрудников.Показатель <> ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.ПустаяСсылка)
		|	И (ПоказателиСотрудников.Значение <> 0
		|			ИЛИ Показатели.ДопускаетсяНулевоеЗначение
		|			ИЛИ ПоказателиСотрудников.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.ПустаяСсылка))
		|
		|СГРУППИРОВАТЬ ПО
		|	ИзменениеПлановыхНачисленийСотрудники.Организация,
		|	ИзменениеПлановыхНачисленийСотрудники.Сотрудник,
		|	ИзменениеПлановыхНачисленийСотрудники.ДатаСобытия,
		|	ИзменениеПлановыхНачисленийСотрудники.ДействуетДо,
		|	ИзменениеПлановыхНачисленийСотрудники.ФизическоеЛицо,
		|	ПоказателиСотрудников.Показатель,
		|	ПоказателиСотрудников.ДокументОснование";
	
	// Таблица для формирования значений показателей.
	ЗначенияПоказателей = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("ЗначенияПоказателей", ЗначенияПоказателей);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИзменениеПлановыхНачисленийСотрудники.Сотрудник,
		|	ИзменениеПлановыхНачисленийСотрудники.ДатаСобытия,
		|	ИзменениеПлановыхНачисленийСотрудники.ДействуетДо,
		|	ИзменениеПлановыхНачисленийСотрудники.СовокупнаяТарифнаяСтавка КАК Значение,
		|	ВЫБОР
		|		КОГДА ИзменениеПлановыхНачисленийСотрудники.СовокупнаяТарифнаяСтавка = 0
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыТарифныхСтавок.ПустаяСсылка)
		|		ИНАЧЕ ИзменениеПлановыхНачисленийСотрудники.ВидТарифнойСтавки
		|	КОНЕЦ КАК ВидТарифнойСтавки,
		|	ИзменениеПлановыхНачисленийСотрудники.ФизическоеЛицо
		|ИЗ
		|	ВТСотрудникиДокумента КАК ИзменениеПлановыхНачисленийСотрудники";
	
	// Таблица для формирования значений совокупных тарифных ставок.
	ДанныеСовокупныхТарифныхСтавок = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("ДанныеСовокупныхТарифныхСтавок", ДанныеСовокупныхТарифныхСтавок);
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ИзменениеПлановыхНачисленийСотрудники.ДатаСобытия,
		|	ИзменениеПлановыхНачисленийСотрудники.Сотрудник
		|ИЗ
		|	ВТСотрудникиДокумента КАК ИзменениеПлановыхНачисленийСотрудники";
	
	// Таблица для формирования времени регистрации документа.
	СотрудникиДаты = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("СотрудникиДаты", СотрудникиДаты);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИзменениеПлановыхНачисленийСотрудники.ДатаСобытия КАК Период,
		|	ИзменениеПлановыхНачисленийСотрудники.Сотрудник,
		|	ИзменениеПлановыхНачисленийСотрудники.КоэффициентИндексации КАК Коэффициент
		|ИЗ
		|	ВТСотрудникиДокумента КАК ИзменениеПлановыхНачисленийСотрудники";
	
	// Таблица для формирования коэффициентов индексации.
	КоэффициентыИндексации = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("КоэффициентыИндексации", КоэффициентыИндексации);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#Область ЗаполнитьДокумент

Процедура ЗаполнитьДокументПоСпискуСотрудников(СписокСотрудников, ДатаИзменения) Экспорт
	
	ФильтрСотрудников = Документы.ИзменениеПлановыхНачислений.ФильтрСотрудниковПоПараметрам(СписокСотрудников, ДатаИзменения);
	ЗаполнитьДокумент(ФильтрСотрудников, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьДокумент(ФильтрСотрудников = Неопределено, ЗаполнитьСписокНачислений = Ложь, НачисленияПоказателиСотрудников = Неопределено, ДолжностиПоШтатномуРасписанию = Неопределено) Экспорт
	
	ОчиститьДанные(ФильтрСотрудников);
	
	НачисленияПоказателиСотрудников = Документы.ИзменениеПлановыхНачислений.НачисленияПоказателиСотрудниковПоОбъекту(ЭтотОбъект, ФильтрСотрудников,,ДолжностиПоШтатномуРасписанию);
	Документы.ИзменениеПлановыхНачислений.ЗаполнитьСотрудников(ЭтотОбъект, НачисленияПоказателиСотрудников);
	
	Документы.ИзменениеПлановыхНачислений.ЗаполнитьНачисленияПоказатели(
		ЭтотОбъект, НачисленияПоказателиСотрудников.НачисленияСотрудников, НачисленияПоказателиСотрудников.ПоказателиСотрудников);
	
КонецПроцедуры

Процедура ОчиститьДанные(ФильтрСотрудников)
	
	Если ФильтрСотрудников = Неопределено Тогда
		Сотрудники.Очистить();
		НачисленияСотрудников.Очистить();
		ПоказателиСотрудников.Очистить();
	Иначе
		Для каждого Строка Из ФильтрСотрудников Цикл  
			ОчиститьДанныеПоСотруднику(Строка.Сотрудник, Строка.ДатаИзменения);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьДанныеПоСотруднику(Сотрудник, ДатаИзменения)
	
	ОтборПоСотруднику = Новый Структура("Сотрудник, ДатаИзменения", Сотрудник, ДатаИзменения);
	
	СтрокиДляУдаления = Сотрудники.НайтиСтроки(ОтборПоСотруднику);
	Для Каждого СтрокаДляУдаления Из СтрокиДляУдаления Цикл
		
		СтрокиДляУдаленияНачисления = НачисленияСотрудников.НайтиСтроки(Новый Структура("ИдентификаторСтрокиСотрудника", СтрокаДляУдаления.ИдентификаторСтрокиСотрудника));
		Для Каждого СтрокаДляУдаленияНачисления Из СтрокиДляУдаленияНачисления Цикл
			НачисленияСотрудников.Удалить(СтрокаДляУдаленияНачисления);
		КонецЦикла;
		
		СтрокиДляУдаленияПоказатели = ПоказателиСотрудников.НайтиСтроки(Новый Структура("ИдентификаторСтрокиСотрудника", СтрокаДляУдаления.ИдентификаторСтрокиСотрудника));
		Для Каждого СтрокаДляУдаленияПоказатели Из СтрокиДляУдаленияПоказатели Цикл
			ПоказателиСотрудников.Удалить(СтрокаДляУдаленияПоказатели);
		КонецЦикла;
		
		Сотрудники.Удалить(СтрокаДляУдаления);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоТарифнойСетке(ТарифнаяСетка) Экспорт
	
	МенеджерВременныхТаблиц = Неопределено;
	РезультатЗапроса = РезультатЗапросаПоИзменениямПлановыхНачислений(ТарифнаяСетка, МенеджерВременныхТаблиц);
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ПоказателиТарифнойСетки = РазрядыКатегорииДолжностей.ПоказателиТарифнойСетки(ТарифнаяСетка, Истина);
		
		ТаблицаИзменений = РезультатЗапроса.Выгрузить();
		СотрудникиКЗаполнению = ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаИзменений, "Сотрудник", Истина);
		ЗаполнитьДокументПоСпискуСотрудников(СотрудникиКЗаполнению, ДатаИзменения);
		
		СотрудникиДляРасчетаФОТ = Новый Массив;
		Для каждого СтрокаСотрудника Из ТаблицаИзменений Цикл
			
			СтрокиСотрудникаДокумента = Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", СтрокаСотрудника.Сотрудник));
			Если СтрокиСотрудникаДокумента.Количество() = 0 Тогда
				Продолжить;
			Иначе
				СтрокаСотрудникаДокумента = СтрокиСотрудникаДокумента[0];
			КонецЕсли;
			
			СтруктураПоиска = Новый Структура("ИдентификаторСтрокиСотрудника,Показатель");
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаСотрудникаДокумента);
			
			Для каждого Показатель Из ПоказателиТарифнойСетки Цикл
				
				СтруктураПоиска.Показатель = Показатель;
				
				СтрокиПоказателейСотрудника = ПоказателиСотрудников.НайтиСтроки(СтруктураПоиска);
				Для каждого СтрокаПоказателейСотрудника Из СтрокиПоказателейСотрудника Цикл
					СтрокаПоказателейСотрудника.Значение = СтрокаСотрудника.Тариф;
				КонецЦикла;
				
			КонецЦикла;
			
			СотрудникиДляРасчетаФОТ.Добавить(СтрокаСотрудника.Сотрудник);
			
		КонецЦикла;
		
		// Расчет ФОТ
		Если СотрудникиДляРасчетаФОТ.Количество() > 0 Тогда
			ТаблицаНачислений = ПлановыеНачисленияСотрудников.ТаблицаНачисленийДляРасчетаВторичныхДанных();
			ТаблицаПоказателей = ПлановыеНачисленияСотрудников.ТаблицаИзвестныеПоказатели();
			КадровыеДанные = ПлановыеНачисленияСотрудников.СоздатьТаблицаКадровыхДанных();
							
			ВремяРегистрацииСотрудников = ЗарплатаКадрыРасширенный.ВремяРегистрацииСотрудниковДокумента(
				Ссылка, СотрудникиДляРасчетаФОТ, ДатаИзменения);
			
			СтрокиСотрудников = Новый Массив;
							
			ИдентификаторыСтрокПоСотрудникам = Новый Соответствие;
			
			ОтборПоСотруднику = Новый Структура;
			
			Для Каждого Сотрудник Из СотрудникиДляРасчетаФОТ Цикл
				
				СтрокиСотрудника = Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
				Если СтрокиСотрудника.Количество() = 0 Тогда
					Продолжить;
				Иначе
					СтрокаСотрудника = СтрокиСотрудника[0];
				КонецЕсли;
				
				ГоловнаяОрганизация = ЗарплатаКадрыПовтИсп.ГоловнаяОрганизация(Организация);
				ВремяРегистрацииСобытия = ВремяРегистрацииСотрудников.Получить(Сотрудник);
				
				СтрокаТаблицыКадровыхДанных = КадровыеДанные.Добавить();
				СтрокаТаблицыКадровыхДанных.Сотрудник = Сотрудник;
				СтрокаТаблицыКадровыхДанных.Период = ВремяРегистрацииСобытия;
				СтрокаТаблицыКадровыхДанных.Организация = Организация;
				
				СтрокиСотрудников.Добавить(СтрокаСотрудника);
				
				ИдентификаторыСтрокПоСотрудникам.Вставить(Сотрудник, СтрокаСотрудника.ИдентификаторСтрокиСотрудника);
				
				ОтборПоСотруднику.Вставить("ИдентификаторСтрокиСотрудника", СтрокаСотрудника.ИдентификаторСтрокиСотрудника);
				
				// Все начисления сотрудника.
				СтрокиПоСотруднику = НачисленияСотрудников.НайтиСтроки(ОтборПоСотруднику);
				Для Каждого СтрокаНачисления Из СтрокиПоСотруднику Цикл
					
					Если СтрокаНачисления.Действие = Перечисления.ДействияСНачислениямиИУдержаниями.Отменить Тогда
						Продолжить;
					КонецЕсли;
					
					СтрокаТаблицыНачислений = ТаблицаНачислений.Добавить();
					СтрокаТаблицыНачислений.Сотрудник = Сотрудник;
					СтрокаТаблицыНачислений.Период = ВремяРегистрацииСобытия;
					СтрокаТаблицыНачислений.ГоловнаяОрганизация = ГоловнаяОрганизация;
					СтрокаТаблицыНачислений.Начисление = СтрокаНачисления.Начисление;
					СтрокаТаблицыНачислений.ДокументОснование = СтрокаНачисления.ДокументОснование;
					СтрокаТаблицыНачислений.Размер = СтрокаНачисления.Размер;
					
				КонецЦикла;
				
				// Заданные в документе показатели начислений сотрудника.
				// Все начисления сотрудника.
				СтрокиПоСотруднику = ПоказателиСотрудников.НайтиСтроки(ОтборПоСотруднику);
				Для Каждого СтрокаПоказателя Из СтрокиПоСотруднику Цикл
					
					Если СтрокаПоказателя.Значение = 0 Тогда
						Продолжить;
					КонецЕсли;
					
					СтрокаТаблицыПоказателей = ТаблицаПоказателей.Добавить();
					СтрокаТаблицыПоказателей.Сотрудник = Сотрудник;
					СтрокаТаблицыПоказателей.Период = ВремяРегистрацииСобытия;
					СтрокаТаблицыПоказателей.ГоловнаяОрганизация = ГоловнаяОрганизация;
					
					СтрокаТаблицыПоказателей.Показатель = СтрокаПоказателя.Показатель;
					СтрокаТаблицыПоказателей.ДокументОснование = СтрокаПоказателя.ДокументОснование;
					СтрокаТаблицыПоказателей.Значение = СтрокаПоказателя.Значение;
											
				КонецЦикла;
				
			КонецЦикла;
			
			// Расчет ФОТ
			РасчитанныеДанныеНачислений = ПлановыеНачисленияСотрудников.РассчитатьВторичныеДанныеПлановыхНачислений(ТаблицаНачислений, ТаблицаПоказателей, КадровыеДанные);
			
			Отбор = Новый Структура("ИдентификаторСтрокиСотрудника, Начисление, ДокументОснование");
			
			// Заполнение документа результатами расчета.
			Для каждого СтрокаРассчитанногоНачисления Из РасчитанныеДанныеНачислений.ПлановыйФОТ Цикл
				Отбор.ИдентификаторСтрокиСотрудника = ИдентификаторыСтрокПоСотрудникам[СтрокаРассчитанногоНачисления.Сотрудник];
				Отбор.Начисление = СтрокаРассчитанногоНачисления.Начисление;
				Отбор.ДокументОснование = СтрокаРассчитанногоНачисления.ДокументОснование;
														
				СтрокиНачисления = НачисленияСотрудников.НайтиСтроки(Отбор);
						
				Для Каждого СтрокаНачисления Из СтрокиНачисления Цикл
					
					Если СтрокаНачисления.Действие = Перечисления.ДействияСНачислениямиИУдержаниями.Отменить Тогда
						Продолжить;
					КонецЕсли;
					
					СтрокаНачисления.Размер = СтрокаРассчитанногоНачисления.ВкладВФОТ;
				КонецЦикла;
						
			КонецЦикла;
											
			Для Каждого СтрокаСотрудника Из СтрокиСотрудников Цикл
				
				ДанныеСотрудников = РасчитанныеДанныеНачислений.ТарифныеСтавки.НайтиСтроки(Новый Структура("Период,Сотрудник", ВремяРегистрацииСотрудников.Получить(СтрокаСотрудника.Сотрудник), СтрокаСотрудника.Сотрудник));
				Для каждого ДанныеСотрудника Из ДанныеСотрудников Цикл
					СтрокаСотрудника.СовокупнаяТарифнаяСтавка = ДанныеСотрудника.СовокупнаяТарифнаяСтавка;
					СтрокаСотрудника.ВидТарифнойСтавки = ДанныеСотрудника.ВидТарифнойСтавки;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Процедура СоздатьВТДанныеДокументов(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаДокумента.Ссылка.Организация КАК Организация,
		|	ТаблицаСотрудникиДокумента.Сотрудник,
		|	ТаблицаСотрудникиДокумента.ДатаИзменения КАК ПериодДействия,
		|	ТаблицаДокумента.Ссылка КАК ДокументОснование
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.ИзменениеПлановыхНачислений.НачисленияСотрудников КАК ТаблицаДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИзменениеПлановыхНачислений.Сотрудники КАК ТаблицаСотрудникиДокумента
		|		ПО ТаблицаДокумента.Ссылка = ТаблицаСотрудникиДокумента.Ссылка
		|			И ТаблицаДокумента.ИдентификаторСтрокиСотрудника = ТаблицаСотрудникиДокумента.ИдентификаторСтрокиСотрудника
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаДокумента.Ссылка.Организация,
		|	ТаблицаСотрудникиДокумента.Сотрудник,
		|	ТаблицаСотрудникиДокумента.ДатаОкончания,
		|	ТаблицаДокумента.Ссылка
		|ИЗ
		|	Документ.ИзменениеПлановыхНачислений.НачисленияСотрудников КАК ТаблицаДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИзменениеПлановыхНачислений.Сотрудники КАК ТаблицаСотрудникиДокумента
		|		ПО ТаблицаДокумента.Ссылка = ТаблицаСотрудникиДокумента.Ссылка
		|			И ТаблицаДокумента.ИдентификаторСтрокиСотрудника = ТаблицаСотрудникиДокумента.ИдентификаторСтрокиСотрудника
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор
		|	И ТаблицаСотрудникиДокумента.ДатаОкончания <> ДАТАВРЕМЯ(1, 1, 1)";
		
	Запрос.Выполнить();
	
КонецПроцедуры

Функция РезультатЗапросаПоИзменениямПлановыхНачислений(ТарифнаяСетка, МенеджерВременныхТаблиц = Неопределено)
	
	Запрос = Новый Запрос;
	
	Если МенеджерВременныхТаблиц = Неопределено Тогда
		МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		РазрядыКатегорииДолжностей.СоздатьВТТарифы(ТарифнаяСетка, ДатаИзменения, МенеджерВременныхТаблиц);
	КонецЕсли;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	СоздатьВТСотрудникиСОплатойПоТарифнойСетке(МенеджерВременныхТаблиц, ТарифнаяСетка);
	
	Показатели = РазрядыКатегорииДолжностей.ПоказателиТарифнойСетки(ТарифнаяСетка, Истина);
	Запрос.УстановитьПараметр("Показатели", Показатели);
	
	ФОИспользоватьШтатноеРасписание = ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание");
	
	ВидТарифнойСетки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТарифнаяСетка, "ВидТарифнойСетки");
	Если ВидТарифнойСетки = Перечисления.ВидыТарифныхСеток.Надбавка Тогда
		ИмяПоляТарифнаяСетка = "ТарифнаяСеткаНадбавки";
	Иначе
		ИмяПоляТарифнаяСетка = "ТарифнаяСетка";
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ДатаВступленияВСилу", ДатаИзменения);
	Запрос.УстановитьПараметр("ТарифнаяСетка", ТарифнаяСетка);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	СотрудникиОрганизации.Организация КАК Организация,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(СотрудникиОрганизации.Подразделение) КАК ПредставлениеПодразделение,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(СотрудникиОрганизации.Должность) КАК ПредставлениеДолжность,
		|	СотрудникиОрганизации.Сотрудник КАК Сотрудник,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(СотрудникиОрганизации.Сотрудник) КАК ПредставлениеСотрудник,
		|	Тарифы.Тариф
		|ИЗ
		|	ВТСотрудникиОрганизацииСПоказателями КАК СотрудникиОрганизации
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТТарифы КАК Тарифы
		|		ПО СотрудникиОрганизации.РазрядКатегория = Тарифы.РазрядКатегория
		|ГДЕ
		|	СотрудникиОрганизации.ТарифнаяСетка = &ТарифнаяСетка
		|
		|УПОРЯДОЧИТЬ ПО
		|	Сотрудник";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "СотрудникиОрганизации.ТарифнаяСетка = &ТарифнаяСетка", "СотрудникиОрганизации." + ИмяПоляТарифнаяСетка + " = &ТарифнаяСетка");
	
	Если ФОИспользоватьШтатноеРасписание Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "СотрудникиОрганизации.Должность", "СотрудникиОрганизации.ДолжностьПоШтатномуРасписанию");
	КонецЕсли; 
	
	Если ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении")
		И ВидТарифнойСетки = Перечисления.ВидыТарифныхСеток.Тариф Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "СотрудникиОрганизации.РазрядКатегория = Тарифы.РазрядКатегория",
			"ВЫРАЗИТЬ(СотрудникиОрганизации.ДолжностьПоШтатномуРасписанию КАК Справочник.ШтатноеРасписание).РазрядКатегория = Тарифы.РазрядКатегория");
		
	КонецЕсли;
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Процедура СоздатьВТСотрудникиСОплатойПоТарифнойСетке(МенеджерВременныхТаблиц, ТарифнаяСетка)
	
	ФОИспользоватьШтатноеРасписание = ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание");
	ВидТарифнойСетки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТарифнаяСетка, "ВидТарифнойСетки");
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;

	Показатели = РазрядыКатегорииДолжностей.ПоказателиТарифнойСетки(ТарифнаяСетка, Истина);
	Запрос.УстановитьПараметр("Показатели", Показатели);
	Запрос.УстановитьПараметр("ДатаВступленияВСилу", ДатаИзменения);
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	&ДатаВступленияВСилу КАК Период,
		|	НачисленияПоказатели.Ссылка КАК Начисление,
		|	НачисленияПоказатели.Показатель
		|ПОМЕСТИТЬ ВТНачисленияПериоды
		|ИЗ
		|	ПланВидовРасчета.Начисления.Показатели КАК НачисленияПоказатели
		|ГДЕ
		|	НачисленияПоказатели.Показатель В(&Показатели)";

	Запрос.Выполнить();
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ПлановыеНачисления",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра("ВТНачисленияПериоды", "Начисление"));
		
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПлановыеНачисления.Период,
		|	ПлановыеНачисления.ФизическоеЛицо
		|ПОМЕСТИТЬ ВТФизическиеЛица
		|ИЗ
		|	ВТПлановыеНачисленияСрезПоследних КАК ПлановыеНачисления
		|ГДЕ
		|	ПлановыеНачисления.Используется
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПлановыеНачисления.Период,
		|	ПлановыеНачисления.Сотрудник,
		|	ПлановыеНачисления.ФизическоеЛицо
		|ПОМЕСТИТЬ ВТСотрудникиОтбор
		|ИЗ
		|	ВТПлановыеНачисленияСрезПоследних КАК ПлановыеНачисления
		|ГДЕ
		|	ПлановыеНачисления.Используется
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТНачисленияПериоды
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТПлановыеНачисленияСрезПоследних";
	
	Запрос.Выполнить();
	
	ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистраСрез();
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
		ПараметрыПостроения.Отборы, "Показатель", "В", Показатели);
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников",
		МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(
			"ВТСотрудникиОтбор", "Сотрудник,ФизическоеЛицо"),
		ПараметрыПостроения,
		"ВТЗначенияПериодическихПоказателей");
	
	ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоВременнойТаблице();
	ПараметрыПолученияСотрудников.Организация = Организация;
	ПараметрыПолученияСотрудников.НачалоПериода = ДатаИзменения;
	ПараметрыПолученияСотрудников.ОкончаниеПериода = ДатаИзменения;
	ПараметрыПолученияСотрудников.КадровыеДанные = "Организация,Подразделение,Должность,РазрядКатегория";
	
	Если ФОИспользоватьШтатноеРасписание Тогда
		ПараметрыПолученияСотрудников.КадровыеДанные = ПараметрыПолученияСотрудников.КадровыеДанные + ",ДолжностьПоШтатномуРасписанию";
	КонецЕсли;
	
	Если ВидТарифнойСетки = Перечисления.ВидыТарифныхСеток.Надбавка Тогда
		ПараметрыПолученияСотрудников.КадровыеДанные = ПараметрыПолученияСотрудников.КадровыеДанные + ",ТарифнаяСеткаНадбавки";
	Иначе
		ПараметрыПолученияСотрудников.КадровыеДанные = ПараметрыПолученияСотрудников.КадровыеДанные + ",ТарифнаяСетка";
	КонецЕсли;
	
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, ПараметрыПолученияСотрудников);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СотрудникиОрганизации.Сотрудник,
		|	СотрудникиОрганизации.ФизическоеЛицо,
		|	СотрудникиОрганизации.Организация,
		|	СотрудникиОрганизации.Подразделение,
		|	СотрудникиОрганизации.Должность,
		|	СотрудникиОрганизации.РазрядКатегория,
		|	СотрудникиОрганизации.ТарифнаяСетка,
		|	МАКСИМУМ(ЗначенияПериодическихПоказателей.Значение) КАК Значение
		|ПОМЕСТИТЬ ВТСотрудникиОрганизацииСПоказателями
		|ИЗ
		|	ВТСотрудникиОрганизации КАК СотрудникиОрганизации
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗначенияПериодическихПоказателей КАК ЗначенияПериодическихПоказателей
		|		ПО СотрудникиОрганизации.Сотрудник = ЗначенияПериодическихПоказателей.Сотрудник
		|			И СотрудникиОрганизации.Организация = ЗначенияПериодическихПоказателей.Организация
		|
		|СГРУППИРОВАТЬ ПО
		|	СотрудникиОрганизации.Сотрудник,
		|	СотрудникиОрганизации.ФизическоеЛицо,
		|	СотрудникиОрганизации.Организация,
		|	СотрудникиОрганизации.Подразделение,
		|	СотрудникиОрганизации.Должность,
		|	СотрудникиОрганизации.ТарифнаяСетка,
		|	СотрудникиОрганизации.РазрядКатегория
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТФизическиеЛица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТСотрудникиОтбор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТЗначенияПериодическихПоказателей
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТСотрудникиОрганизации";
	
	Если ФОИспользоватьШтатноеРасписание Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "СотрудникиОрганизации.Должность,",
			"СотрудникиОрганизации.Должность,
			|	СотрудникиОрганизации.ДолжностьПоШтатномуРасписанию,");
	КонецЕсли;
	
	Если ВидТарифнойСетки = Перечисления.ВидыТарифныхСеток.Надбавка Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "СотрудникиОрганизации.ТарифнаяСетка,",
			"СотрудникиОрганизации.ТарифнаяСеткаНадбавки,");
	КонецЕсли;
	
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
