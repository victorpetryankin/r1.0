#Область ПрограммныйИнтерфейс

// Открывает форму установки обновлений с указанными параметрами.
//
// Параметры:
//    ПараметрыУстановкиОбновлений - Структура - Дополнительные параметры установки обновлений:
//     * ЗавершениеРаботыСистемы - Булево - Истина, если после установки обновления работа программы завершается. 
//                                          По умолчанию, Ложь.
//     * ПолученоОбновлениеКонфигурации - Булево - Истина, если устанавливаемое обновление получено из приложения 
//                                          в Интернете. По умолчанию, Ложь - обычный режим установки обновления.
//     * ВыполнитьОбновление     - Булево - Истина, если необходимо пропустить выбор файла обновления и сразу перейти
//                                          к установке обновления. По умолчанию, Ложь - предлагать выбор.
//
Процедура ПоказатьПоискИУстановкуОбновлений(ПараметрыУстановкиОбновлений = Неопределено) Экспорт
	
	ОткрытьФорму("Обработка.УстановкаОбновлений.Форма.Форма", ПараметрыУстановкиОбновлений);
	
КонецПроцедуры

// Отображает форму настроек создания резервной копии.
//
// Параметры:
//    ПараметрыРезервногоКопирования - Структура - Параметры формы резервного копирования.
//      * СоздаватьРезервнуюКопию - Число - 0, Не создавать резервную копию ИБ.
//                                          1, Создавать временную резервную копию ИБ.
//                                          2, Создавать резервную копию ИБ
//      * ИмяКаталогаРезервнойКопииИБ - Строка - Каталог сохранения резервной копии.
//      * ВосстанавливатьИнформационнуюБазу - Булево - Выполнять откат при нештатной ситуации.
//    ОписаниеОповещения - ОписаниеОповещения - Описание оповещения о закрытии формы.
//
Процедура ПоказатьРезервноеКопирование(ПараметрыРезервногоКопирования, ОписаниеОповещения) Экспорт
	
	ОткрытьФорму("Обработка.УстановкаОбновлений.Форма.НастройкаРезервнойКопии", ПараметрыРезервногоКопирования,,,,, ОписаниеОповещения);
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы

// Возвращает текст заголовка настроек резервного копирования для отображения на форме.
//
// Параметры:
//    Параметры - Структура - Параметры резервного копирования.
//
// Возвращаемое значение:
//    Строка - Заголовок гиперссылки создания резервной копии.
//
Функция ЗаголовокСозданияРезервнойКопии(Параметры) Экспорт
	
	Если Параметры.СоздаватьРезервнуюКопию = 0 Тогда
		Результат = НСтр("ru = 'Не создавать резервную копию ИБ'");
	ИначеЕсли Параметры.СоздаватьРезервнуюКопию = 1 Тогда
		Результат = НСтр("ru = 'Создавать временную резервную копию ИБ'");
	ИначеЕсли Параметры.СоздаватьРезервнуюКопию = 2 Тогда
		Результат = НСтр("ru = 'Создавать резервную копию ИБ'");
	КонецЕсли;
	
	Если Параметры.ВосстанавливатьИнформационнуюБазу Тогда
		Результат = Результат + " " + НСтр("ru = 'и выполнять откат при нештатной ситуации'");
	Иначе
		Результат = Результат + " " + НСтр("ru = 'и не выполнять откат при нештатной ситуации'");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Проверяет возможность установки обновления. Если возможно, то запускает
// скрипт обновления или планирует обновление на указанное время.
//
// Параметры:
//    Форма - УправляемаяФорма - Форма, из которой устанавливается обновление и которая должна быть закрыта в конце. 
//    Параметры - Структура - Параметры установки обновления:
//        * РежимОбновления - Число - Вариант установки обновления. Принимаемые значения:
//                                    0 - сейчас, 1 - при завершении работы, 2 - планирование обновления.
//        * ДатаВремяОбновления - Дата - Дата планируемого обновления.
//        * ВыслатьОтчетНаПочту - Булево - Признак необходимости отправки отчета на почту.
//        * АдресЭлектроннойПочты - Строка - Адрес электронной почты для отправки обновления.
//        * КодЗадачиПланировщика - Число - Код задачи запланированного обновления.
//        * ИмяФайлаОбновления - Строка - Имя файла устанавливаемого обновления.
//        * СоздаватьРезервнуюКопию - Число - Признак необходимости создания резервной копии.
//        * ИмяКаталогаРезервнойКопииИБ - Строка - Каталог сохранения резервной копии.
//        * ВосстанавливатьИнформационнуюБазу - Булево - Признак необходимости восстановления базы.
//        * ЗавершениеРаботыСистемы - Булево - Признак того, что установка обновления происходит при завершении работы.
//        * ФайлыОбновления - Массив - Содержит значения типа Структура.
//    ПараметрыАдминистрирования - Структура - См. СтандартныеПодсистемыСервер.ПараметрыАдминистрирования.
//
Процедура УстановитьОбновление(Форма, Параметры, ПараметрыАдминистрирования) Экспорт
	
	Если Не ВозможнаУстановкаОбновления(Параметры, ПараметрыАдминистрирования) Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.РежимОбновления = 0 Тогда // Обновить сейчас
		ПараметрыПриложения.Вставить("СтандартныеПодсистемы.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы", Истина);
		ЗавершитьРаботуСистемы(Ложь);
		ЗапуститьСкриптОбновления(Параметры, ПараметрыАдминистрирования);
	ИначеЕсли Параметры.РежимОбновления = 1 Тогда // При завершении работы
		ИмяПараметра = "СтандартныеПодсистемы.ПредлагатьОбновлениеИнформационнойБазыПриЗавершенииСеанса";
		ПараметрыПриложения.Вставить(ИмяПараметра, Истина);
		ПараметрыПриложения.Вставить("СтандартныеПодсистемы.ИменаФайловОбновления", ИменаФайловОбновления(Параметры));
	ИначеЕсли Параметры.РежимОбновления = 2 Тогда // Запланировать обновление
		ЗапланироватьОбновлениеКонфигурации(Параметры, ПараметрыАдминистрирования);
	КонецЕсли;
	
	ОбновлениеКонфигурацииВызовСервера.СохранитьНастройкиОбновленияКонфигурации(Параметры);
	
	Если Форма <> Неопределено Тогда
		Форма.Закрыть();
	КонецЕсли;
	
КонецПроцедуры

// Конец ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Обновляет конфигурацию базы данных.
//
// Параметры:
//  СтандартнаяОбработка - Булево - если в процедуре установить данному параметру значение Ложь, то инструкция по
//                                  "ручному" обновлению показана не будет.
Процедура УстановитьОбновлениеКонфигурации(ЗавершениеРаботыСистемы = Ложь) Экспорт
	
	ПараметрыФормы = Новый Структура("ЗавершениеРаботыСистемы, ПолученоОбновлениеКонфигурации",
		ЗавершениеРаботыСистемы, ЗавершениеРаботыСистемы);
	ПоказатьПоискИУстановкуОбновлений(ПараметрыФормы);
	
КонецПроцедуры

// Записывает в каталог скрипта файл-маркер ошибки.
//
Процедура ЗаписатьФайлПротоколаОшибки(КаталогСкрипта) Экспорт
	
#Если Не ВебКлиент Тогда
	ФайлРегистрации = Новый ЗаписьТекста(КаталогСкрипта + "error.txt");
	ФайлРегистрации.Закрыть();
#КонецЕсли
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы.
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	ПроверитьОбновлениеКонфигурации();
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередЗавершениемРаботыСистемы.
Процедура ПередЗавершениемРаботыСистемы(Отказ, Предупреждения) Экспорт
	
	// Предупреждение: при выставлении своего флажка подсистема "Обновление конфигурации" очищает список
	// всех ранее добавленных предупреждений.
	Если ПараметрыПриложения["СтандартныеПодсистемы.ПредлагатьОбновлениеИнформационнойБазыПриЗавершенииСеанса"] = Истина Тогда
		ПараметрыПредупреждения = СтандартныеПодсистемыКлиент.ПредупреждениеПриЗавершенииРаботы();
		ПараметрыПредупреждения.ТекстФлажка  = НСтр("ru = 'Установить обновление конфигурации'");
		ПараметрыПредупреждения.ТекстПредупреждения  = НСтр("ru = 'Запланирована установка обновления'");
		ПараметрыПредупреждения.Приоритет = 50;
		ПараметрыПредупреждения.ВывестиОдноПредупреждение = Истина;
		
		ДействиеПриУстановленномФлажке = ПараметрыПредупреждения.ДействиеПриУстановленномФлажке;
		ДействиеПриУстановленномФлажке.Форма = "Обработка.УстановкаОбновлений.Форма.Форма";
		ДействиеПриУстановленномФлажке.ПараметрыФормы = Новый Структура("ЗавершениеРаботыСистемы, ВыполнитьОбновление", Истина, Истина);
		
		Предупреждения.Добавить(ПараметрыПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьРезультатОбновления(РезультатОбновления, КаталогСкрипта) Экспорт
	
	Если СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ЭтоБазоваяВерсияКонфигурации Тогда
		
		Если ПустаяСтрока(КаталогСкрипта) Тогда
			ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(),
				"Предупреждение",
				НСтр("ru = 'Обновление выполнено с очень старой версии программы. 
				           |Данные журнала обновления не были загружены, но сам журнал 
				           |можно найти в папке временных файлов %temp% - 
				           |в папке вида 1Cv8Update.<xxxxxxxx>(цифры).'"),
				, 
				Истина);
				
			РезультатОбновления = Истина; // считаем обновление успешным.
		Иначе 
			ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(),
				"Информация", 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Папка с журналом обновления расположена %1'"), КаталогСкрипта),
				,
				Истина);
			
			ПрочитатьДанныеВЖурналРегистрации(РезультатОбновления, КаталогСкрипта);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВозможнаУстановкаОбновления(Параметры, ПараметрыАдминистрирования)
	
	ЭтоФайловаяБаза = ОбщегоНазначенияКлиент.ИнформационнаяБазаФайловая();
	
	Если ЭтоФайловаяБаза И Параметры.СоздаватьРезервнуюКопию = 2 Тогда
		Файл = Новый Файл(Параметры.ИмяКаталогаРезервнойКопииИБ);
		Если Не Файл.Существует() Или Не Файл.ЭтоКаталог() Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Укажите существующий каталог для сохранения резервной копии ИБ.'"));
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.РежимОбновления = 0 Тогда // Обновить сейчас
		ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
		Если ЭтоФайловаяБаза И ОбновлениеКонфигурацииВызовСервера.НаличиеАктивныхСоединений(ПараметрыПриложения[ИмяПараметра]) Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Невозможно продолжить обновление конфигурации, так как не завершены все соединения с информационной базой.'"));
			Возврат Ложь;
		КонецЕсли;
	ИначеЕсли Параметры.РежимОбновления = 2 Тогда
		Если Не ДатаОбновленияУказанаВерно(Параметры) Тогда
			Возврат Ложь;
		КонецЕсли;
		Если Параметры.ВыслатьОтчетНаПочту
			И Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(Параметры.АдресЭлектроннойПочты) Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Укажите допустимый адрес электронной почты.'"));
			Возврат Ложь;
		КонецЕсли;
		Если Не ПоддерживаетсяПланировщикЗаданий() Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Планировщик заданий поддерживается только начиная с операционной системы версии 6.0 Vista.'"));
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура ЗапуститьСкриптОбновления(Параметры, ПараметрыАдминистрирования)
	
	ИмяГлавногоФайлаСкрипта = СформироватьФайлыСкриптаОбновления(Истина, Параметры, ПараметрыАдминистрирования);
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Информация",
		НСтр("ru = 'Выполняется процедура обновления конфигурации:'") + " " + ИмяГлавногоФайлаСкрипта);
	ОбновлениеКонфигурацииВызовСервера.ЗаписатьСтатусОбновления(ИмяПользователя(), Истина, Ложь, Ложь,
		ИмяГлавногоФайлаСкрипта, ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"]);
		
	Оболочка = Новый COMОбъект("Wscript.Shell");
	Оболочка.RegWrite("HKCU\Software\Microsoft\Internet Explorer\Styles\MaxScriptStatements", 1107296255, "REG_DWORD");
	
	ПутьКПрограммеЗапуска = СтандартныеПодсистемыКлиент.ПапкаСистемныхПриложений() + "mshta.exe";
	
	СтрокаЗапуска = """%1"" ""%2"" [p1]%3[/p1][p2]%4[/p2]";
	СтрокаЗапуска = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗапуска,
		ПутьКПрограммеЗапуска, ИмяГлавногоФайлаСкрипта,
		СтрокаUnicode(ПараметрыАдминистрирования.ПарольАдминистратораИнформационнойБазы),
		СтрокаUnicode(ПараметрыАдминистрирования.ПарольАдминистратораКластера));
		
	ОбщегоНазначенияКлиентСервер.ЗапуститьПрограмму(СтрокаЗапуска);
	
КонецПроцедуры

Функция ПоддерживаетсяПланировщикЗаданий()
	
	// Планировщик заданий поддерживается начиная с версии 6.0 - Windows Vista.
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	
	ПозицияТочки = СтрНайти(СистемнаяИнформация.ВерсияОС, ".");
	Если ПозицияТочки < 2 Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	НомерВерсии = Сред(СистемнаяИнформация.ВерсияОС, ПозицияТочки - 2, 2);
	
	ОписаниеТипаЧисло = Новый ОписаниеТипов("Число");
	ВерсияВышеVista = ОписаниеТипаЧисло.ПривестиЗначение(НомерВерсии) >= 6;
	
	Возврат ВерсияВышеVista;
	
КонецФункции

Функция ДатаОбновленияУказанаВерно(Параметры)
	
	ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	Если Параметры.ДатаВремяОбновления < ТекущаяДата Тогда
		ТекстСообщения = НСтр("ru = 'Обновление конфигурации может быть запланировано только на будущую дату и время.'");
	ИначеЕсли Параметры.ДатаВремяОбновления > ДобавитьМесяц(ТекущаяДата, 1) Тогда
		ТекстСообщения = НСтр("ru = 'Обновление конфигурации может быть запланировано не позднее, чем через месяц относительно текущей даты.'");
	КонецЕсли;
	
	ДатаУказанаВерно = ПустаяСтрока(ТекстСообщения);
	Если Не ДатаУказанаВерно Тогда
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;
	
	Возврат ДатаУказанаВерно;
	
КонецФункции

Процедура ЗапланироватьОбновлениеКонфигурации(Параметры, ПараметрыАдминистрирования)
	
	СформироватьФайлыСкриптаОбновления(Ложь, Параметры, ПараметрыАдминистрирования);
	
	ШаблонКоманды = "wscript.exe //nologo %1";
	
	СтрокаКоманды = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонКоманды, 
		Параметры.ИмяСкриптаСозданияЗадачиПланировщикаЗадач);
	
	ПараметрыЗапускаПрограммы = ОбщегоНазначенияКлиентСервер.ПараметрыЗапускаПрограммы();
	ПараметрыЗапускаПрограммы.ВыполнитьСНаивысшимиПравами = Истина;
	
	ОбщегоНазначенияКлиентСервер.ЗапуститьПрограмму(СтрокаКоманды, ПараметрыЗапускаПрограммы);
	
	ОбновлениеКонфигурацииВызовСервера.ЗаписатьСтатусОбновления(ИмяПользователя(), Истина, Ложь, Ложь);
	
КонецПроцедуры

Функция СформироватьФайлыСкриптаОбновления(Знач ИнтерактивныйРежим, Параметры, ПараметрыАдминистрирования)
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
	ЭтоФайловаяБаза = ПараметрыРаботыКлиента.ИнформационнаяБазаФайловая;
	
	#Если Не ВебКлиент Тогда
	КаталогПлатформы = Неопределено;
	Параметры.Свойство("КаталогПлатформы", КаталогПлатформы);
	КаталогПрограммы = ?(ЗначениеЗаполнено(КаталогПлатформы), КаталогПлатформы, КаталогПрограммы());
	
	
	ИмяИсполняемогоФайлаКонфигуратора = КаталогПрограммы + СтандартныеПодсистемыКлиент.ИмяИсполняемогоФайлаПриложения(Истина);
	ИмяИсполняемогоФайлаКлиента = КаталогПрограммы + СтандартныеПодсистемыКлиент.ИмяИсполняемогоФайлаПриложения();
	
	ИспользоватьCOMСоединитель = Не (ПараметрыРаботыКлиента.ЭтоБазоваяВерсияКонфигурации Или ПараметрыРаботыКлиента.ЭтоУчебнаяПлатформа);
	
	ПараметрыСкрипта = ПолучитьПараметрыАутентификацииАдминистратораОбновления(ПараметрыАдминистрирования);
	СтрокаСоединенияИнформационнойБазы = ПараметрыСкрипта.СтрокаСоединенияИнформационнойБазы + ПараметрыСкрипта.СтрокаПодключения;
	Если СтрЗаканчиваетсяНа(СтрокаСоединенияИнформационнойБазы, ";") Тогда
		СтрокаСоединенияИнформационнойБазы = Лев(СтрокаСоединенияИнформационнойБазы, СтрДлина(СтрокаСоединенияИнформационнойБазы) - 1);
	КонецЕсли;
	
	// Определение пути к информационной базе.
	ПутьКИнформационнойБазе = СоединенияИБКлиентСервер.ПутьКИнформационнойБазе(, ПараметрыАдминистрирования.ПортКластера);
	ПараметрПутиКИнформационнойБазе = ?(ЭтоФайловаяБаза, "/F", "/S") + ПутьКИнформационнойБазе;
	СтрокаПутиКИнформационнойБазе = ?(ЭтоФайловаяБаза, ПутьКИнформационнойБазе, "");
	СтрокаПутиКИнформационнойБазе = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(СтрЗаменить(СтрокаПутиКИнформационнойБазе, """", "")) + "1Cv8.1CD";
	
	АдресЭлектроннойПочты = ?(Параметры.РежимОбновления = 2 И Параметры.ВыслатьОтчетНаПочту, Параметры.АдресЭлектроннойПочты, "");
	
	
	// Вызов КаталогВременныхФайлов вместо ПолучитьИмяВременногоФайла, так как каталог не должен удаляться 
	// автоматически при завершении клиентского приложения.
	// В него сохраняются исполняемые файлы, лог выполнения и резервная копия, при определенной настройке.
	КаталогВременныхФайловОбновления = КаталогВременныхФайлов() + "1Cv8Update." + Формат(ОбщегоНазначенияКлиент.ДатаСеанса(), "ДФ=ггММддЧЧммсс") + "\";
	
	Если Параметры.СоздаватьРезервнуюКопию = 1 Тогда 
		КаталогРезервнойКопии = КаталогВременныхФайловОбновления;
	ИначеЕсли Параметры.СоздаватьРезервнуюКопию = 2 Тогда 
		КаталогРезервнойКопии = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Параметры.ИмяКаталогаРезервнойКопииИБ);
	Иначе 
		КаталогРезервнойКопии = "";
	КонецЕсли;
	
	СоздаватьРезервнуюКопию = ЭтоФайловаяБаза И (Параметры.СоздаватьРезервнуюКопию = 1 Или Параметры.СоздаватьРезервнуюКопию = 2);
	
	ВыполнитьОтложенныеОбработчики = Ложь;
	ЭтоОтложенноеОбновление = (Параметры.РежимОбновления = 2);
	ТекстыМакетов = ОбновлениеКонфигурацииВызовСервера.ТекстыМакетов(ИнтерактивныйРежим,
		ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"], ВыполнитьОтложенныеОбработчики, ЭтоОтложенноеОбновление);
	ИмяПользователя = ПараметрыАдминистрирования.ИмяАдминистратораИнформационнойБазы;
	
	Если ЭтоОтложенноеОбновление Тогда 
		ГенераторСлучайныхЧисел = Новый ГенераторСлучайныхЧисел;
		КодЗадачи = Формат(ГенераторСлучайныхЧисел.СлучайноеЧисло(1000, 9999), "ЧГ=0");
		ИмяЗадачи = ИмяЗадачиScheduleService(КодЗадачи);
	КонецЕсли;
	
	ОбластьПараметров = ТекстыМакетов.ОбластьПараметров;
	ВставитьПараметрСкрипта("ИмяИсполняемогоФайлаКонфигуратора" , ИмяИсполняемогоФайлаКонфигуратора          , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("ИмяИсполняемогоФайлаКлиента"       , ИмяИсполняемогоФайлаКлиента                , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("ПараметрПутиКИнформационнойБазе"   , ПараметрПутиКИнформационнойБазе            , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("СтрокаПутиКФайлуИнформационнойБазы", СтрокаПутиКИнформационнойБазе              , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("СтрокаСоединенияИнформационнойБазы", СтрокаСоединенияИнформационнойБазы         , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("СобытиеЖурналаРегистрации"         , СобытиеЖурналаРегистрации()                , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("АдресЭлектроннойПочты"             , АдресЭлектроннойПочты                      , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("ИмяАдминистратораОбновления"       , ИмяПользователя                            , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("ИмяCOMСоединителя"                 , ПараметрыРаботыКлиента.ИмяCOMСоединителя   , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("КаталогРезервнойКопии"             , КаталогРезервнойКопии                      , Истина, ОбластьПараметров);
	ВставитьПараметрСкрипта("СоздаватьРезервнуюКопию"           , СоздаватьРезервнуюКопию                    , Ложь  , ОбластьПараметров);
	ВставитьПараметрСкрипта("ВосстанавливатьИнформационнуюБазу" , Параметры.ВосстанавливатьИнформационнуюБазу, Ложь  , ОбластьПараметров);
	ВставитьПараметрСкрипта("БлокироватьСоединенияИБ"           , Не ЭтоФайловаяБаза                         , Ложь  , ОбластьПараметров);
	ВставитьПараметрСкрипта("ИспользоватьCOMСоединитель"        , ИспользоватьCOMСоединитель                 , Ложь  , ОбластьПараметров);
	ВставитьПараметрСкрипта("ЗапускСеансаПослеОбновления"       , Не Параметры.ЗавершениеРаботыСистемы       , Ложь  , ОбластьПараметров);
	ВставитьПараметрСкрипта("ВыполнятьСжатиеТаблицИБ"           , ЭтоФайловаяБаза                            , Ложь  , ОбластьПараметров);
	ВставитьПараметрСкрипта("ВыполнитьОтложенныеОбработчики"    , ВыполнитьОтложенныеОбработчики             , Ложь  , ОбластьПараметров);
	ВставитьПараметрСкрипта("ИмяЗадачиПланировщикаЗадач"        , ИмяЗадачи                                  , Истина, ОбластьПараметров);
	ОбластьПараметров = СтрЗаменить(ОбластьПараметров, "[ИменаФайловОбновления]", ИменаФайловОбновления(Параметры));
	
	ТекстыМакетов.МакетФайлаОбновленияКонфигурации = ОбластьПараметров + ТекстыМакетов.МакетФайлаОбновленияКонфигурации;
	ТекстыМакетов.Удалить("ОбластьПараметров");
	
	//
	
	СоздатьКаталог(КаталогВременныхФайловОбновления);
	
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов.МакетФайлаОбновленияКонфигурации);
	
	ИмяФайлаСкрипта = КаталогВременныхФайловОбновления + "main.js";
	ФайлСкрипта.Записать(ИмяФайлаСкрипта, КодировкаФайловПрограммыОбновления());
	
	// Вспомогательный файл: helpers.js.
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов.ДопФайлОбновленияКонфигурации);
	ФайлСкрипта.Записать(КаталогВременныхФайловОбновления + "helpers.js", КодировкаФайловПрограммыОбновления());
	
	Если ИнтерактивныйРежим Тогда
		// Вспомогательный файл: splash.png.
		БиблиотекаКартинок.ЗаставкаВнешнейОперации.Записать(КаталогВременныхФайловОбновления + "splash.png");
		// Вспомогательный файл: splash.ico.
		БиблиотекаКартинок.ЗначокЗаставкиВнешнейОперации.Записать(КаталогВременныхФайловОбновления + "splash.ico");
		// Вспомогательный файл: progress.gif.
		БиблиотекаКартинок.ДлительнаяОперация48.Записать(КаталогВременныхФайловОбновления + "progress.gif");
		// Главный файл заставки: splash.hta.
		ИмяГлавногоФайлаСкрипта = КаталогВременныхФайловОбновления + "splash.hta";
		ФайлСкрипта = Новый ТекстовыйДокумент;
		ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
		ФайлСкрипта.УстановитьТекст(ТекстыМакетов.ЗаставкаОбновленияКонфигурации);
		ФайлСкрипта.Записать(ИмяГлавногоФайлаСкрипта, КодировкаФайловПрограммыОбновления());
	Иначе
		ИмяГлавногоФайлаСкрипта = КаталогВременныхФайловОбновления + "updater.js";
		ФайлСкрипта = Новый ТекстовыйДокумент;
		ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
		ФайлСкрипта.УстановитьТекст(ТекстыМакетов.НеинтерактивноеОбновлениеКонфигурации);
		ФайлСкрипта.Записать(ИмяГлавногоФайлаСкрипта, КодировкаФайловПрограммыОбновления());
	КонецЕсли;
	
	Если ЭтоОтложенноеОбновление Тогда 
		
		ДатаЗапуска = Формат(Параметры.ДатаВремяОбновления, "ДФ=yyyy-MM-ddTHH:mm:ss");
		
		ПутьСкрипта = СтандартныеПодсистемыКлиент.ПапкаСистемныхПриложений() + "wscript.exe";
		ПараметрыСкрипта = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("//nologo ""%1"" /p1:""%2"" /p2:""%3""",
			ИмяГлавногоФайлаСкрипта,
			СтрокаUnicode(ПараметрыАдминистрирования.ПарольАдминистратораИнформационнойБазы),
			СтрокаUnicode(ПараметрыАдминистрирования.ПарольАдминистратораКластера));
		
		ОписаниеЗадачи = НСтр("ru = 'Обновление конфигурации 1С:Предприятие'");
		
		СкриптСозданияЗадачиПланировщикаЗадач = ТекстыМакетов.СкриптСозданияЗадачиПланировщикаЗадач;
		
		ВставитьПараметрСкрипта("ДатаЗапуска" , ДатаЗапуска, Истина, СкриптСозданияЗадачиПланировщикаЗадач);
		ВставитьПараметрСкрипта("ПутьСкрипта" , ПутьСкрипта, Истина, СкриптСозданияЗадачиПланировщикаЗадач);
		ВставитьПараметрСкрипта("ПараметрыСкрипта" , ПараметрыСкрипта, Истина, СкриптСозданияЗадачиПланировщикаЗадач);
		ВставитьПараметрСкрипта("ИмяЗадачи" , ИмяЗадачи, Истина, СкриптСозданияЗадачиПланировщикаЗадач);
		ВставитьПараметрСкрипта("ОписаниеЗадачи" , ОписаниеЗадачи, Истина, СкриптСозданияЗадачиПланировщикаЗадач);
		
		ИмяСкриптаСозданияЗадачиПланировщикаЗадач = КаталогВременныхФайловОбновления + "addsheduletask.js";
		ФайлСкрипта = Новый ТекстовыйДокумент;
		ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
		ФайлСкрипта.УстановитьТекст(СкриптСозданияЗадачиПланировщикаЗадач);
		ФайлСкрипта.Записать(ИмяСкриптаСозданияЗадачиПланировщикаЗадач, КодировкаФайловПрограммыОбновления());
		
		Параметры.КодЗадачиПланировщика = КодЗадачи;
		
		Параметры.Вставить("ИмяСкриптаСозданияЗадачиПланировщикаЗадач", ИмяСкриптаСозданияЗадачиПланировщикаЗадач);
		
	КонецЕсли;
	
	ФайлЛога = Новый ТекстовыйДокумент;
	ФайлЛога.Вывод = ИспользованиеВывода.Разрешить;
	ФайлЛога.УстановитьТекст(СтандартныеПодсистемыКлиент.ИнформацияДляПоддержки());
	ФайлЛога.Записать(КаталогВременныхФайловОбновления + "templog.txt", КодировкаТекста.Системная);
	
	Возврат ИмяГлавногоФайлаСкрипта;
	
	#КонецЕсли
	
КонецФункции

Процедура ВставитьПараметрСкрипта(Знач ИмяПараметра, Знач ЗначениеПараметра, Форматировать, ОбластьПараметров)
	
	Если Форматировать = Истина Тогда
		ЗначениеПараметра = Форматировать(ЗначениеПараметра);
	ИначеЕсли Форматировать = Ложь Тогда
		ЗначениеПараметра = ?(ЗначениеПараметра, "true", "false");
	КонецЕсли;
	ОбластьПараметров = СтрЗаменить(ОбластьПараметров, "[" + ИмяПараметра + "]", ЗначениеПараметра);
	
КонецПроцедуры

Функция ИменаФайловОбновления(Параметры)
	
	ИмяПараметра = "СтандартныеПодсистемы.ИменаФайловОбновления";
	Если ПараметрыПриложения.Получить(ИмяПараметра) <> Неопределено Тогда
		Возврат ПараметрыПриложения[ИмяПараметра];
	КонецЕсли;
	
	Если Параметры.Свойство("НуженФайлОбновления") И Не Параметры.НуженФайлОбновления Тогда
		ИменаФайловОбновления = "";
	Иначе
		Если ПустаяСтрока(Параметры.ИмяФайлаОбновления) Тогда
			ИменаФайлов = Новый Массив;
			Для Каждого ФайлОбновления Из Параметры.ФайлыОбновления Цикл
				ПрефиксФайлаОбновления = ?(ФайлОбновления.ВыполнитьОбработчикиОбновления, "+", "");
				ИменаФайлов.Добавить(Форматировать(ПрефиксФайлаОбновления + ФайлОбновления.ПолноеИмяФайлаОбновления));
			КонецЦикла;
			ИменаФайловОбновления = СтрСоединить(ИменаФайлов, ",");
		Иначе
			ИменаФайловОбновления = Форматировать(Параметры.ИмяФайлаОбновления);
		КонецЕсли;
	КонецЕсли;
	
	Возврат "[" + ИменаФайловОбновления + "]";
	
КонецФункции

Функция Форматировать(Знач Текст)
	Текст = СтрЗаменить(Текст, "\", "\\");
	Текст = СтрЗаменить(Текст, """", "\""");
	Текст = СтрЗаменить(Текст, "'", "\'");
	Возврат "'" + Текст + "'";
КонецФункции

Функция ПолучитьПараметрыАутентификацииАдминистратораОбновления(ПараметрыАдминистрирования)
	
	Результат = Новый Структура("СтрокаПодключения, СтрокаСоединенияИнформационнойБазы");
	
	ПортКластера = ПараметрыАдминистрирования.ПортКластера;
	ТекущиеСоединения = СоединенияИБВызовСервера.ИнформацияОСоединениях(Истина,
		ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"], ПортКластера);
		
	Результат.СтрокаСоединенияИнформационнойБазы = ТекущиеСоединения.СтрокаСоединенияИнформационнойБазы;
	Результат.СтрокаПодключения = "Usr=""{0}"";Pwd=""{1}""";
	
	Возврат Результат;
	
КонецФункции

Функция ИмяЗадачиScheduleService(Знач КодЗадачи)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Обновление конфигурации (%1)'"), Формат(КодЗадачи, "ЧГ=0"));
	
КонецФункции

Функция СтрокаUnicode(Строка)
	
	Результат = "";
	
	Для НомерСимвола = 1 По СтрДлина(Строка) Цикл
		
		Символ = Формат(КодСимвола(Сред(Строка, НомерСимвола, 1)), "ЧГ=0");
		Символ = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(Символ, 4);
		Результат = Результат + Символ;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает имя события для записи журнала регистрации.
Функция СобытиеЖурналаРегистрации() Экспорт
	Возврат НСтр("ru = 'Обновление конфигурации'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
КонецФункции

// Проверяет наличие обновления конфигурации при запуске программы.
//
Процедура ПроверитьОбновлениеКонфигурации()
	
	Если Не ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
		Возврат;
	КонецЕсли;
	
#Если НЕ ВебКлиент Тогда
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботыКлиента.РазделениеВключено Или Не ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРаботыКлиента.Свойство("ПоказатьСообщениеОбОшибочныхОбработчиках") Тогда
		Возврат; // Форма результатов обновления будет показана позже.
	КонецЕсли;
	
	НастройкиОбновления = ПараметрыРаботыКлиента.НастройкиОбновления;
	НаличиеОбновления = НастройкиОбновления.ПроверитьПрошлыеОбновленияБазы;
	
	Если НаличиеОбновления Тогда
		// Надо завершить предыдущее обновление.
		ОткрытьФорму("Обработка.РезультатыОбновленияПрограммы.Форма.ИндикацияХодаОтложенногоОбновленияИБ");
		Возврат;
	КонецЕсли;
	
	Если НастройкиОбновления.КонфигурацияИзменена Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Обновление конфигурации'"),
			"e1cib/app/Обработка.УстановкаОбновлений",
			НСтр("ru = 'Конфигурация отличается от основной конфигурации информационной базы.'"), 
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
#КонецЕсли

КонецПроцедуры

Процедура ПрочитатьДанныеВЖурналРегистрации(РезультатОбновления, КаталогСкрипта)
	
	РезультатОбновления = Неопределено;
	ПриОбновленииПроизошлаОшибка = Ложь;
	
	МассивФайлов = НайтиФайлы(КаталогСкрипта, "log*.txt");
	
	Если МассивФайлов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ФайлЖурнала = МассивФайлов[0];
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ФайлЖурнала.ПолноеИмя);
	
	Для НомерСтроки = 1 По ТекстовыйДокумент.КоличествоСтрок() Цикл
		
		ТекущаяСтрока = ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки);
		Если ПустаяСтрока(ТекущаяСтрока) Тогда
			Продолжить;
		КонецЕсли;
		
		НачатьЗапись = Ложь;
		
		ПредставлениеУровня = "Информация";
		Если Сред(ТекущаяСтрока, 3, 1) = "." И Сред(ТекущаяСтрока, 6, 1) = "." Тогда // Строка с датой
			МассивСтроки = СтрРазделить(ТекущаяСтрока, " ", Ложь);
			МассивДаты = СтрРазделить(МассивСтроки[0], ".");
			МассивВремени = СтрРазделить(МассивСтроки[1], ":");
			ДатаСобытия = Дата(МассивДаты[2], МассивДаты[1], МассивДаты[0], МассивВремени[0], МассивВремени[1], МассивВремени[2]);
			Если МассивСтроки[2] = "{ERR}" Тогда
				ПредставлениеУровня = "Ошибка";
				ПриОбновленииПроизошлаОшибка = Истина;
			КонецЕсли;
			Комментарий = СокрЛП(Сред(ТекущаяСтрока, СтрНайти(ТекущаяСтрока, "}") + 2));
			
			Если Комментарий = НСтр("ru = 'Обновление выполнено'") Тогда
				РезультатОбновления = Истина;
				Продолжить;
			ИначеЕсли Комментарий = НСтр("ru = 'Обновление не выполнено'") Тогда
				РезультатОбновления = Ложь;
				Продолжить;
			КонецЕсли;
			НачатьЗапись = Истина;
		Иначе
			Комментарий = ТекущаяСтрока;
		КонецЕсли;
		
		Если НачатьЗапись Тогда 
			ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), ПредставлениеУровня, Комментарий, ДатаСобытия);
		КонецЕсли;
		
	КонецЦикла;
	
	// Если обновление выполнялось с версии БСП ниже 2.3.1.6, то записей лога
	// - "Обновление выполнено"
	// - "Обновление не выполнено"
	// может не быть, потому будем опираться на то - происходили ли ошибки в ходе обновления.
	Если РезультатОбновления = Неопределено Тогда 
		РезультатОбновления = Не ПриОбновленииПроизошлаОшибка;
	КонецЕсли;
	
	ЗаписатьСобытияВЖурналРегистрации();
	
КонецПроцедуры

Процедура ЗаписатьСобытияВЖурналРегистрации() Экспорт
	
	СобытияДляЖурналаРегистрации = ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"];
	
	Если ТипЗнч(СобытияДляЖурналаРегистрации) <> Тип("СписокЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	Если СобытияДляЖурналаРегистрации.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЖурналРегистрацииВызовСервера.ЗаписатьСобытияВЖурналРегистрации(СобытияДляЖурналаРегистрации);
	
КонецПроцедуры

#Если Не ВебКлиент Тогда

Функция КодировкаФайловПрограммыОбновления()
	
	// wscript.exe может работать только с файлами в кодировке UTF-16 LE.
	Возврат КодировкаТекста.UTF16;
	
КонецФункции

#КонецЕсли

#КонецОбласти