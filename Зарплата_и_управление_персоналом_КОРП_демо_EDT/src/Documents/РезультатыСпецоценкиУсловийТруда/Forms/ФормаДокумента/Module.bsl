
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Ключ.Пустая() Тогда
		
		// Создается новый документ.
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный", "Объект.Организация", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ЗаполнитьДанныеФормыПоОрганизации();
		ПриПолученииДанныхНаСервере();
		
	КонецЕсли;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриПолученииДанныхНаСервере();
	
	ОбменДаннымиЗарплатаКадры.ПриЧтенииНаСервереДокумента(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ПриПолученииДанныхНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_РезультатыСпецоценкиУсловийТруда", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	Оповещение = Новый ОписаниеОповещения("ДокументОснованиеПриИзмененииЗавершение", ЭтотОбъект);
	ЗарплатаКадрыРасширенныйКлиент.ПроверитьВозможностьОчисткиТабличныхЧастей(ЭтаФорма, "РабочиеМеста", Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРабочиеМеста

&НаКлиенте
Процедура РабочиеМестаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле.Имя = "РабочиеМестаКомандаАналогичныеМеста" Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФормуАналогичныхРабочихМестПоСтроке(ТекущиеДанные);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РабочиеМестаРабочееМестоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.РабочиеМеста.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РабочиеМестаРабочееМестоПриИзмененииНаСервере(ТекущиеДанные.ПолучитьИдентификатор());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКомиссия

&НаКлиенте
Процедура КомиссияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НоваяСтрока И Не Копирование Тогда
		ТекущиеДанные.РольВКомиссии = ПредопределенноеЗначение("Перечисление.РолиЧленовКомиссииОхраныТруда.ЧленКомиссии");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомиссияЧленКомиссииПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Комиссия.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ЧленКомиссии) Тогда
		ТекущиеДанные.Должность = ДолжностьЧленаКомиссии(ТекущиеДанные.ЧленКомиссии);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьАналогичныеРабочиеМеста(Команда)
	
	МассивАналогичныеМеста = Новый Массив;
	Если Элементы.РабочиеМеста.ВыделенныеСтроки.Количество() = 1 Тогда
		СтрокаТаблицы = Объект.РабочиеМеста.НайтиПоИдентификатору(Элементы.РабочиеМеста.ВыделенныеСтроки[0]);
		Если ЗначениеЗаполнено(СтрокаТаблицы.ПредставлениеРабочегоМеста) Тогда
			ОткрытьФормуАналогичныхРабочихМестПоСтроке(СтрокаТаблицы);
			Возврат;
		КонецЕсли;
	Иначе
		Для Каждого ВыделеннаяСтрока Из Элементы.РабочиеМеста.ВыделенныеСтроки Цикл
			СтрокаТаблицы = Объект.РабочиеМеста.НайтиПоИдентификатору(ВыделеннаяСтрока);
			Если СтрокаТаблицы <> Неопределено Тогда 
				МассивАналогичныеМеста.Добавить(Новый Структура("РабочееМесто, Представление", СтрокаТаблицы.РабочееМесто, СтрокаТаблицы.ПредставлениеРабочегоМеста));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	МассивРабочиеМеста = Новый Массив;
	Для Каждого СтрокаРабочиеМеста Из Объект.РабочиеМеста Цикл
		МассивРабочиеМеста.Добавить(Новый Структура("РабочееМесто, Представление", СтрокаРабочиеМеста.РабочееМесто, СтрокаРабочиеМеста.ПредставлениеРабочегоМеста));
	КонецЦикла;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("АналогичныеМеста", МассивАналогичныеМеста);
	ПараметрыОткрытия.Вставить("РабочиеМеста", МассивРабочиеМеста);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыделитьАналогичныеРабочиеМестаПослеЗакрытия", ЭтотОбъект);
	ОткрытьФорму("Документ.РезультатыСпецоценкиУсловийТруда.Форма.ФормаАналогичныхМест",
		ПараметрыОткрытия, ЭтотОбъект, , , , ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьАналогичныеРабочиеМестаПослеЗакрытия(РезультатЗакрытия, ДополнительныеПараметры) Экспорт 
	
	Если ТипЗнч(РезультатЗакрытия) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ВыделитьАналогичныеРабочиеМестаПослеЗакрытияНаСервере(РезультатЗакрытия, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура ВыделитьАналогичныеРабочиеМестаПослеЗакрытияНаСервере(РезультатЗакрытия, ДополнительныеПараметры)
	
	Если ЗначениеЗаполнено(РезультатЗакрытия.ОсновноеРабочееМесто) Тогда
		// Удалим аналогичные рабочие места с предыдущим основным рабочим местом
		НайденныеСтроки = Объект.АналогичныеМеста.НайтиСтроки(Новый Структура("РабочееМесто", РезультатЗакрытия.ОсновноеРабочееМесто));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Объект.АналогичныеМеста.Удалить(НайденнаяСтрока);
		КонецЦикла;
		Если РезультатЗакрытия.АналогичныеМеста.Количество() = 0 Тогда
			// Удалим из списка рабочих мест группу аналогичных мест
			НайденныеСтроки = Объект.РабочиеМеста.НайтиСтроки(Новый Структура("РабочееМесто", РезультатЗакрытия.ОсновноеРабочееМесто));
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				Объект.РабочиеМеста.Удалить(НайденнаяСтрока);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	ОсновноеРабочееМесто = Неопределено;
	Для Каждого АналогичноеРабочееМесто Из РезультатЗакрытия.АналогичныеМеста Цикл
		Если ОсновноеРабочееМесто = Неопределено Тогда
			ОсновноеРабочееМесто = АналогичноеРабочееМесто;
			
			// Установим представления для команд и группы аналогичных мест
			НайденныеСтроки = Объект.РабочиеМеста.НайтиСтроки(Новый Структура("РабочееМесто", ОсновноеРабочееМесто));
			Если НайденныеСтроки.Количество() = 0 Тогда
				// Заменим предыдущее основное рабочее место текущим
				НайденныеСтроки = Объект.РабочиеМеста.НайтиСтроки(Новый Структура("РабочееМесто", РезультатЗакрытия.ОсновноеРабочееМесто));
			КонецЕсли;
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				НайденнаяСтрока.РабочееМесто = ОсновноеРабочееМесто;
				НайденнаяСтрока.ПредставлениеРабочегоМеста = РезультатЗакрытия.ПредставлениеГруппы;
				РабочиеМестаРабочееМестоПриИзмененииНаСервере(Неопределено, НайденнаяСтрока);
			КонецЦикла;
			Продолжить;
		КонецЕсли;
		
		// Если есть группа аналогичных мест, то в ней нужно заменить основное рабочее место.
		НайденныеСтроки = Объект.АналогичныеМеста.НайтиСтроки(Новый Структура("РабочееМесто", АналогичноеРабочееМесто));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			НайденнаяСтрока.РабочееМесто = ОсновноеРабочееМесто;
		КонецЦикла;
		
		// Добавим аналогичное рабочее место
		НоваяСтрока = Объект.АналогичныеМеста.Добавить();
		НоваяСтрока.РабочееМесто = ОсновноеРабочееМесто;
		НоваяСтрока.АналогичноеМесто = АналогичноеРабочееМесто;
		
		// Удалим из списка рабочих мест аналогичное место
		НайденныеСтроки = Объект.РабочиеМеста.НайтиСтроки(Новый Структура("РабочееМесто", АналогичноеРабочееМесто));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Объект.РабочиеМеста.Удалить(НайденнаяСтрока);
		КонецЦикла;
	КонецЦикла;
	
	// Заполним краткие составы для основного рабочего места группы аналогичных мест
	Если ОсновноеРабочееМесто <> Неопределено Тогда
		НайденныеСтроки = Объект.РабочиеМеста.НайтиСтроки(Новый Структура("РабочееМесто", ОсновноеРабочееМесто));
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			ЗаполнитьКраткийСоставАналогичныхМест(НайденнаяСтрока);
		КонецЦикла;
	КонецЕсли;
	
	Для каждого РабочееМесто Из РезультатЗакрытия.РабочиеМеста Цикл
		// Если нет рабочего места, значит оно было удалено из аналогичных рабочих мест
		// Такое рабочее место нужно вернуть в список рабочих мест.
		НайденныеСтроки = Объект.РабочиеМеста.НайтиСтроки(Новый Структура("РабочееМесто", РабочееМесто));
		Если НайденныеСтроки.Количество() = 0 Тогда
			
			НоваяСтрока = Объект.РабочиеМеста.Добавить();
			НоваяСтрока.РабочееМесто = РабочееМесто;
			РабочиеМестаРабочееМестоПриИзмененииНаСервере(Неопределено, НоваяСтрока);
			
			// Если есть группа аналогичных мест, значит их тоже нужно исключить из аналогичных мест.
			НайденныеСтроки = Объект.АналогичныеМеста.НайтиСтроки(Новый Структура("РабочееМесто", РабочееМесто));
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				НоваяСтрока = Объект.РабочиеМеста.Добавить();
				НоваяСтрока.РабочееМесто = НайденнаяСтрока.АналогичноеМесто;
				РабочиеМестаРабочееМестоПриИзмененииНаСервере(Неопределено, НоваяСтрока);
				Объект.АналогичныеМеста.Удалить(НайденнаяСтрока);
			КонецЦикла;
			
		КонецЕсли;
	КонецЦикла;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКлассУсловийТрудаДляВсехРабочихМест(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьКлассУсловийТрудаПослеВыбораЗначения", ЭтотОбъект, Новый Структура("ВидЗаполнения", "ВсеРабочиеМеста"));
	ПоказатьВводЗначения(
		Оповещение,
		ПредопределенноеЗначение("Перечисление.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Допустимый"),
		НСтр("ru = 'Выберите класс условий труда'"),
		Тип("ПеречислениеСсылка.КлассыУсловийТрудаПоРезультатамСпециальнойОценки"));
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКлассУсловийТрудаДляВыделенныхРабочихМест(Команда)
	
	Оповещение = Новый ОписаниеОповещения(
		"ЗаполнитьКлассУсловийТрудаПослеВыбораЗначения",
		ЭтотОбъект,
		Новый Структура("ВидЗаполнения, ВыделенныеСтроки", "ВыделенныеРабочиеМеста", Элементы.РабочиеМеста.ВыделенныеСтроки));
	ПоказатьВводЗначения(
		Оповещение,
		ПредопределенноеЗначение("Перечисление.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Допустимый"),
		НСтр("ru = 'Выберите класс условий труда'"),
		Тип("ПеречислениеСсылка.КлассыУсловийТрудаПоРезультатамСпециальнойОценки"));
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКлассУсловийТрудаПослеВыбораЗначения(Значение, ДополнительныеПараметры) Экспорт
	
	Если Значение = Неопределено Или ТипЗнч(ДополнительныеПараметры) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ВидЗаполнения = "ВсеРабочиеМеста" Тогда
		Для каждого СтрокаРабочиеМеста Из Объект.РабочиеМеста Цикл
			СтрокаРабочиеМеста.КлассУсловийТруда = Значение;
		КонецЦикла;
	Иначе
		Для каждого ВыделеннаяСтрока Из ДополнительныеПараметры.ВыделенныеСтроки Цикл
			НайденнаяСтрока = Объект.РабочиеМеста.НайтиПоИдентификатору(ВыделеннаяСтрока);
			Если НайденнаяСтрока = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			НайденнаяСтрока.КлассУсловийТруда = Значение;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКлассУсловийТрудаПоПредыдущейОценке(Команда)
	ЗаполнитьКлассУсловийТрудаПоПредыдущейОценкеНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция МассивАналогичныхМест(Объект, РабочееМесто)
	
	МассивАналогичныеМеста = Новый Массив;
	НайденныеСтроки = Объект.АналогичныеМеста.НайтиСтроки(Новый Структура("РабочееМесто", РабочееМесто));
	Для Каждого СтрокаАналогичныеМеста Из НайденныеСтроки Цикл
		МассивАналогичныеМеста.Добавить(СтрокаАналогичныеМеста.АналогичноеМесто);
	КонецЦикла;
	// Добавим текущее рабочее место в аналогичные места
	МассивАналогичныеМеста.Добавить(РабочееМесто);
	
	Возврат МассивАналогичныеМеста;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКраткийСоставАналогичныхМест(Строка)
	
	АналогичныеМеста = МассивАналогичныхМест(Объект, Строка.РабочееМесто);
	Если АналогичныеМеста.Количество() = 1 Тогда
		Строка.КомандаАналогичныеМеста = "";
		Возврат;
	КонецЕсли;
	
	МаксимальнаяДлинаСтроки = 100;
	КраткийСостав = "";
	Для Каждого ЭлементМассива Из АналогичныеМеста Цикл
		Если Не ПустаяСтрока(КраткийСостав) Тогда
			КраткийСостав = КраткийСостав + ", ";
		КонецЕсли;
		КраткийСостав = КраткийСостав + Строка(ЭлементМассива);
		Если СтрДлина(КраткийСостав) > МаксимальнаяДлинаСтроки Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если СтрДлина(КраткийСостав) > МаксимальнаяДлинаСтроки Тогда
		КраткийСостав = Лев(КраткийСостав, МаксимальнаяДлинаСтроки - 3) + "...";
	КонецЕсли;
	Строка.КомандаАналогичныеМеста = КраткийСостав;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ЗаполнитьДанныеФормыПоОрганизации();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли;
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Объект.Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "Объект.ДолжностьРуководителя");
	
	ЗапрашиваемыеЗначения.Вставить("ОтветственныйЗаОхрануТруда", "Объект.ОтветственныйЗаОхрануТруда");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьОтветственногоЗаОхрануТруда", "Объект.ДолжностьОтветственногоЗаОхрануТруда");
	
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтаФорма, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));
	
	Если Объект.Комиссия.Количество() = 0 И (ЗначениеЗаполнено(Объект.Руководитель) Или ЗначениеЗаполнено(Объект.ОтветственныйЗаОхрануТруда)) Тогда
		Если ЗначениеЗаполнено(Объект.Руководитель) Тогда
			НоваяСтрокаКомиссии = Объект.Комиссия.Добавить();
			НоваяСтрокаКомиссии.ЧленКомиссии = Объект.Руководитель;
			НоваяСтрокаКомиссии.Должность = Объект.ДолжностьРуководителя;
			НоваяСтрокаКомиссии.РольВКомиссии = Перечисления.РолиЧленовКомиссииОхраныТруда.Председатель;
		КонецЕсли;
		Если ЗначениеЗаполнено(Объект.ОтветственныйЗаОхрануТруда) Тогда
			НоваяСтрокаКомиссии = Объект.Комиссия.Добавить();
			НоваяСтрокаКомиссии.ЧленКомиссии = Объект.ОтветственныйЗаОхрануТруда;
			НоваяСтрокаКомиссии.Должность = Объект.ДолжностьОтветственногоЗаОхрануТруда;
			НоваяСтрокаКомиссии.РольВКомиссии = Перечисления.РолиЧленовКомиссииОхраныТруда.ЧленКомиссии;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		ДокументОбъект.Заполнить(Объект.ДокументОснование);
	Иначе
		ДокументОбъект.ЗаполнитьПереченьРабочихМест();
	КонецЕсли;
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ОбновитьКраткиеСоставы();
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКраткиеСоставы()
	
	// Заполним текст команд таблицы "Рабочие места"
	Для каждого СтрокаРабочегоМеста Из Объект.РабочиеМеста Цикл
		ЗаполнитьКраткийСоставАналогичныхМест(СтрокаРабочегоМеста);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура РабочиеМестаРабочееМестоПриИзмененииНаСервере(ИдентификаторСтроки, Знач ТекущаяСтрока = Неопределено)
	
	Если ТекущаяСтрока = Неопределено Тогда
		ТекущаяСтрока = Объект.РабочиеМеста.НайтиПоИдентификатору(ИдентификаторСтроки);
	КонецЕсли;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("РабочееМесто", ТекущаяСтрока.РабочееМесто);
	Запрос.УстановитьПараметр("ДатаДокумента", Объект.Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РезультатыСпециальнойОценкиУсловийТруда.Период,
	|	РезультатыСпециальнойОценкиУсловийТруда.РабочееМесто,
	|	РезультатыСпециальнойОценкиУсловийТруда.КлассУсловийТруда
	|ИЗ
	|	РегистрСведений.РезультатыСпециальнойОценкиУсловийТруда.СрезПоследних(&ДатаДокумента, РабочееМесто = &РабочееМесто) КАК РезультатыСпециальнойОценкиУсловийТруда";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекущаяСтрока.КлассУсловийТруда = Выборка.КлассУсловийТруда;
	КонецЦикла;
	
	ЗаполнитьКраткийСоставАналогичныхМест(ТекущаяСтрока);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Исполнитель", "Доступность", Не ЗначениеЗаполнено(Объект.ДокументОснование));
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзмененииЗавершение(Отказ,ДополнительныеПараметры) Экспорт
	
	Если Не Отказ Тогда
		ЗаполнитьНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКлассУсловийТрудаПоПредыдущейОценкеНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("РабочиеМеста", Объект.РабочиеМеста.Выгрузить().ВыгрузитьКолонку("РабочееМесто"));
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("ДатаРезультатов", Объект.ДатаРезультатов);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РезультатыСпециальнойОценкиУсловийТрудаСрезПоследних.РабочееМесто,
	|	РезультатыСпециальнойОценкиУсловийТрудаСрезПоследних.КлассУсловийТруда
	|ИЗ
	|	РегистрСведений.РезультатыСпециальнойОценкиУсловийТруда.СрезПоследних(
	|			&ДатаРезультатов,
	|			РабочееМесто В (&РабочиеМеста)
	|				И Регистратор <> &Ссылка) КАК РезультатыСпециальнойОценкиУсловийТрудаСрезПоследних";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НайденныеСтроки = Объект.РабочиеМеста.НайтиСтроки(Новый Структура("РабочееМесто", Выборка.РабочееМесто));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			НайденнаяСтрока.КлассУсловийТруда = Выборка.КлассУсловийТруда;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ДолжностьЧленаКомиссии(ЧленКомиссии)
	
	ТаблицаСотрудников = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(ЧленКомиссии, Истина, Объект.Организация, Объект.ДатаНачала);
	Сотрудники = ТаблицаСотрудников.ВыгрузитьКолонку("Сотрудник");
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Сотрудники, "ТекущаяДолжность", Объект.ДатаНачала);
	
	Если КадровыеДанные.Количество() > 0 Тогда
		ТекущаяДолжность = КадровыеДанные[0].ТекущаяДолжность;
		Если ЗначениеЗаполнено(ТекущаяДолжность) Тогда
			Возврат ТекущаяДолжность;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуАналогичныхРабочихМестПоСтроке(ТекущиеДанные)

	Если ПустаяСтрока(ТекущиеДанные.ПредставлениеРабочегоМеста) Тогда
		Возврат;
	КонецЕсли;
	
	МассивАналогичныеМеста = Новый Массив;
	НайденныеСтроки = Объект.АналогичныеМеста.НайтиСтроки(Новый Структура("РабочееМесто", ТекущиеДанные.РабочееМесто));
	Для Каждого СтрокаАналогичныеМеста Из НайденныеСтроки Цикл
		МассивАналогичныеМеста.Добавить(Новый Структура("РабочееМесто, Представление", СтрокаАналогичныеМеста.АналогичноеМесто, ""));
	КонецЦикла;
	// Добавим текущее рабочее место в аналогичные места
	МассивАналогичныеМеста.Добавить(Новый Структура("РабочееМесто, Представление", ТекущиеДанные.РабочееМесто, ""));
	
	МассивРабочиеМеста = Новый Массив;
	Для Каждого СтрокаРабочиеМеста Из Объект.РабочиеМеста Цикл
		Если СтрокаРабочиеМеста.РабочееМесто = ТекущиеДанные.РабочееМесто
			И СтрокаРабочиеМеста.ПредставлениеРабочегоМеста = ТекущиеДанные.ПредставлениеРабочегоМеста Тогда
			// Текущую строку не добавляем в доступные рабочие места
			Продолжить;
		КонецЕсли;
		МассивРабочиеМеста.Добавить(Новый Структура("РабочееМесто, Представление", СтрокаРабочиеМеста.РабочееМесто, СтрокаРабочиеМеста.ПредставлениеРабочегоМеста));
	КонецЦикла;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("АналогичныеМеста", МассивАналогичныеМеста);
	ПараметрыОткрытия.Вставить("РабочиеМеста", МассивРабочиеМеста);
	ПараметрыОткрытия.Вставить("ПредставлениеГруппы", ТекущиеДанные.ПредставлениеРабочегоМеста);
	ПараметрыОткрытия.Вставить("ОсновноеРабочееМесто", ТекущиеДанные.РабочееМесто);
	ПараметрыОткрытия.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыделитьАналогичныеРабочиеМестаПослеЗакрытия", ЭтотОбъект);
	ОткрытьФорму("Документ.РезультатыСпецоценкиУсловийТруда.Форма.ФормаАналогичныхМест",
		ПараметрыОткрытия, ЭтотОбъект, , , , ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

#КонецОбласти