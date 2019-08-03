////////////////////////////////////////////////////////////////////////////////
// Подсистема "КонфигурацииЗарплатаКадрыРасширенный".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ПереопределениеМетодовОбщегоМодуляОбновлениеКонфигурацииПереопределяемый

// Определяет короткое имя (идентификатор) конфигурации.
//
// Параметры:
//	КраткоеИмя - Строка- короткое имя конфигурации.
//
Процедура ПриОпределенииКраткогоИмениКонфигурации(КраткоеИмя) Экспорт
	
	ЕстьУчетБюджетныхУчреждений = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.УчетБюджетныхУчреждений");
	ЕстьУчетХозрасчетныхОрганизаций = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.УчетХозрасчетныхОрганизаций");
	Если ЕстьУчетБюджетныхУчреждений И ЕстьУчетХозрасчетныхОрганизаций Тогда
		Если ПолучитьФункциональнуюОпцию("РаботаВХозрасчетнойОрганизации") Тогда
			Модуль = ОбщегоНазначения.ОбщийМодуль("УчетХозрасчетныхОрганизаций");
			Модуль.ПриОпределенииКраткогоИмениКонфигурации(КраткоеИмя);
		Иначе
			Модуль = ОбщегоНазначения.ОбщийМодуль("УчетБюджетныхУчреждений");
			Модуль.ПриОпределенииКраткогоИмениКонфигурации(КраткоеИмя);
		КонецЕсли;
	ИначеЕсли ЕстьУчетБюджетныхУчреждений Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("УчетБюджетныхУчреждений");
		Модуль.ПриОпределенииКраткогоИмениКонфигурации(КраткоеИмя);
	ИначеЕсли ЕстьУчетХозрасчетныхОрганизаций Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("УчетХозрасчетныхОрганизаций");
		Модуль.ПриОпределенииКраткогоИмениКонфигурации(КраткоеИмя);
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПереопределениеМетодовОбщегоМодуляОбновлениеКонфигурацииПереопределяемый

// Уточняет сокращенное наименование конфигурации для вывода в заголовках и декорациях.
//
// Параметры:
//  СокращенноеНаименование - Строка - неявно возвращаемое значение, краткое название конфигурации.
//
// Пример:
//  СокращенноеНаименование = НСтр("ru = '1С:ЗУП КОРП'");
//
Процедура ПриОпределенииСокращенногоНаименованияКонфигурации(СокращенноеНаименование) Экспорт
	
	СокращенноеНаименование = КраткоеНазваниеПрограммы() + " " + Лев(Метаданные.Версия, 3);
	
КонецПроцедуры

#КонецОбласти

#Область НастройкиПользователей

// Переопределяет настройки интерфейса, устанавливаемые для новых пользователей.
// Подробнее см. ПользователиПереопределяемый.ПриУстановкеНачальныхНастроек.
//
Процедура ПриУстановкеНачальныхНастроек(НачальныеНастройки) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЗарплатаКадрыКорпоративнаяПодсистемы") Тогда
		// При большем количестве подсистем, не меняем вертикального расположения разделов.
		Возврат;
	КонецЕсли;
	
	// Устанавливаем горизонтальное расположение разделов.
	Если НачальныеНастройки.НастройкиТакси <> Неопределено Тогда
		НачальныеНастройки.НастройкиТакси = Новый НастройкиИнтерфейсаКлиентскогоПриложения;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПереопределениеМетодовОбщегоМодуляРегламентированнаяОтчетностьПереопределяемый

// Функция возвращает идентификатор конфигурации.
// Длина идентификатора не должна превышать 8 символов.
//
// Пример:
//  Возврат "БПКОРП";
//
Функция ИДКонфигурации() Экспорт
	
	ЕстьУчетБюджетныхУчреждений = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.УчетБюджетныхУчреждений");
	ЕстьУчетХозрасчетныхОрганизаций = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.УчетХозрасчетныхОрганизаций");
	Если ЕстьУчетБюджетныхУчреждений И ЕстьУчетХозрасчетныхОрганизаций Тогда
		Возврат "";
	ИначеЕсли ЕстьУчетБюджетныхУчреждений Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("УчетБюджетныхУчреждений");
		Возврат Модуль.ИДКонфигурации();
	ИначеЕсли ЕстьУчетХозрасчетныхОрганизаций Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("УчетХозрасчетныхОрганизаций");
		Возврат Модуль.ИДКонфигурации();
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

// Функция возвращает краткое название конфигурации.
// Длина возвращаемого значения не должна превышать 30 символов.
//
// Пример:
//  Возврат "1С:Бухгалтерия";
//
Функция КраткоеНазваниеПрограммы() Экспорт
	Постфикс = "";
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы") Тогда
		Постфикс = " КОРП";
	КонецЕсли;
	Возврат "1С:" + ИДКонфигурации() + Постфикс;
КонецФункции

// Процедура возвращает УИД конфигурации для целей регламентированной отчетности.
//
// Параметры:
// 	УИДКонфигурации - Строка - Уникальный идентификатор конфигурации 
//							   для целей регламентированной отчетности.
//
// Пример:
//  УИДКонфигурации = "e54b72a0-171f-11df-85fa-001b24e002fe";
//
Процедура ПолучитьУИДКонфигурации(УИДКонфигурации) Экспорт
	
	ЕстьУчетБюджетныхУчреждений = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.УчетБюджетныхУчреждений");
	ЕстьУчетХозрасчетныхОрганизаций = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.УчетХозрасчетныхОрганизаций");
	Если ЕстьУчетБюджетныхУчреждений И ЕстьУчетХозрасчетныхОрганизаций Тогда
		Если ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении") Тогда
			УИДКонфигурации = "bd688976-15b9-11e1-82b8-001b24e002fe";
		Иначе
			УИДКонфигурации = "4759bb58-0ce1-11df-85fa-001b24e002fe";
		КонецЕсли;
	ИначеЕсли ЕстьУчетБюджетныхУчреждений Тогда
		УИДКонфигурации = "bd688976-15b9-11e1-82b8-001b24e002fe";
	ИначеЕсли ЕстьУчетХозрасчетныхОрганизаций Тогда
		УИДКонфигурации = "4759bb58-0ce1-11df-85fa-001b24e002fe";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область НастройкиВариантовОтчетов

// Определяет разделы, в которых доступна панель отчетов.
//
// Параметры:
//   Разделы (Массив) из (ОбъектМетаданных).
//
// Описание:
//   В Разделы необходимо добавить метаданные тех разделов,
//   в которых размещены команды вызова панелей отчетов.
//
// Например:
//	Разделы.Добавить(Метаданные.Подсистемы.ИмяПодсистемы);
//
Процедура ОпределитьРазделыСВариантамиОтчетов(Разделы) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.Грейды") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("Грейды");
		Модуль.ОпределитьРазделыСВариантамиОтчетов(Разделы);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ПодборПерсонала") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ПодборПерсонала");
		Модуль.ОпределитьРазделыСВариантамиОтчетов(Разделы);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КадровыйРезерв") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("КадровыйРезерв");
		Модуль.ОпределитьРазделыСВариантамиОтчетов(Разделы);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.КлючевыеПоказателиЭффективности") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("КлючевыеПоказателиЭффективности");
		Модуль.ОпределитьРазделыСВариантамиОтчетов(Разделы);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЛьготыСотрудников") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЛьготыСотрудников");
		Модуль.ОпределитьРазделыСВариантамиОтчетов(Разделы);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОбучениеРазвитие") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбучениеРазвитие");
		Модуль.ОпределитьРазделыСВариантамиОтчетов(Разделы);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОхранаТруда") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОхранаТруда");
		Модуль.ОпределитьРазделыСВариантамиОтчетов(Разделы);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОценкаПерсонала") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОценкаПерсонала");
		Модуль.ОпределитьРазделыСВариантамиОтчетов(Разделы);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.МедицинскоеСтрахование") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("МедицинскоеСтрахование");
		Модуль.ОпределитьРазделыСВариантамиОтчетов(Разделы);
	КонецЕсли;
	
КонецПроцедуры

// Содержит настройки размещения вариантов отчетов в панели отчетов.
// Описание см. ЗарплатаКадрыВариантыОтчетов.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.Грейды") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("Грейды");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ПодборПерсонала") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ПодборПерсонала");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КадровыйРезерв") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("КадровыйРезерв");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.КлючевыеПоказателиЭффективности") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("КлючевыеПоказателиЭффективности");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЛьготыСотрудников") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЛьготыСотрудников");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОбучениеРазвитие") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбучениеРазвитие");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОхранаТруда") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОхранаТруда");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОценкаПерсонала") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОценкаПерсонала");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.АдаптацияУвольнение") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("АдаптацияУвольнение");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.АнализТекучестиПерсонала") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("АнализТекучестиПерсонала");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОбучениеРазвитие.ЭлектронноеОбучениеВХО") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЭлектронноеОбучениеЗарплатаКадрыРасширенный");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЭлектронноеОбучение") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЭлектронноеОбучение");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.Чатботы") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("Чатботы");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.МедицинскоеСтрахование") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("МедицинскоеСтрахование");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Новости

Процедура ПриПолученииЗначенияПредопределеннойКатегорииНовостей(КраткоеИмя) Экспорт

	ПриОпределенииКраткогоИмениКонфигурации(КраткоеИмя);
		
КонецПроцедуры

#КонецОбласти

#Область УправлениеДоступом

Процедура ЗаполнитьПоставляемыеПрофилиГруппДоступа(ОписанияПрофилей, ПараметрыОбновления) Экспорт 

	ОписаниеПрофиля = ОписаниеПрофиляУправлениеДатамиЗапретаИзменения();
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
	
КонецПроцедуры

// Возвращает описание профиля "Управление датами запрета изменения".
//
Функция ОписаниеПрофиляУправлениеДатамиЗапретаИзменения() Экспорт
	
	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Идентификатор = ИдентификаторПрофиляУправлениеДатамиЗапретаИзменения();
	ОписаниеПрофиля.Наименование  = НСтр("ru = 'Управление датами запрета изменения'");
	
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ДобавлениеИзменениеДатЗапретаИзменения");
	
	Возврат ОписаниеПрофиля;
	
КонецФункции

Функция ИдентификаторПрофиляУправлениеДатамиЗапретаИзменения() Экспорт
	Возврат "a40f367d-e603-4cfb-a5d6-63acc4cde883";
КонецФункции

Процедура СоздатьГруппуДоступаУправленияДатамиЗапретаИзменения() Экспорт
	
	Профиль = УправлениеДоступом.ПоставляемыйПрофильПоИдентификатору(ИдентификаторПрофиляУправлениеДатамиЗапретаИзменения());
	Если ЗначениеЗаполнено(Профиль) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ГруппыДоступа.Ссылка
			|ИЗ
			|	Справочник.ГруппыДоступа КАК ГруппыДоступа
			|ГДЕ
			|	ГруппыДоступа.Профиль = &Профиль
			|
			|УПОРЯДОЧИТЬ ПО
			|	ГруппыДоступа.ПометкаУдаления";
		
		Запрос.УстановитьПараметр("Профиль", Профиль);
		
		РезультатЗапроса = Запрос.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			
			// Создание новой группы.
			ГруппаДоступаОбъект = Справочники.ГруппыДоступа.СоздатьЭлемент();
			
			ГруппаДоступаОбъект.Наименование	= НСтр("ru='Управление датами запрета изменения'");
			ГруппаДоступаОбъект.Профиль			= Профиль;
			
			ГруппаДоступаОбъект.ОбменДанными.Загрузка = Истина;
			ГруппаДоступаОбъект.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// Предназначена для определения необходимости использования структуры предприятия для отражения в учете.
//
// Параметры: 
//	Использование - тип булево
//
Процедура ОпределитьИспользованиеСтруктурыПредприятияДляОтраженияВРегламентированномУчете(Использование) Экспорт
	
	ИспользуетсяОбменУправлениеПредприятием2 = Ложь;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОрганизационнаяСтруктура");
		ИспользуетсяОбменУправлениеПредприятием2 = Модуль.ИспользуетсяОбменУправлениеПредприятием2();
	КонецЕсли;
	
	Если ИспользуетсяОбменУправлениеПредприятием2 Тогда
		Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
	
	// При переходе на КОРП вариант поставки..
	ПриПереходеНаКОРПВариантПоставки(Обработчики);
	
КонецПроцедуры

Процедура ПриПереходеНаКОРПВариантПоставки(Обработчики)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы") Тогда
		Возврат;
	КонецЕсли;
	
	// Перечисляются имена обработчиков, которые необходимо выполнить при переходе на КОРП вариант поставки с других программ.
	ИменаОбработчиков = Новый Массив;
	ИменаОбработчиков.Добавить("ОбновлениеИнформационнойБазыЗарплатаКадрыРасширенный.УстановитьИспользованиеЗарплатаКадрыКорпоративнаяПодсистемы");
	
	// Регистрируем обработчики для всех предыдущих программ, с которых поддерживается обновление на КОРП вариант поставки.
	ИменаПредыдущихКонфигураций = Новый Массив;
	ИменаПредыдущихКонфигураций.Добавить("ЗарплатаИУправлениеПерсоналом");
	ИменаПредыдущихКонфигураций.Добавить("ЗарплатаИКадрыГосударственногоУчреждения");
	ИменаПредыдущихКонфигураций.Добавить("БЗКР");
	
	Для Каждого ПредыдущееИмяКонфигурации Из ИменаПредыдущихКонфигураций Цикл
		Для Каждого ИмяОбработчика Из ИменаОбработчиков Цикл
			Обработчик = Обработчики.Добавить();
			Обработчик.ПредыдущееИмяКонфигурации = ПредыдущееИмяКонфигурации;
			Обработчик.Процедура = ИмяОбработчика;
		КонецЦикла;
	КонецЦикла;
	
	// Выбираем обработчики начального заполнения вновь добавленных подсистем.
	ВсеОбработчики = ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления();
	СобратьОбработчикиКОРППодсистем(ВсеОбработчики);
	ОбработчикиНачальногоЗаполнения = ВсеОбработчики.НайтиСтроки(Новый Структура("НачальноеЗаполнение", Истина));
	Для Каждого ПредыдущееИмяКонфигурации Из ИменаПредыдущихКонфигураций Цикл
		Для Каждого ОбработчикНачальногоЗаполнения Из ОбработчикиНачальногоЗаполнения Цикл
			Обработчик = Обработчики.Добавить();
			Обработчик.ПредыдущееИмяКонфигурации = ПредыдущееИмяКонфигурации;
			Обработчик.Процедура = ОбработчикНачальногоЗаполнения.Процедура;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура СобратьОбработчикиКОРППодсистем(Обработчики)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.АдаптацияУвольнение") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("АдаптацияУвольнение");
		Модуль.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.АттестацииСотрудников") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("АттестацииСотрудников");
		Модуль.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.Грейды") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("Грейды");
		Модуль.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КадровыйРезерв") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("КадровыйРезерв");
		Модуль.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.КлючевыеПоказателиЭффективности") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("КлючевыеПоказателиЭффективности");
		Модуль.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЛьготыСотрудников") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЛьготыСотрудников");
		Модуль.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОперацииРасчетаЗарплаты") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОперацииРасчетаЗарплаты");
		Модуль.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОрганизационнаяСтруктура");
		Модуль.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОхранаТруда") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОхранаТруда");
		Модуль.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ПодборПерсонала") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ПодборПерсонала");
		Модуль.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.СамообслуживаниеСотрудников") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("СамообслуживаниеСотрудников");
		Модуль.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("УправленческаяЗарплата");
		Модуль.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЦепочкиДокументов") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЦепочкиДокументов");
		Модуль.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЭлектронноеОбучение") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбновлениеИнформационнойБазыБЭО");
		Модуль.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.АнализТекучестиПерсонала") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("АнализТекучестиПерсонала");
		Модуль.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.Чатботы") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("Чатботы");
		Модуль.ЗарегистрироватьОбработчикиОбновления(Обработчики);
	КонецЕсли;
		
КонецПроцедуры

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Если НЕ СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "3.1.2.48";
		Обработчик.Процедура = "КонфигурацииЗарплатаКадрыРасширенный.СоздатьГруппуДоступаУправленияДатамиЗапретаИзменения";
	КонецЕсли;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.3.157";
	Обработчик.Процедура = "КонфигурацииЗарплатаКадрыРасширенный.ЗаписатьПрисоединенныеФайлыБРО";
	Обработчик.РежимВыполнения = "Монопольно";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.4.20";
	Обработчик.Процедура = "КонфигурацииЗарплатаКадрыРасширенный.УстановитьПараметрыНабораСвойствСправочников";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("c33320c8-a8ff-4fcb-aaac-ec664ff2ab6d");
	Обработчик.Комментарий = НСтр("ru = 'Установка параметров для набора свойств общих справочников. Дополнительные реквизиты временно недоступны.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.4.38";
	Обработчик.РежимВыполнения = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ОсновнойРежимВыполненияОбновления();
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("7a5825e6-e814-4aad-be89-2d5889ab2a95");
	Обработчик.Процедура = "КонфигурацииЗарплатаКадрыРасширенный.ПеренестиФайлыОрганизацииВОтдельныйСправочник";
	
КонецПроцедуры

Процедура ЗаписатьПрисоединенныеФайлыБРО(ПараметрыОбновления = Неопределено) Экспорт

	Выборка = Справочники.ПерепискаСКонтролирующимиОрганамиПрисоединенныеФайлы.Выбрать();
	Пока Выборка.Следующий() Цикл
		Выборка.Ссылка.ПолучитьОбъект().Записать();
	КонецЦикла;
	Выборка = Справочники.ТранспортноеСообщениеКонтейнерыПрисоединенныеФайлы.Выбрать();
	Пока Выборка.Следующий() Цикл
		Выборка.Ссылка.ПолучитьОбъект().Записать();
	КонецЦикла;
	Выборка = Справочники.ТранспортноеСообщениеПрисоединенныеФайлы.Выбрать();
	Пока Выборка.Следующий() Цикл
		Выборка.Ссылка.ПолучитьОбъект().Записать();
	КонецЦикла;

КонецПроцедуры

Процедура УстановитьПараметрыНабораСвойствСправочников(ПараметрыОбновления = НеОпределено) Экспорт
	
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Справочник_Кассы", УправлениеСвойствами.СтруктураПараметровНабораСвойств());
	
	Если ПараметрыОбновления <> Неопределено Тогда
		ПараметрыОбновления.ОбработкаЗавершена = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПеренестиФайлыОрганизацииВОтдельныйСправочник(ПараметрыОбновления = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1000
		|	Файлы.Ссылка КАК Файл,
		|	Файлы.ВладелецФайла КАК ВладелецФайла,
		|	Файлы.ДатаСоздания КАК ДатаСоздания
		|ИЗ
		|	Справочник.Файлы КАК Файлы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
		|		ПО Файлы.ВладелецФайла = Организации.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОрганизацииПрисоединенныеФайлы КАК ОрганизацииПрисоединенныеФайлы
		|		ПО Файлы.ВладелецФайла = ОрганизацииПрисоединенныеФайлы.ВладелецФайла
		|			И Файлы.Наименование = ОрганизацииПрисоединенныеФайлы.Наименование
		|			И Файлы.Автор = ОрганизацииПрисоединенныеФайлы.Автор
		|			И Файлы.ДатаСоздания = ОрганизацииПрисоединенныеФайлы.ДатаСоздания
		|			И Файлы.Размер = ОрганизацииПрисоединенныеФайлы.Размер
		|			И Файлы.Расширение = ОрганизацииПрисоединенныеФайлы.Расширение
		|ГДЕ
		|	ОрганизацииПрисоединенныеФайлы.Ссылка ЕСТЬ NULL";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Попытка
				ДанныеФайлаИДвоичныеДанные = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаИДвоичныеДанные(Выборка.Файл);
			Исключение
				Продолжить;
			КонецПопытки;
			
			ДанныеФайла = ДанныеФайлаИДвоичныеДанные.ДанныеФайла;
			ДвоичныеДанные = ДанныеФайлаИДвоичныеДанные.ДвоичныеДанные;
			
			Если ДвоичныеДанные = Неопределено Тогда 
				Продолжить;
			КонецЕсли;
			
			ОбъектФайла = Справочники.ОрганизацииПрисоединенныеФайлы.СоздатьЭлемент();
			
			ЗаполнитьЗначенияСвойств(ОбъектФайла, ДанныеФайла, , "Ссылка,Владелец");
			ОбъектФайла.ВладелецФайла = Выборка.ВладелецФайла;
			ОбъектФайла.ДатаСоздания = Выборка.ДатаСоздания;
			ОбъектФайла.ФайлХранилище = Новый ХранилищеЗначения(ДвоичныеДанные);
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектФайла);
			
		КонецЦикла;
		
	Иначе
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
