////////////////////////////////////////////////////////////////////////////////
// Серверные процедуры и функции общего назначения
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Общие процедуры и функции для работы с данными в базе.

// Значения реквизитов, прочитанные из информационной базы для нескольких объектов.
//
//  Если необходимо зачитать реквизит независимо от прав текущего пользователя,
//  то следует использовать предварительный переход в привилегированный режим.
//
// Параметры:
//  Ссылки      - Массив - ссылки на объекты, значения реквизитов которых нужно получить.
//                         Если массив пуст, то результатом будет пустое соответствие.
//  Реквизиты   - Строка - имена реквизитов, перечисленные через запятую, 
//                         в формате требований к свойствам структуры. 
//                         Например, "Код, Наименование, Родитель".
//  Разрешенные - Булево - если Истина, то будут получены реквизиты объектов, доступные по правам пользователя;
//                       - если Ложь, то возникнет исключение при отсутствии прав на объект или реквизит.
//
// Возвращаемое значение:
//  Соответствие - список объектов и значений их реквизитов:
//   * Ключ - ЛюбаяСсылка - ссылка на объект;
//   * Значение - Структура - значения реквизитов:
//    ** Ключ - Строка - имя реквизита;
//    ** Значение - Произвольный - значение реквизита.
// 
Функция ЗначенияРеквизитовОбъектов(Ссылки, Знач Реквизиты, Разрешенные = Ложь) Экспорт
	
	Если ПустаяСтрока(Реквизиты) Тогда 
		ВызватьИсключение НСтр("ru = 'Неверный второй параметр ИменаРеквизитов: 
		                             |- Поле объекта должно быть указано'");
	КонецЕсли;
	
	Если СтрНайти(Реквизиты, ".") <> 0 Тогда 
		ВызватьИсключение НСтр("ru = 'Неверный второй параметр ИменаРеквизитов: 
		                             |- Обращение через точку не поддерживается'");
	КонецЕсли;
	
	ЗначенияРеквизитов = Новый Соответствие;
	Если Ссылки.Количество() = 0 Тогда
		Возврат ЗначенияРеквизитов;
	КонецЕсли;
	
	ИменаПолей = СтрРазделить(Реквизиты, ",", Ложь);
	Для Индекс = 0 По ИменаПолей.ВГраница() Цикл
		ИменаПолей[Индекс] = СокрЛП(ИменаПолей[Индекс]);
	КонецЦикла;	
	
	Схема = Новый СхемаЗапроса;
	ЗапросВыбора = Схема.ПакетЗапросов.Добавить();
	ОператорыТипа = Новый Соответствие;
	Для Каждого Ссылка Из Ссылки Цикл
		Если ОператорыТипа.Получить(ТипЗнч(Ссылка)) = Неопределено Тогда
			Если ОператорыТипа.Количество() = 0 Тогда
				// ОператорыСхемыЗапроса всегда содержит хотя бы один элемент.
				// Поэтому для первого типа используем существующий оператор.
				ОператорВыбрать = ЗапросВыбора.Операторы[0];
			Иначе	
				ОператорВыбрать = ЗапросВыбора.Операторы.Добавить();
			КонецЕсли;	
			ИсточникОператора = ОператорВыбрать.Источники.Добавить(Ссылка.Метаданные().ПолноеИмя(), "Таблица");
			ОператорВыбрать.ВыбираемыеПоля.Добавить("Ссылка");
			Для Каждого ИмяПоля Из ИменаПолей Цикл
				Поле = ИсточникОператора.Источник.ДоступныеПоля.Найти(ИмяПоля);
				Если Поле = Неопределено Тогда
					ВызватьИсключение  
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Неверный второй параметр ИменаРеквизитов:
							           |- В таблице ""%1"" поле ""%2"" не найдено'"), 
							ИсточникОператора.Источник.ИмяТаблицы, 
							ИмяПоля)
				КонецЕсли;	
				ОператорВыбрать.ВыбираемыеПоля.Добавить(Поле);
			КонецЦикла;	
			ОператорВыбрать.Отбор.Добавить("Таблица.Ссылка В (&Ссылки)");
			ОператорыТипа.Вставить(ТипЗнч(Ссылка), ОператорВыбрать); 
		КонецЕсли;	
	КонецЦикла;	
	ЗапросВыбора.ВыбиратьРазрешенные = Разрешенные;
	
	Запрос = Новый Запрос;
	Запрос.Текст = Схема.ПолучитьТекстЗапроса();
	Запрос.УстановитьПараметр("Ссылки", Ссылки);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Результат = Новый Структура(Реквизиты);
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
		ЗначенияРеквизитов[Выборка.Ссылка] = Результат;
	КонецЦикла;
	
	Возврат ЗначенияРеквизитов;
	
КонецФункции

// Значения реквизита, прочитанного из информационной базы для нескольких объектов.
//
//  Если необходимо зачитать реквизит независимо от прав текущего пользователя,
//  то следует использовать предварительный переход в привилегированный режим.
//
// Параметры:
//  Ссылки      - Массив - ссылки на объекты, значения реквизита которых нужно получить.
//                         Если массив пуст, то результатом будет пустое соответствие.
//  Реквизиты   - Строка - имя реквизита.
//  Разрешенные - Булево - если Истина, то будут получены реквизиты объектов, доступные по правам пользователя;
//                       - если Ложь, то возникнет исключение при отсутствии прав на объект или реквизит.
//
// Возвращаемое значение:
//  Соответствие - Ключ - ссылка на объект, Значение - значение прочитанного реквизита.
//      * Ключ     - ссылка на объект, 
//      * Значение - значение прочитанного реквизита.
// 
Функция ЗначениеРеквизитаОбъектов(Ссылки, Знач Реквизит, Разрешенные = Ложь) Экспорт
	
	Если ПустаяСтрока(Реквизит) Тогда 
		ВызватьИсключение НСтр("ru = 'Неверный второй параметр ИмяРеквизита: 
		                             |- Имя реквизита должно быть заполнено'");
	КонецЕсли;
	
	ЗначенияРеквизитов = ЗначенияРеквизитовОбъектов(Ссылки, Реквизит, Разрешенные);
	Для Каждого Элемент Из ЗначенияРеквизитов Цикл
		ЗначенияРеквизитов[Элемент.Ключ] = Элемент.Значение[Реквизит];
	КонецЦикла;
		
	Возврат ЗначенияРеквизитов;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функции для работы с прикладными типами и коллекциями значений.

// Преобразует коллекцию движений в структуру.
//
// Параметры:
//  Движения - КоллекцияДвижений, Структура - исходная коллекция движений документа.
// 
// Возвращаемое значение:
//  Структура - движения в виде структуры.
//
Функция ДвиженияВСтруктуру(Движения) Экспорт
	
	Структура = Новый Структура;
	
	Если ТипЗнч(Движения) = Тип("Структура") Тогда
		Структура = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(Движения);
	Иначе	
		Для Каждого НаборЗаписей Из Движения Цикл
			Структура.Вставить(НаборЗаписей.Метаданные().Имя, НаборЗаписей);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Структура
	
КонецФункции

// Помещает значения перечисления в массив.
//
// Параметры:
//  Перечисление     - ПеречислениеМенеджер        - исходное перечисление.
//	ИсключаяЗначения - Массив, ФиксированныйМассив - значения перечисления, не включаемые в результат.
// 
// Возвращаемое значение:
//  Массив - массив элементов типа ПеречислениеСсылка.
//
Функция ПеречислениеВМассив(Перечисление, Знач ИсключаяЗначения = Неопределено) Экспорт
	
	Если ИсключаяЗначения = Неопределено Тогда
		ИсключаяЗначения = Новый Массив;
	КонецЕсли;	
	
	ЗначенияПеречисления = Новый Массив;
	
	Для Каждого ЗначениеПеречисления Из Перечисление Цикл
		Если ИсключаяЗначения.Найти(ЗначениеПеречисления) = Неопределено Тогда
			ЗначенияПеречисления.Добавить(ЗначениеПеречисления);
		КонецЕсли;	
	КонецЦикла;	
	
	Возврат ЗначенияПеречисления
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для работы с типами, объектами метаданных и их строковыми представлениями.

// Возвращает менеджер объекта по типу.
// Ограничение: не обрабатываются точки маршрутов бизнес-процессов.
// См. так же МенеджерОбъектаПоПолномуИмени.
//
// Параметры:
//  Тип - Тип - тип объекта, менеджер которого требуется получить.
//
// Возвращаемое значение:
//  СправочникМенеджер, ДокументМенеджер, ОбработкаМенеджер, РегистрСведенийМенеджер - менеджер объекта.
//
// Пример:
//  МенеджерСправочника = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СсылкаНаОрганизацию);
//  ПустаяСсылка = МенеджерСправочника.ПустаяСсылка();
//
Функция МенеджерОбъектаПоТипу(Тип) Экспорт
	
	МетаданныеОбъекта = Метаданные.НайтиПоТипу(Тип);
	Если МетаданныеОбъекта = Неопределено Тогда
		Возврат Неопределено
	КонецЕсли;	
	
	ИмяОбъекта = МетаданныеОбъекта.Имя;
	
	Если Справочники.ТипВсеСсылки().СодержитТип(Тип) Тогда
		Возврат Справочники[ИмяОбъекта];
		
	ИначеЕсли Документы.ТипВсеСсылки().СодержитТип(Тип) Тогда
		Возврат Документы[ИмяОбъекта];
		
	ИначеЕсли БизнесПроцессы.ТипВсеСсылки().СодержитТип(Тип) Тогда
		Возврат БизнесПроцессы[ИмяОбъекта];
		
	ИначеЕсли ПланыВидовХарактеристик.ТипВсеСсылки().СодержитТип(Тип) Тогда
		Возврат ПланыВидовХарактеристик[ИмяОбъекта];
		
	ИначеЕсли ПланыСчетов.ТипВсеСсылки().СодержитТип(Тип) Тогда
		Возврат ПланыСчетов[ИмяОбъекта];
		
	ИначеЕсли ПланыВидовРасчета.ТипВсеСсылки().СодержитТип(Тип) Тогда
		Возврат ПланыВидовРасчета[ИмяОбъекта];
		
	ИначеЕсли Задачи.ТипВсеСсылки().СодержитТип(Тип) Тогда
		Возврат Задачи[ИмяОбъекта];
		
	ИначеЕсли ПланыОбмена.ТипВсеСсылки().СодержитТип(Тип) Тогда
		Возврат ПланыОбмена[ИмяОбъекта];
		
	ИначеЕсли Перечисления.ТипВсеСсылки().СодержитТип(Тип) Тогда
		Возврат Перечисления[ИмяОбъекта];
		
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает объекты, сгруппированные по их типам.
//
// Параметры:
//  Объекты - Массив - объекты, которые необходимо сгруппировать.
// 
// Возвращаемое значение:
//  Соответствие - в ключе тип, в значении массив объектов этого типа.
//
Функция ОбъектыПоТипам(Объекты) Экспорт
	
	ОбъектыПоТипам = Новый Соответствие;
	
	Для Каждого Объект Из Объекты Цикл
		ОбъектыТипа = ОбъектыПоТипам[ТипЗнч(Объект)];
		Если ОбъектыТипа = Неопределено Тогда
			ОбъектыТипа = Новый Массив;
			ОбъектыПоТипам.Вставить(ТипЗнч(Объект), ОбъектыТипа); 
		КонецЕсли;	
		ОбъектыТипа.Добавить(Объект)
	КонецЦикла;
	
	Возврат ОбъектыПоТипам
	
КонецФункции	

////////////////////////////////////////////////////////////////////////////////
// Функции для работы с табличными документами.

// Очищает параметры табличного документа
//
// Параметры:
//  ТабличныйДокумент   - ТабличныйДокумент - дополняемый табличный документ.
//
Процедура ОчиститьПараметрыТабличногоДокумента(ТабличныйДокумент) Экспорт
	
	Для Сч = 1 По ТабличныйДокумент.Параметры.Количество() Цикл
		ТабличныйДокумент.Параметры.Установить(Сч - 1, ""); 
	КонецЦикла;
	
КонецПроцедуры	
	
// Дополняет табличный документ переданной строкой до конца страницы так, 
// чтобы на странице уместился указанный подвал.
//
// Параметры:
//  ТабДокумент - ТабличныйДокумент - дополняемый табличный документ.
//  Строка      - ТабличныйДокумент - строка, которой дополняется документ. 
//  Подвал      - Массив, ТабличныйДокумент - подвал, которым должна закончиться страница. 
//
// Возвращаемое значение:
//   Число   - количество добавленных строк.
//
Функция ДополнитьСтраницуТабличногоДокумента(ТабличныйДокумент, Строка, Подвал = Неопределено) Экспорт

	ДобавленоСтрок = 0;
	
	ВыводимыеОбласти = Новый Массив();
	ВыводимыеОбласти.Добавить(Строка);
	Если Подвал <> Неопределено Тогда
		Если ТипЗнч(Подвал) = Тип("Массив") Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ВыводимыеОбласти, Подвал)
		Иначе
			ВыводимыеОбласти.Добавить(Подвал)
		КонецЕсли;	
	КонецЕсли;	
	
	Пока ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ВыводимыеОбласти, Ложь) И ДобавленоСтрок < ТабличныйДокумент.ВысотаСтраницы Цикл
		ТабличныйДокумент.Вывести(Строка);
		ДобавленоСтрок = ДобавленоСтрок + 1;
	КонецЦикла;

	Возврат ДобавленоСтрок
	
КонецФункции 

// Возвращает таблицу значений с колонками, соответствующими структуре регистра накопления
// Параметры
//		ИмяРегистра - Строка, имя регистра накопления.
//
// Возвращаемое значение:
//   Таблица значений
//
Функция ТаблицаЗначенийПоИмениРегистраНакопления(ИмяРегистра) Экспорт
	
	ТаблицаЗначенийРегистраНакопления = Новый ТаблицаЗначений;
	ТаблицаЗначенийРегистраНакопления.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	МетаданныеРегистра = Метаданные.РегистрыНакопления[ИмяРегистра];
	
	// Измерения
	Для Каждого Измерение Из МетаданныеРегистра.Измерения Цикл
		ТаблицаЗначенийРегистраНакопления.Колонки.Добавить(Измерение.Имя, Измерение.Тип);
	КонецЦикла;
	
	// Ресурсы
	Для Каждого Ресурс Из МетаданныеРегистра.Ресурсы Цикл
		ТаблицаЗначенийРегистраНакопления.Колонки.Добавить(Ресурс.Имя, Ресурс.Тип);
	КонецЦикла;
	
	// Реквизиты
	Для Каждого Реквизит Из МетаданныеРегистра.Реквизиты Цикл
		ТаблицаЗначенийРегистраНакопления.Колонки.Добавить(Реквизит.Имя, Реквизит.Тип);
	КонецЦикла;
	
	Возврат ТаблицаЗначенийРегистраНакопления;
	
КонецФункции

#КонецОбласти
