
#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыИФункцииДокументаДепонированиеЗарплаты

/// Обработчики событий модуля объекта документов Депонирование зарплаты.

Процедура ДепонированиеЗарплатыОбработкаПроведения(ДокументОбъект, Отказ) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВнешниеХозяйственныеОперацииЗарплатаКадры") Тогда
		
		Ведомость	= ДокументОбъект.Ведомость; 
		Физлица		= ДокументОбъект.Депоненты.ВыгрузитьКолонку("ФизическоеЛицо");
		 
		// проверка на единственность документа депонирования по ведомости
		ДепонированияПоВедомости = Документы.ДепонированиеЗарплаты.ВыбратьПоВедомости(Ведомость, Истина);
		Если ДепонированияПоВедомости.Количество() <> 0 
			И (ДепонированияПоВедомости.Количество() > 1 ИЛИ ДепонированияПоВедомости[0] <> ДокументОбъект.Ссылка) Тогда
			СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'По документу %1 уже введены сведения о депонированной зарплате.'"), Ведомость);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, ДокументОбъект, "Ведомость");
			Отказ = Истина;
		КонецЕсли;	
		
		// проверка на соответствие документа депонирования ведомости
		ОплатаВедомостей = ДокументОбъект.Депоненты.Выгрузить(, "ФизическоеЛицо");
		ОплатаВедомостей.Колонки.Добавить("Ведомость", Метаданные.Документы.ДепонированиеЗарплаты.Реквизиты.Ведомость.Тип);
		ОплатаВедомостей.ЗаполнитьЗначения(Ведомость, "Ведомость");
		
		Проверки = ВзаиморасчетыССотрудниками.ПроверкиОплатыВедомостейДокументом();
		Проверки.Удалить("ПовторнаяВыплата");
		ВзаиморасчетыССотрудниками.ПроверитьОплатуВедомостейДокументом(ДокументОбъект.Ссылка, Отказ, ОплатаВедомостей);
		
		// регистрация депонированных сумм
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ведомость",	Ведомость);
		Запрос.УстановитьПараметр("Физлица", 	Физлица);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВзаиморасчетыССотрудниками.Организация,
		|	ВзаиморасчетыССотрудниками.ФизическоеЛицо,
		|	ВзаиморасчетыССотрудниками.СтатьяФинансирования,
		|	ВзаиморасчетыССотрудниками.СтатьяРасходов,
		|	СУММА(ВзаиморасчетыССотрудниками.СуммаВзаиморасчетов) КАК Сумма
		|ИЗ
		|	РегистрНакопления.ВзаиморасчетыССотрудниками КАК ВзаиморасчетыССотрудниками
		|ГДЕ
		|	ВзаиморасчетыССотрудниками.Регистратор = &Ведомость
		|	И ВзаиморасчетыССотрудниками.ФизическоеЛицо В(&Физлица)
		|
		|СГРУППИРОВАТЬ ПО
		|	ВзаиморасчетыССотрудниками.Организация,
		|	ВзаиморасчетыССотрудниками.ФизическоеЛицо,
		|	ВзаиморасчетыССотрудниками.СтатьяФинансирования,
		|	ВзаиморасчетыССотрудниками.СтатьяРасходов";
		
		ВыборкаПоВедомости = Запрос.Выполнить().Выбрать();
		
		ДепонируемаяЗарплата = УчетДепонированнойЗарплаты.НоваяТаблицаДепонированнойЗарплаты();
		Пока ВыборкаПоВедомости.Следующий() Цикл
			СтрокаДепонируемойЗарплаты = ДепонируемаяЗарплата.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДепонируемойЗарплаты, ВыборкаПоВедомости);
		КонецЦикла;	
		ДепонируемаяЗарплата.ЗаполнитьЗначения(Ведомость, "Ведомость");
		ДепонируемаяЗарплата.ЗаполнитьЗначения(ДокументОбъект.Дата, "Дата");
		
		ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ДокументОбъект);
		УчетДепонированнойЗарплаты.ЗарегистрироватьДепонированнуюЗарплату(ДокументОбъект.Движения, Отказ, ДепонируемаяЗарплата, Истина);
		
	Иначе
		УчетДепонированнойЗарплатыБазовый.ДепонированиеЗарплатыОбработкаПроведения(ДокументОбъект, Отказ)
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область НастройкиВариантовОтчетов

// Содержит настройки размещения вариантов отчетов в панели отчетов.
// Описание см. ЗарплатаКадрыВариантыОтчетов.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	
	// Подчинение вариантов отчета функциональной опции РаботаВХозрасчетнойОрганизации.
	ФункциональныеОпции = Новый Массив;
	ФункциональныеОпции.Добавить("РаботаВХозрасчетнойОрганизации");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.КнигаУчетаДепонентов, "КнигаУчетаДепонентов");
	Вариант.ФункциональныеОпции = ФункциональныеОпции;
	
	
	// Подчинение вариантов отчета функциональной опции РаботаВБюджетномУчреждении.
	ФункциональныеОпции = Новый Массив;
	ФункциональныеОпции.Добавить("РаботаВБюджетномУчреждении");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.КнигаУчетаДепонентов, "Форма0504048");
	Вариант.ФункциональныеОпции = ФункциональныеОпции;
	Вариант.Включен = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Возвращает описание команды печати реестра депонированных сумм.
// 
// Возвращаемое значение:
//   Структура - структура с полями:
//		* ПредставлениеКоманды - строка.
//
Функция ОписаниеПечатиРеестраДепонированныхСумм() Экспорт
	
	ОписаниеПечатиРеестраДепонированныхСумм = УчетДепонированнойЗарплатыБазовый.ОписаниеПечатиРеестраДепонированныхСумм();
	
	Если ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении") Тогда
		ОписаниеПечатиРеестраДепонированныхСумм.ПредставлениеКоманды= НСтр("ru = 'Печать реестра депонированных сумм (ф.0504047)'");
		ОписаниеПечатиРеестраДепонированныхСумм.ИмяМакета			= "Документ.ДепонированиеЗарплаты.ПФ_MXL_РеестрДепонированныхСумм0504047";
		ОписаниеПечатиРеестраДепонированныхСумм.СинонимМакета		= НСтр("ru = 'Реестр депонированных сумм (0504047)'");
	КонецЕсли;	
	
	Возврат ОписаниеПечатиРеестраДепонированныхСумм
	
КонецФункции

Процедура ПриКомпоновкеОтчетаКнигаУчетаДепонентов(Объект, ДокументРезультат, СтандартнаяОбработка) Экспорт
	
	КлючВарианта = ЗарплатаКадрыОтчеты.КлючВарианта(Объект.КомпоновщикНастроек);
	Если КлючВарианта = "КнигаУчетаДепонентов" Тогда		
		УчетДепонированнойЗарплатыБазовый.ПриКомпоновкеОтчетаКнигаУчетаДепонентов(Объект, ДокументРезультат, СтандартнаяОбработка);		
	Иначе
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.УчетБюджетныхУчреждений") Тогда
			Модуль = ОбщегоНазначения.ОбщийМодуль("ОтчетыПечатныеФормыБюджетныхУчреждений");
			Модуль.ПриКомпоновкеОтчетаКнигаУчетаДепонентов(Объект, ДокументРезультат, СтандартнаяОбработка, КлючВарианта);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
