////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность 
//             электронного документооборота с контролирующими органами". 
////////////////////////////////////////////////////////////////////////////////


#Область ПрограммныйИнтерфейс

// Возвращает описание технических характеристик компьютера (только для Windows).
// 
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено           - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * СистемнаяИнформация - ФиксированнаяСтруктура - описание технических характеристик компьютера.
//        ** ИмяОС         - Строка - наименование операционной системы (например, Windows 7, Windows Server 2003 R2 и др.).
//        ** ВерсияОС      - Строка - версия операционной системы в формате РР.П. 
//        ** РазрядностьОС - Число - разрядность операционной системы (32 или 64).
//      * ОписаниеОшибки      - Строка - описание ошибки выполнения.
//
//  ВыводитьСообщения - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
Процедура ПолучитьСистемнуюИнформацию(ОповещениеОЗавершении, ВыводитьСоообщения = Истина) Экспорт
	
	ОбщегоНазначенияЭДКОСлужебныйКлиент.ПолучитьСистемнуюИнформацию(ОповещениеОЗавершении, ВыводитьСоообщения);
	
КонецПроцедуры

// Выполняет установку криптопровайдера ViPNet CSP.
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено           - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * ОписаниеОшибки      - Строка - описание ошибки выполнения.
//    
//   ВладелецФормы - УправляемаяФорма - форма, которая будет указана в качестве владельца.
//
Процедура УстановитьViPNetCSP(ОповещениеОЗавершении, ВладелецФормы) Экспорт
	
	ОбщегоНазначенияЭДКОСлужебныйКлиент.УстановитьViPNetCSP(ОповещениеОЗавершении, ВладелецФормы);
	
КонецПроцедуры

// Выполняет установку криптопровайдера CryptoPro CSP.
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено           - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * ОписаниеОшибки      - Строка - описание ошибки выполнения.
//    
//   ВладелецФормы - УправляемаяФорма - форма, которая будет указана в качестве владельца.
//
Процедура УстановитьCryptoProCSP(ОповещениеОЗавершении, ВладелецФормы) Экспорт
	
	ОбщегоНазначенияЭДКОСлужебныйКлиент.УстановитьCryptoProCSP(ОповещениеОЗавершении, ВладелецФормы);
	
КонецПроцедуры

// Проверяет возможен ли конфликт установленных криптопровайдеров и при необходимости выдает предупреждение.
Процедура СообщитьПользователюОКонфликтеКриптопровайдеров() Экспорт
	
	ОбщегоНазначенияЭДКОСлужебныйКлиент.СообщитьПользователюОКонфликтеКриптопровайдеров();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет проверку поддерживается ли клиентское приложение или нет.
//
//  Возвращаемое значение:
//    Булево - признак поддержки клиентского приложения.    
//
Функция ЭтоКлиентскоеПриложениеПоддерживается() Экспорт
	
	ЭтоВебКлиент = ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент();
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	
	ЭтоWindowsКлиент = (СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86
		ИЛИ СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64)
		И НЕ ЭтоВебКлиент ИЛИ ЭтоВебКлиент И СтрНайти(СистемнаяИнформация.ИнформацияПрограммыПросмотра, "Windows");
		
	ЭтоEdgeБраузер = ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() И СтрНайти(СистемнаяИнформация.ИнформацияПрограммыПросмотра, "Edge");
	
	Возврат ЭтоWindowsКлиент И НЕ ЭтоEdgeБраузер;
	
КонецФункции

// Возвращает путь к внешней компоненте для работы с криптографией.
//
//  Возвращаемое значение:
//    Строка - путь к внешней компоненте.    
//
Функция ПолучитьМестоположениеВнешнейКомпоненты() Экспорт
	
	ИмяПараметра = "ЭлектронныйДокументооборотСКонтролирующимиОрганами.КомпонентаОбмена";
	Если ПараметрыПриложения.Получить(ИмяПараметра) = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ПолучитьПутьВК());
	КонецЕсли;
	
	Возврат ПараметрыПриложения.Получить(ИмяПараметра);
	
КонецФункции

Функция ЗаполнитьДополнительныеПараметрыПриНеобходимости(ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(ДополнительныеПараметры) Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ПредлагатьУстановкуВнешнейКомпоненты", Истина);
		ДополнительныеПараметры.Вставить("ВыводитьСообщения", Истина);
	Иначе
		Если Не ДополнительныеПараметры.Свойство("ПредлагатьУстановкуВнешнейКомпоненты") Тогда
			ДополнительныеПараметры.Вставить("ПредлагатьУстановкуВнешнейКомпоненты", Истина);
		КонецЕсли;
		Если Не ДополнительныеПараметры.Свойство("ВыводитьСообщения") Тогда
			ДополнительныеПараметры.Вставить("ВыводитьСообщения", Истина);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

Процедура ЗавершитьСОтрицательнымРезультатом(Ошибка, ВходящийКонтекст, ИмяСобытия) Экспорт
	
	ЗаписьСобытияВЖурналРегистрации(Ошибка, ИмяСобытия);
	
	РезультатВыполнения = Новый Структура;
	РезультатВыполнения.Вставить("Выполнено", Ложь);
	РезультатВыполнения.Вставить("КодОшибки", Ошибка.Код);
	РезультатВыполнения.Вставить("ОписаниеОшибки", Ошибка.Описание);
	
	ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
	
КонецПроцедуры

Функция ПараметрыПриложения()
	
	Параметры = Новый Структура;
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Параметры.Вставить("Версия", СистемнаяИнформация.ВерсияПриложения);
	
	#Если ВебКлиент Тогда
		Параметры.Вставить("Тип", СистемнаяИнформация.ИнформацияПрограммыПросмотра);
	#ИначеЕсли ТонкийКлиент Тогда
		Параметры.Вставить("Тип", СтрШаблон("Тонкий клиент (%1)", СистемнаяИнформация.ТипПлатформы));
		Параметры.Вставить("ОС", СистемнаяИнформация.ВерсияОС);
	#ИначеЕсли ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
		Параметры.Вставить("Тип", СтрШаблон("Толстый клиент (%1)", СистемнаяИнформация.ТипПлатформы));
		Параметры.Вставить("ОС", СистемнаяИнформация.ВерсияОС);
	#КонецЕсли
	
	Возврат Параметры;
	
КонецФункции

Процедура ЗаписьСобытияВЖурналРегистрации(Ошибка, ИмяСобытия)
	
	Событие = Новый Структура;
	Событие.Вставить("Код", Ошибка.Код);
	Событие.Вставить("Описание", Ошибка.Описание);
	Событие.Вставить("Приложение", ПараметрыПриложения());
	
	ОбщегоНазначенияЭДКОСлужебныйВызовСервера.ЗаписьСобытияВЖурналРегистрации(ИмяСобытия, Событие);
	
КонецПроцедуры

Функция ИмяПараметраКриптопровайдеры() Экспорт
	
	Возврат "ЭлектронныйДокументооборотСКонтролирующимиОрганами.Криптопровайдеры";
	
КонецФункции

#КонецОбласти



