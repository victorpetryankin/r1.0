
&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// инициализируем контекст ЭДО - модуль обработки
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	Если КонтекстЭДОСервер = Неопределено Тогда 
		Элементы.РегистрСведенийСписок.ТолькоПросмотр = НЕ Пользователи.ЭтоПолноправныйПользователь();
	Иначе
		Элементы.РегистрСведенийСписок.ТолькоПросмотр = НЕ КонтекстЭДОСервер.ТекущийПользовательЯвляетсяАдминистраторомУчетныхЗаписейДокументооборота();
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ТранспортноеСообщение") Тогда
		ТранспортноеСообщение = Параметры.Отбор.ТранспортноеСообщение;
		
		// Установка значения отбора в компоновщике настроек.
		ЭлементОтбораДанных = Список.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
		ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТранспортноеСообщение");
		ЭлементОтбораДанных.ПравоеЗначение = ТранспортноеСообщение;
		ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.Использование = Истина;
		
		// Удаление отбора из параметров.
		Параметры.Отбор.Удалить("ТранспортноеСообщение"); 
	КонецЕсли;
	
	Список.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыгрузить(Команда)
	
	ТекСтроки = Элементы.РегистрСведенийСписок.ВыделенныеСтроки;
	Если ТекСтроки.Количество() <> 0 Тогда
		
		Если НЕ ПолучитьДанныеНаСервере(ТекСтроки) ИЛИ ВыборкаСодержимого.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		Всего = 0;
		ВАрхиве = 0;
		Для каждого Вложение Из ВыборкаСодержимого Цикл
			Всего = Всего + 1;
			Если Вложение.ВАрхиве Тогда 
				ВАрхиве = ВАрхиве + 1;
			КонецЕсли;
		КонецЦикла; 
		
		Если ВАрхиве > 0 Тогда
			ОписаниеОповещения  = ?(ВАрхиве = Всего, Неопределено, Новый ОписаниеОповещения("КомандаВыгрузитьВложенияПродолжение", ЭтотОбъект));
			КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(ОписаниеОповещения, 18 + ?(ВАрхиве = Всего, 1, 0), 0, ВАрхиве = Всего);
			Возврат;
		КонецЕсли;
		
		КомандаВыгрузитьВложенияПродолжение(КодВозвратаДиалога.Да, Неопределено);
	    						
	Иначе
		
		ПоказатьПредупреждение(, "Выберите файлы, которые следует сохранить на диск, и повторите попытку.
		|Для множественного выбора используйте клавишу Ctrl.");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыгрузитьВложенияПродолжение(Результат, ВхПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;
	
	МассивИменФайлов = Новый Массив;
	МассивОписанийПолучаемыеФайлы = Новый Массив;
	Для Каждого Контейнер Из ВыборкаСодержимого Цикл 
		Если Контейнер.ВАрхиве Тогда
			Продолжить;
		КонецЕсли;
		МассивИменФайлов.Добавить(Контейнер.КороткоеИмяФайла);
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(Контейнер.КороткоеИмяФайла, Контейнер.АдресСодержимого); 
		МассивОписанийПолучаемыеФайлы.Добавить(ОписаниеФайла);
	КонецЦикла;
	
	ОперацииСФайламиЭДКОКлиент.СохранитьФайлы(МассивОписанийПолучаемыеФайлы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОчиститьТаблицуИХранилище()
	
	Если ВыборкаСодержимого.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Выборка Из ВыборкаСодержимого Цикл 
		УдалитьИзВременногоХранилища(Выборка.АдресСодержимого);
	КонецЦикла;
	
	ВыборкаСодержимого.Очистить();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеНаСервере(ТекСтроки)
	
	// инициализируем контекст ЭДО - модуль обработки
	ТекстСообщения = "";
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДОСервер = Неопределено Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Ложь;
	КонецЕсли;
	
	ОчиститьТаблицуИХранилище();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СодержимоеТранспортныхКонтейнеров.ТранспортноеСообщение,
	|	СодержимоеТранспортныхКонтейнеров.ИмяФайла,
	|	СодержимоеТранспортныхКонтейнеров.Данные,
	|	СодержимоеТранспортныхКонтейнеров.Тип
	|	, ВЫБОР
	|		КОГДА СостояниеОбъектов.Архивный ЕСТЬ NULL ТОГДА Ложь
	|		КОГДА СостояниеОбъектов.Архивный = Ложь ТОГДА Ложь
	|	ИНАЧЕ
	|		Истина
	|	КОНЕЦ ВАрхиве
	|ИЗ
	|	РегистрСведений.СодержимоеТранспортныхКонтейнеров КАК СодержимоеТранспортныхКонтейнеров
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПризнакиАрхивированияФайловДОСКонтролирующимиОрганами КАК СостояниеОбъектов
	|			ПО 		(СостояниеОбъектов.Объект = СодержимоеТранспортныхКонтейнеров.ТранспортноеСообщение)
	|				И	(СостояниеОбъектов.ИмяФайла = СодержимоеТранспортныхКонтейнеров.ИмяФайла)
	|				И	(СостояниеОбъектов.Владелец = Значение(Перечисление.ВидыАрхивируемыхМетаданныхДО.СодержимоеТранспортныхКонтейнеров))
	|
	|ГДЕ";
	НомерСтроки = 1;
	Для Каждого ТекСтрока Из ТекСтроки Цикл
		ИмяПпараметраСообщение = "Сообщение" + Формат(НомерСтроки, "ЧГ=");
		ИмяПараметраИмяФайла = "ИмяФайла" + Формат(НомерСтроки, "ЧГ=");
		Запрос.Текст = Запрос.Текст + "
		| " + ?(НомерСтроки = 1, "", " ИЛИ ") + "(СодержимоеТранспортныхКонтейнеров.ТранспортноеСообщение = &" + ИмяПпараметраСообщение
		+	" И СодержимоеТранспортныхКонтейнеров.ИмяФайла = &" + ИмяПараметраИмяФайла + ")";
		Запрос.УстановитьПараметр(ИмяПпараметраСообщение, ТекСтрока.ТранспортноеСообщение);
		Запрос.УстановитьПараметр(ИмяПараметраИмяФайла, ТекСтрока.ИмяФайла);
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	
	Для каждого СтрокаТаблицыЗапроса Из ТаблицаЗапроса Цикл
		ДвоичныеДанныеФайла = Неопределено;
		Если СтрокаТаблицыЗапроса.Данные.Получить() = Неопределено Тогда
			МассивФайлов = ОбщегоНазначенияЭДКО.ПрикрепленныеФайлыКОбъектуИзСправочника(
				СтрокаТаблицыЗапроса.ТранспортноеСообщение,
				"ТранспортноеСообщениеПрисоединенныеФайлы",
				СтрокаТаблицыЗапроса.ИмяФайла);
			Если МассивФайлов.Количество() > 0 Тогда
				ДвоичныеДанныеФайла = РаботаСФайлами.ДвоичныеДанныеФайла(МассивФайлов[0]);
			КонецЕсли;
		КонецЕсли;
		Если ДвоичныеДанныеФайла = Неопределено Тогда
			ДвоичныеДанныеФайла = СтрокаТаблицыЗапроса.Данные.Получить();
		КонецЕсли;
		
		НоваяСтрока = ВыборкаСодержимого.Добавить();
		ГУИД = Новый УникальныйИдентификатор;
		НоваяСтрока.КороткоеИмяФайла = СтрокаТаблицыЗапроса.ИмяФайла;
		НоваяСтрока.ВАрхиве = СтрокаТаблицыЗапроса.ВАрхиве;
		НоваяСтрока.АдресСодержимого = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла, ГУИД);
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

#КонецОбласти

