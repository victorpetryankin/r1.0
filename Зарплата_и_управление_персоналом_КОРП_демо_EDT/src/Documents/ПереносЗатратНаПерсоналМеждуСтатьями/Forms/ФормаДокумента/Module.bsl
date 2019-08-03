#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура;
		ЗначенияДляЗаполнения.Вставить("ПредыдущийМесяц",	"Объект.ПериодРегистрации");
		ЗначенияДляЗаполнения.Вставить("Организация",		"Объект.Организация");
		
		Если ПолучитьФункциональнуюОпцию("ВыполнятьРасчетЗарплатыПоПодразделениям") Тогда
			ЗначенияДляЗаполнения.Вставить("Подразделение", "Объект.Подразделение");
		КонецЕсли;
		
		ЗначенияДляЗаполнения.Вставить("Ответственный",		"Объект.Ответственный");
		
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ПриПолученииДанныхНаСервере();
		
	КонецЕсли;
	
	// Обработчик подсистемы "Версионирование".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	ОбменДаннымиЗарплатаКадры.ПриЧтенииНаСервереДокумента(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ПриПередачеДанныхНаСервере(ТекущийОбъект);
	
	Если НЕ ТекущийОбъект.ПроверитьЗаполнение() Тогда
		ОбработатьСообщенияПользователю();
		Отказ = Истина
	КонецЕсли;	
	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ПриПередачеДанныхНаСервере(ТекущийОбъект);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ПереносЗатратНаПерсоналМеждуСтатьями", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область РедактированиеМесяцаСтрокой

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура КомментарийНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		Форма,
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыНачисления

&НаКлиенте
Процедура ЗатратыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ЗатратыОбработкаВыбораНаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаСервере
Процедура ЗатратыОбработкаВыбораНаСервере(ВыбранноеЗначение)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Массив") Тогда
		ВыбранныеСотрудники = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыбранноеЗначение);
	Иначе
		ВыбранныеСотрудники = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ВыбранноеЗначение)
	КонецЕсли;
	
	Сотрудники = Новый Массив;
	Для Каждого Сотрудник Из ВыбранныеСотрудники Цикл
		
		СтрокиСотрудника = ПереносЗатрат.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
		
		Если СтрокиСотрудника.Количество() = 0 Тогда
			Сотрудники.Добавить(Сотрудник)
		КонецЕсли;
		
	КонецЦикла;
	
	ДополнитьНаСервере(Сотрудники);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗатратыПриАктивизацииСтроки(Элемент)
	РассчитатьСуммуОтмеченных()
КонецПроцедуры

&НаКлиенте
Процедура ПереносЗатратВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ИзменитьПереносыСтроки();
КонецПроцедуры

&НаКлиенте
Процедура ПереносЗатратПередУдалением(Элемент, Отказ)
	ИдентификаторыСтрок = ИдентификаторыВыделенныхЗатрат();
КонецПроцедуры

&НаКлиенте
Процедура ПереносЗатратПослеУдаления(Элемент)
	ПереносЗатратПослеУдаленияНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПереносЗатратПослеУдаленияНаСервере()
	
	Для Каждого ИдентификаторСтроки Из ИдентификаторыСтрок Цикл
		
		УдаляемыеСтроки = ПереносЗатрат.НайтиСтроки(Новый Структура("ИдентификаторСтрокиЗатрат", ИдентификаторСтроки));
		Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
			ПереносЗатрат.Удалить(УдаляемаяСтрока);
		КонецЦикла;	
		
	КонецЦикла;
	
	ПронумероватьПереносыЗатрат();
	
	РассчитатьИтоги();
	
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
	ЗаполнитьНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	
	НачалоПериодаПримененияОтбора = Объект.ПериодРегистрации;
	ОкончаниеПериодаПримененияОтбора = КонецМесяца(Объект.ПериодРегистрации);
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ПоказыватьПодработки", Истина);
	
	ПараметрыОткрытия = Новый Структура("Отбор", СтруктураОтбора);
	КадровыйУчетРасширенныйКлиент.ДобавитьПараметрыОтбораПоФункциональнойОпцииВыполнятьРасчетЗарплатыПоПодразделениям(
		ЭтаФорма, ПараметрыОткрытия);
		
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихВПериодеПоПараметрамОткрытияФормыСписка(
		Элементы.ПереносЗатрат,
		Объект.Организация,
		Объект.Подразделение,
		НачалоПериодаПримененияОтбора,
		ОкончаниеПериодаПримененияОтбора,
		,
		АдресСпискаПодобранныхСотрудников(),
		ПараметрыОткрытия);
		
КонецПроцедуры

&НаКлиенте
Процедура Подробно(Команда)
	
	Элементы.Подробно.Пометка = НЕ Элементы.Подробно.Пометка;
	Элементы.ПереносЗатратПодробноГруппа.Видимость = Элементы.Подробно.Пометка
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПереносы(Команда)
	ИзменитьПереносыСтроки();
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиЗатраты(Команда)
	
	Если Элементы.ПереносЗатрат.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	РезультатПроверки = "";
	АдресВХранилищеВыделенныхСтрок = АдресВХранилищеВыделенныхСтрок(Элементы.ПереносЗатрат.ВыделенныеСтроки, РезультатПроверки);
	
	Если Не ПустаяСтрока(РезультатПроверки) Тогда
		ПоказатьПредупреждение(, РезультатПроверки); 
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("СтатьяФинансированияДокумента", Объект.СтатьяФинансирования);
	ПараметрыОткрытия.Вставить("АдресВХранилищеВыделенныхСтрок", АдресВХранилищеВыделенныхСтрок);
	
	Оповещение = Новый ОписаниеОповещения("ПеренестиЗатратыЗавершение", ЭтотОбъект, АдресВХранилищеВыделенныхСтрок);
	ОткрытьФорму("Документ.ПереносЗатратНаПерсоналМеждуСтатьями.Форма.ПереносЗатрат", ПараметрыОткрытия, ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиЗатратыЗавершение(РезультатыРедактирования, АдресВХранилищеВыделенныхСтрок) Экспорт
	
	Если РезультатыРедактирования = Неопределено 
		ИЛИ РезультатыРедактирования.Сумма = 0 Тогда
		Возврат
	КонецЕсли;
	
	ПеренестиЗатратыЗавершениеНаСервере(РезультатыРедактирования, АдресВХранилищеВыделенныхСтрок)
	
КонецПроцедуры

&НаСервере
Процедура ПеренестиЗатратыЗавершениеНаСервере(РезультатыРедактирования, АдресВХранилищеВыделенныхСтрок)
	
	ВыделенныеСтроки = ПолучитьИзВременногоХранилища(АдресВХранилищеВыделенныхСтрок);
	
	ПереносимыеСтроки = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		Если ВыделеннаяСтрока.Исходная Тогда
			ПереносимыеСтроки.Добавить(ВыделеннаяСтрока.ИдентификаторСтрокиЗатрат);
		Иначе
			ПереносимыеСтроки.Добавить(ВыделеннаяСтрока.ИдентификаторСтрокиПереноса);
		КонецЕсли;	
	КонецЦикла;	
	
	Финансирование = Новый Структура;
	Для Каждого Свойство Из Документы.ПереносЗатратНаПерсоналМеждуСтатьями.РеквизитыФинансированияЗатрат() Цикл
		Если ЗначениеЗаполнено(РезультатыРедактирования[Свойство]) Тогда
			Финансирование.Вставить(Свойство, РезультатыРедактирования[Свойство]);
		КонецЕсли;	
	КонецЦикла;
	
	ПеренестиНаСервере(ПереносимыеСтроки, Финансирование, РезультатыРедактирования.Сумма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПереносы(Команда)
	ОтменитьПереносыНаСервере(ИдентификаторыВыделенныхЗатрат());
КонецПроцедуры

&НаСервере
Процедура ОтменитьПереносыНаСервере(ИдентификаторыСтрокЗатрат)
	
	ОтборПереносов = Новый Структура("ИдентификаторСтрокиЗатрат, Исходная");
	ОтборПереносов.Исходная = Ложь;
	
	Для Каждого ИдентификаторСтрокиЗатрат Из ИдентификаторыСтрокЗатрат Цикл
		ОтборПереносов.ИдентификаторСтрокиЗатрат = ИдентификаторСтрокиЗатрат;
		Для Каждого Строка Из ПереносЗатрат.НайтиСтроки(ОтборПереносов) Цикл
			ПереносЗатрат.Удалить(Строка);
			Модифицированность = Истина;
		КонецЦикла;
	КонецЦикла;
	
	ЗаполнитьОстаткиЗатрат(ИдентификаторыСтрокЗатрат);
	
	РассчитатьИтоги();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект = Неопределено)
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой");
	
	УчетСтраховыхВзносов.УстановитьВидимостьКолонокТаблицыСтраховыхВзносов(ЭтаФорма, Объект.ПериодРегистрации, "ПереносЗатрат");
	
	ЗаполнитьПереносыЗатратПоДокументу(ТекущийОбъект);
	
	ЗаполнитьОстаткиЗатрат();
	
	РассчитатьИтоги();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПереносыЗатратПоДокументу(ТекущийОбъект = Неопределено);
	
	Если ТекущийОбъект = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПереносЗатрат.Очистить();
	
	ПараметрыОтбораПереносов = Новый Структура("ИдентификаторСтрокиЗатрат");
	
	Для Каждого СтрокаЗатрат Из ТекущийОбъект.Затраты Цикл
		
		ИсходнаяСтрока = ВставитьСтрокуЗатрат(ПереносЗатрат.Количество(), СтрокаЗатрат);
		Для Каждого РеквизитДетализацииЗатрат Из Документы.ПереносЗатратНаПерсоналМеждуСтатьями.РеквизитыСуммЗатрат() Цикл
			ИсходнаяСтрока[РеквизитДетализацииЗатрат+"Было"] = ИсходнаяСтрока[РеквизитДетализацииЗатрат];
		КонецЦикла;	
		
		ПараметрыОтбораПереносов.ИдентификаторСтрокиЗатрат = СтрокаЗатрат.ИдентификаторСтрокиЗатрат;
		СтрокиПереносов = ТекущийОбъект.Переносы.НайтиСтроки(ПараметрыОтбораПереносов);
		
		ВставитьСтрокиПереносов(ИсходнаяСтрока, СтрокиПереносов)	
		
	КонецЦикла;
	
	ПронумероватьПереносыЗатрат();
	
	ПереносЗатрат.Сортировать("НомерСтрокиЗатрат, Исходная Убыв");
	
КонецПроцедуры

&НаСервере
Функция ВставитьСтрокуЗатрат(Индекс, СтрокаЗатрат)
	
	СтрокаПереносовЗатрат = ПереносЗатрат.Вставить(Индекс);
	СтрокаПереносовЗатрат.Исходная = Истина;
	СтрокаПереносовЗатрат.ИдентификаторСтрокиЗатрат		= СтрокаЗатрат.ИдентификаторСтрокиЗатрат;
	СтрокаПереносовЗатрат.ИдентификаторСтрокиПереноса	= СтрокаЗатрат.ИдентификаторСтрокиЗатрат;
	ЗаполнитьЗначенияСвойств(
		СтрокаПереносовЗатрат, 
		СтрокаЗатрат, 
		СтрСоединить(Документы.ПереносЗатратНаПерсоналМеждуСтатьями.РеквизитыИзмеренийЗатрат(), ","));
	ЗаполнитьЗначенияСвойств(
		СтрокаПереносовЗатрат, 
		СтрокаЗатрат, 
		СтрСоединить(Документы.ПереносЗатратНаПерсоналМеждуСтатьями.РеквизитыФинансированияЗатрат(), ","));
	СтрокаПереносовЗатрат.Сумма = СтрокаЗатрат.Сумма;
	ЗаполнитьЗначенияСвойств(
		СтрокаПереносовЗатрат, 
		СтрокаЗатрат, 
		СтрСоединить(Документы.ПереносЗатратНаПерсоналМеждуСтатьями.РеквизитыДетализацииЗатрат(), ","));
		
	Возврат СтрокаПереносовЗатрат;
	
КонецФункции

&НаСервере
Процедура ВставитьСтрокиПереносов(СтрокаЗатрат, СтрокиПереносов)
	
	Индекс = ПереносЗатрат.Индекс(СтрокаЗатрат);
	
	Для Каждого СтрокаПереносов Из СтрокиПереносов Цикл
		
		Индекс = Индекс + 1;		
		СтрокаПереносовЗатрат = ПереносЗатрат.Вставить(Индекс);
		СтрокаПереносовЗатрат.Исходная = Ложь;
		
		ЗаполнитьЗначенияСвойств(
			СтрокаПереносовЗатрат, 
			СтрокаПереносов,
			"ИдентификаторСтрокиЗатрат, ИдентификаторСтрокиПереноса");
			
		ЗаполнитьЗначенияСвойств(
			СтрокаПереносовЗатрат, 
			СтрокаЗатрат, 
			СтрСоединить(Документы.ПереносЗатратНаПерсоналМеждуСтатьями.РеквизитыИзмеренийЗатрат(), ","));
			
		ЗаполнитьЗначенияСвойств(
			СтрокаПереносовЗатрат, 
			СтрокаПереносов, 
			СтрСоединить(Документы.ПереносЗатратНаПерсоналМеждуСтатьями.РеквизитыФинансированияЗатрат(), ","));
		
		СтрокаПереносовЗатрат.Сумма = СтрокаПереносов.Сумма;
		Доля = СтрокаПереносов.Сумма / СтрокаЗатрат.СуммаБыло;
		Для Каждого РеквизитДетализацииЗатрат Из Документы.ПереносЗатратНаПерсоналМеждуСтатьями.РеквизитыДетализацииЗатрат() Цикл
			СтрокаПереносовЗатрат[РеквизитДетализацииЗатрат] = СтрокаЗатрат[РеквизитДетализацииЗатрат+"Было"] * Доля;
		КонецЦикла;	
		
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере 
Процедура ПронумероватьПереносыЗатрат();
	
	НомерСтроки = 0;
	ИдентификаторСтрокиЗатрат = Неопределено;
	Для Каждого Строка Из ПереносЗатрат Цикл
		Если Строка.ИдентификаторСтрокиЗатрат <> ИдентификаторСтрокиЗатрат Тогда
			ИдентификаторСтрокиЗатрат = Строка.ИдентификаторСтрокиЗатрат;
			НомерСтроки = НомерСтроки + 1;
		КонецЕсли;	
		Строка.НомерСтрокиЗатрат = НомерСтроки;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриПередачеДанныхНаСервере(ТекущийОбъект = Неопределено)
	ЗаполнитьДокументПоПереносамЗатрат(ТекущийОбъект)
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокументПоПереносамЗатрат(ТекущийОбъект);
	
	ПоляОписанияТЧ = "Имя, ПолеКлюча, Исходная";
	ОписанияТЧ = Новый Массив;
	ОписанияТЧ.Добавить(Новый Структура(ПоляОписанияТЧ, "Затраты", "ИдентификаторСтрокиЗатрат",		Истина));
	ОписанияТЧ.Добавить(Новый Структура(ПоляОписанияТЧ, "Переносы", "ИдентификаторСтрокиПереноса",	Ложь));
	
	Для Каждого ОписаниеТЧ Из ОписанияТЧ Цикл
		
		ТЧ = ТекущийОбъект[ОписаниеТЧ.Имя];
		
		// Удаляем ненужные строки в документе
		УдаляемыеСтроки = Новый Массив;
		Для Каждого СтрокаТЧ Из ТЧ Цикл
			Если ПереносЗатрат.НайтиСтроки(Новый Структура(ОписаниеТЧ.ПолеКлюча, СтрокаТЧ[ОписаниеТЧ.ПолеКлюча])).Количество() = 0 Тогда
				УдаляемыеСтроки.Добавить(СтрокаТЧ)
			КонецЕсли;
		КонецЦикла;	
		Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
			ТЧ.Удалить(УдаляемаяСтрока);
		КонецЦикла;	
		
		// Добавляем новые строки, обновляем сохранившиеся
		СтрокиФормы = ПереносЗатрат.НайтиСтроки(Новый Структура("Исходная", ОписаниеТЧ.Исходная));
		Для Каждого СтрокаФормы Из СтрокиФормы Цикл	
			Если СтрокаФормы.Исходная Тогда
				Для Каждого РеквизитДетализацииЗатрат Из Документы.ПереносЗатратНаПерсоналМеждуСтатьями.РеквизитыСуммЗатрат() Цикл
					СтрокаФормы[РеквизитДетализацииЗатрат] = СтрокаФормы[РеквизитДетализацииЗатрат+"Было"];
				КонецЦикла;	
			КонецЕсли;	
			СтрокаТЧ = ТЧ.Найти(СтрокаФормы[ОписаниеТЧ.ПолеКлюча]); 
			Если СтрокаТЧ = Неопределено Тогда
				СтрокаТЧ = ТЧ.Добавить()
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(СтрокаТЧ, СтрокаФормы);
		КонецЦикла;	
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОстаткиЗатрат(ИдентификаторыСтрокЗатрат = Неопределено)
	
	Если ИдентификаторыСтрокЗатрат = Неопределено Тогда
		ИдентификаторыСтрокЗатрат = ПереносЗатрат.Выгрузить(Новый Структура("Исходная", Истина), "ИдентификаторСтрокиЗатрат").ВыгрузитьКолонку("ИдентификаторСтрокиЗатрат");
	КонецЕсли;	
	
	ОтборПереносов = Новый Структура("Исходная, ИдентификаторСтрокиЗатрат", Ложь);
	Для Каждого ИдентификаторСтрокиЗатрат Из ИдентификаторыСтрокЗатрат Цикл
		
		ИсходнаяСтрока = ПереносЗатрат.НайтиСтроки(Новый Структура("Исходная, ИдентификаторСтрокиЗатрат", Истина, ИдентификаторСтрокиЗатрат))[0];
		
		ОтборПереносов.ИдентификаторСтрокиЗатрат = ИдентификаторСтрокиЗатрат;
		ИсходнаяСтрока.Сумма = ИсходнаяСтрока.СуммаБыло - ПереносЗатрат.Выгрузить(ОтборПереносов, "Сумма").Итог("Сумма");
		
		Доля = ?(ИсходнаяСтрока.СуммаБыло = 0,0,ИсходнаяСтрока.Сумма / ИсходнаяСтрока.СуммаБыло);
		Для Каждого РеквизитДетализацииЗатрат Из Документы.ПереносЗатратНаПерсоналМеждуСтатьями.РеквизитыДетализацииЗатрат() Цикл
			ИсходнаяСтрока[РеквизитДетализацииЗатрат] = ИсходнаяСтрока[РеквизитДетализацииЗатрат+"Было"] * Доля;
		КонецЦикла;	
		
		ИсходнаяСтрока.Сторно = ИсходнаяСтрока.Сумма = 0;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьИтоги()
	
	ОтборИсходных= Новый Структура("СтатьяФинансирования, Исходная", Объект.СтатьяФинансирования, Истина);
	ЗатратыБыло	 = ПереносЗатрат.Выгрузить(ОтборИсходных, "СуммаБыло").Итог("СуммаБыло");
	
	ОтборПереносовВсех = Новый Структура("Исходная", Ложь);
	ОтборПереносовПоСтатье = Новый Структура("СтатьяФинансирования, Исходная", Объект.СтатьяФинансирования, Ложь);
	
	ДобавилиНаСтатью = ПереносЗатрат.Выгрузить(ОтборПереносовПоСтатье, "Сумма").Итог("Сумма");
	УбралиЗатрат = ПереносЗатрат.Выгрузить(ОтборПереносовВсех, "Сумма").Итог("Сумма") - ПереносЗатрат.Выгрузить(ОтборПереносовПоСтатье, "Сумма").Итог("Сумма");
	ЗатратыСтало = ЗатратыБыло - УбралиЗатрат +  ДобавилиНаСтатью;
	
	ОтборИтогов  = Новый Структура("Исходная", Истина);
	ПоляСуммЗатрат = Документы.ПереносЗатратНаПерсоналМеждуСтатьями.РеквизитыСуммЗатрат();
	ТаблицаЗатрат = ПереносЗатрат.Выгрузить(ОтборИтогов, СтрСоединить(ПоляСуммЗатрат, ", "));
	
	ПереносЗатратИтого.Очистить();
	ПереносЗатратИтого.Добавить();
	Для Каждого ПолеСуммыЗатрат Из ПоляСуммЗатрат Цикл
		ПереносЗатратИтого[0][ПолеСуммыЗатрат] = ТаблицаЗатрат.Итог(ПолеСуммыЗатрат)
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуОтмеченных()
	
	СуммаОтмеченных = 0;
	Для Каждого ВыделеннаяСтрока Из Элементы.ПереносЗатрат.ВыделенныеСтроки Цикл
		Строка = ПереносЗатрат.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Если Строка <> Неопределено Тогда
			СуммаОтмеченных = СуммаОтмеченных + Строка.Сумма;
		КонецЕсли	
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	Если ДокументОбъект.МожноЗаполнитьЗатраты() Тогда
		ДокументОбъект.ЗаполнитьЗатраты();
	КонецЕсли;	
	
	ОбработатьСообщенияПользователю();
	
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	ПриПолученииДанныхНаСервере(ДокументОбъект);	
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьНаСервере(Сотрудники)
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
 	ПриПередачеДанныхНаСервере(ДокументОбъект);
	
	Если ДокументОбъект.МожноЗаполнитьЗатраты() Тогда
		ДокументОбъект.ДополнитьЗатраты(Сотрудники);
	КонецЕсли;	
	
	ОбработатьСообщенияПользователю();
	
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	ПриПолученииДанныхНаСервере(ДокументОбъект);	
	
КонецПроцедуры

&НаСервере
Процедура ПеренестиНаСервере(ПереносимыеСтроки, Финансирование, Сумма)
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
 	ПриПередачеДанныхНаСервере(ДокументОбъект);
	
	ДокументОбъект.ПеренестиЗатраты(ПереносимыеСтроки, Финансирование, Сумма);
	
	ОбработатьСообщенияПользователю();
	
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	ПриПолученииДанныхНаСервере(ДокументОбъект);	
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьСообщенияПользователю()
	
	Сообщения = ПолучитьСообщенияПользователю(Ложь);
	
	Для Каждого Сообщение Из Сообщения Цикл
		Если СтрНайти(Сообщение.Поле, "ПериодРегистрации") Тогда
			Сообщение.Поле = "";
			Сообщение.ПутьКДанным = "ПериодРегистрацииСтрокой";
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПереносыСтроки()
	
	Если Элементы.ПереносЗатрат.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	ДанныеСтроки = Элементы.ПереносЗатрат.ТекущиеДанные;
	
	ПараметрыОткрытия = Новый Структура;
	
	ПараметрыОткрытия.Вставить("Организация",			ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"));
	ПараметрыОткрытия.Вставить("ПериодРегистрации",		Дата(1,1,1));
	ПараметрыОткрытия.Вставить("Сотрудник",				ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка"));
	ПараметрыОткрытия.Вставить("Подразделение",			ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка"));
	ПараметрыОткрытия.Вставить("Начисление",			Неопределено);
	
	ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, Объект);
	ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, ДанныеСтроки);
	
	ПараметрыОткрытия.Вставить("ИдентификаторСтрокиЗатрат",	ДанныеСтроки.ИдентификаторСтрокиЗатрат);
	ПараметрыОткрытия.Вставить("АдресВХранилищеПереносовСтрокиЗатрат", АдресВХранилищеПереносовСтрокиЗатрат(ДанныеСтроки.ИдентификаторСтрокиЗатрат));
	
	ПараметрыОткрытия.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	
	Оповещение = Новый ОписаниеОповещения("ИзменитьПереносыСтрокиЗавершение", ЭтотОбъект);
	ОткрытьФорму("Документ.ПереносЗатратНаПерсоналМеждуСтатьями.Форма.ИзменениеПереносов", ПараметрыОткрытия, ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПереносыСтрокиЗавершение(РезультатыРедактирования, ДополнительныеПараметры) Экспорт
	
	Если РезультатыРедактирования <> Неопределено И РезультатыРедактирования.Модифицированность Тогда
		ИзменитьПереносыЗавершениеНаСервере(РезультатыРедактирования)
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьПереносыЗавершениеНаСервере(РезультатыРедактирования)

	ИдентификаторСтрокиЗатрат	= РезультатыРедактирования.ИдентификаторСтрокиЗатрат;
	ПереносыПоСтроке = ПолучитьИзВременногоХранилища(РезультатыРедактирования.АдресВХранилищеПереносовСтрокиЗатрат);
	
	ПараметрыОтбора = Новый Структура("ИдентификаторСтрокиЗатрат, Исходная", ИдентификаторСтрокиЗатрат);
	
	ПараметрыОтбора.Исходная = Истина;
	СтрокаЗатрат = ПереносЗатрат.НайтиСтроки(ПараметрыОтбора)[0];
	
	// Удаляем старые переносы
	ПараметрыОтбора.Исходная = Ложь;
	УдаляемыеСтроки = ПереносЗатрат.НайтиСтроки(ПараметрыОтбора);
	Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
		ПереносЗатрат.Удалить(УдаляемаяСтрока);
	КонецЦикла;	
	
	// Помещаем новые переносы строки затрат
	ВставитьСтрокиПереносов(СтрокаЗатрат, ПереносыПоСтроке);	
	
	ЗаполнитьОстаткиЗатрат(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ИдентификаторСтрокиЗатрат));
	
	РассчитатьИтоги();
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Функция ИдентификаторыВыделенныхЗатрат()
	
	ИдентификаторыСтрокЗатрат = Новый Массив;
	
	Для Каждого ВыделеннаяСтрока Из Элементы.ПереносЗатрат.ВыделенныеСтроки Цикл
		
		Строка = ПереносЗатрат.НайтиПоИдентификатору(ВыделеннаяСтрока);
		
		Если Строка <> Неопределено Тогда
			ИдентификаторыСтрокЗатрат.Добавить(Строка.ИдентификаторСтрокиЗатрат);
		КонецЕсли	
		
	КонецЦикла;	

	Возврат Новый ФиксированныйМассив(ОбщегоНазначенияКлиентСервер.СвернутьМассив(ИдентификаторыСтрокЗатрат));
	
КонецФункции

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	Возврат ПоместитьВоВременноеХранилище(ПереносЗатрат.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
КонецФункции

&НаСервере
Функция АдресВХранилищеПереносовСтрокиЗатрат(ИдентификаторСтрокиЗатрат)
	
	РеквизитыЗатрат = Документы.ПереносЗатратНаПерсоналМеждуСтатьями.РеквизитыФинансированияЗатрат();
	РеквизитыЗатрат.Добавить("ИдентификаторСтрокиЗатрат");
	РеквизитыЗатрат.Добавить("ИдентификаторСтрокиПереноса");
	РеквизитыЗатрат.Добавить("Сумма");
	КолонкиЗатрат = СтрСоединить(РеквизитыЗатрат, ", ");
	
	ПараметрыОтбора	= Новый Структура("ИдентификаторСтрокиЗатрат, Исходная", ИдентификаторСтрокиЗатрат);
	
	ПараметрыОтбора.Исходная = Истина;
	СтрокаЗатрат = ПереносЗатрат.НайтиСтроки(ПараметрыОтбора)[0];
	Затраты = ПереносЗатрат.Выгрузить(ПараметрыОтбора, КолонкиЗатрат);
	Затраты[0].Сумма = СтрокаЗатрат.СуммаБыло;
	
	ЗатратыПоСтроке = Новый Структура;
	ЗатратыПоСтроке.Вставить(
		"Затраты",
		Затраты);
		
		ПараметрыОтбора.Исходная = Ложь;
	ЗатратыПоСтроке.Вставить(
		"Переносы", 			
		ПереносЗатрат.Выгрузить(ПараметрыОтбора, КолонкиЗатрат)); 
 
	Возврат ПоместитьВоВременноеХранилище(ЗатратыПоСтроке, УникальныйИдентификатор);
	
КонецФункции	

&НаСервере
Функция АдресВХранилищеВыделенныхСтрок(Знач ВыделенныеСтроки, РезультатПроверки)

	ВыбраныИсправленныеСтроки = Ложь;
	ВыбраныСтрокиСторно 	  = Ложь;
	ЕстьПоложительныеСуммы    = Ложь;
	ЕстьОтрицательныеСуммы    = Ложь;
	ЕстьСтрокиПоВыбраннойСтатье = Ложь;
	ЕстьСтрокиПоДругимСтатьям   = Ложь;
	МножественныйВыбор = (ВыделенныеСтроки.Количество()>0);
	
	ВыбранныеСтроки = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		СтрокаТЧ = ПереносЗатрат.НайтиПоИдентификатору(ВыделеннаяСтрока);
		ВыбранныеСтроки.Добавить(СтрокаТЧ);
		Если Не СтрокаТЧ.Исходная Тогда
			ВыбраныИсправленныеСтроки = Истина;
		ИначеЕсли СтрокаТЧ.Сторно Тогда
			ВыбраныСтрокиСторно = Истина;
		КонецЕсли;
		
		Если СтрокаТЧ.Сумма > 0 Тогда
			ЕстьПоложительныеСуммы = Истина;
		ИначеЕсли СтрокаТЧ.Сумма < 0 Тогда
			ЕстьОтрицательныеСуммы = Истина;
		КонецЕсли;
		
		Если СтрокаТЧ.СтатьяФинансирования = Объект.СтатьяФинансирования Тогда
			ЕстьСтрокиПоВыбраннойСтатье = Истина;
		Иначе
			ЕстьСтрокиПоДругимСтатьям = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЕстьПоложительныеСуммы И ЕстьОтрицательныеСуммы Тогда
		РезультатПроверки = НСтр("ru = 'Перенос затрат отменен. В выбранных строках суммы должны быть одинакового знака.'");
	ИначеЕсли ВыбраныСтрокиСторно Тогда
		Если МножественныйВыбор Тогда
			РезультатПроверки = НСтр("ru = 'Перенос затрат отменен. В выбранных строках не должно быть нулевых сумм.'");
		Иначе
			РезультатПроверки = НСтр("ru = 'Перенос затрат отменен. Выбранная строка не содержит суммы для переноса.'");
		КонецЕсли;
	ИначеЕсли ВыбраныИсправленныеСтроки Тогда
		Если МножественныйВыбор Тогда
			РезультатПроверки = НСтр("ru = 'Перенос затрат отменен. В выбранных строках не должно быть строк, которые являются результатом переноса.'");
		Иначе
			РезультатПроверки = НСтр("ru = 'Перенос затрат отменен. Выбранная строка является результатом переноса.'");
		КонецЕсли;
	ИначеЕсли ЕстьСтрокиПоВыбраннойСтатье И ЕстьСтрокиПоДругимСтатьям Тогда
		РезультатПроверки = НСтр("ru = 'Перенос затрат отменен. В выбранных строках не должно быть одновременно строк, по статье заданной в документе и другим статьям финасирования.'");	
	КонецЕсли;
	
	Если Не ПустаяСтрока(РезультатПроверки) Тогда
		Возврат "";
	КонецЕсли;
	
	РеквизитыЗатрат = Документы.ПереносЗатратНаПерсоналМеждуСтатьями.РеквизитыФинансированияЗатрат();
	РеквизитыЗатрат.Добавить("Исходная");
	РеквизитыЗатрат.Добавить("ИдентификаторСтрокиЗатрат");
	РеквизитыЗатрат.Добавить("ИдентификаторСтрокиПереноса");
	РеквизитыЗатрат.Добавить("Сумма");
	КолонкиЗатрат = СтрСоединить(РеквизитыЗатрат, ", ");
	
	Возврат ПоместитьВоВременноеХранилище(ПереносЗатрат.Выгрузить(ВыбранныеСтроки, КолонкиЗатрат), УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти
