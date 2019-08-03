
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
		
		ПриПолученииДанныхНаСервере("Объект")
		
	КонецЕсли;
	
	УстановитьОтображениеПодсказки();
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтаФорма, "СотрудникиСотрудник");
	КонецЕсли; 
	
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

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ФиксацияЗаполнитьИдентификаторыФиксТЧ(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ФиксацияСохранитьРеквизитыФормыФикс(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ФиксацияВторичныхДанныхВДокументахФормы.УстановитьМодифицированность(ЭтотОбъект, Ложь);	
	ФиксацияЗаполнитьРеквизитыФормыФикс(ТекущийОбъект);
	ФиксацияУстановитьОбъектЗафиксирован();
	ФиксацияОбновитьФиксациюВФорме();
	
	УстановитьОтображениеПодсказки();
	
	ЗаполнитьПредставлениеДанныхВоинскогоУчета();
	
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ХодатайствоОБронированииГражданПребывающихВЗапасе", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыДанныеВоинскогоУчета" Тогда
		ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
		Для Каждого КлючИЗначение Из Параметр Цикл 
			Если ТекущиеДанные[КлючИЗначение.Ключ] <> КлючИЗначение.Значение Тогда
				ТекущиеДанные[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
				ФиксацияЗафиксироватьИзменениеРеквизита(КлючИЗначение.Ключ);
				ФиксацияЗафиксироватьИзменениеРеквизита("ДанныеВоинскогоУчета");
			КонецЕсли;
		КонецЦикла;
		ТекущиеДанные.ДанныеВоинскогоУчета = ПредставлениеДанныхВоинскогоУчета(ТекущиеДанные);
	КонецЕсли;
	
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудники

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбработкаПодбораНаСервере(ВыбранноеЗначение);

КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	
	СотрудникПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "СотрудникиДанныеВоинскогоУчета" Тогда
		
		ВоинскийУчет = Новый Структура("ФизическоеЛицо, Звание, Состав, ВУС, Годность, НаличиеМобпредписания, НомерКомандыПартии");
		ЗаполнитьЗначенияСвойств(ВоинскийУчет, Элементы.Сотрудники.ТекущиеДанные);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ВоинскийУчет", ВоинскийУчет);
		ПараметрыФормы.Вставить("ТолькоПросмотр", ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбъектФормыЗафиксирован(ЭтотОбъект));
		
		ОткрытьФорму("Документ.ХодатайствоОБронированииГражданПребывающихВЗапасе.Форма.РедактированиеДанныхВоинскогоУчета", ПараметрыФормы, ЭтотОбъект, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
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
Процедура Подбор(Команда)
	
	Отбор = Новый Структура;
	Отбор.Вставить("ДатаПримененияОтбора", Объект.Дата);
	Отбор.Вставить("ВАрхиве", Ложь);
		
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Отбор", Отбор);
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ГосударственнаяСлужбаКлиент");
		Модуль.УточнитьПараметрыОткрытияФормыВыбораСотрудников(ПараметрыОткрытия);
	КонецЕсли; 
		
	КадровыйУчетКлиент.ВыбратьФизическихЛицОрганизации(Элементы.Сотрудники, Объект.Организация, Истина, , АдресСпискаПодобранныхСотрудников(), , ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсеИсправления(Команда)
	
	ОтменитьВсеИсправленияНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
	ФиксацияВторичныхДанныхВДокументахФормы.ИнициализироватьМеханизмФиксацииРеквизитов(ЭтотОбъект, ТекущийОбъект);
	ФиксацияВторичныхДанныхВДокументахФормы.ПодключитьОбработчикиФиксацииИзмененийРеквизитов(ЭтотОбъект, ФиксацияЭлементыОбработчикаЗафиксироватьИзменение());
	ФиксацияВторичныхДанныхВДокументахФормы.УстановитьМодифицированность(ЭтотОбъект, Ложь);
	
	ОбновитьВторичныеДанныеДокумента();
	
	ФиксацияОбновитьФиксациюВФорме();
	
	ЗаполнитьПредставлениеДанныхВоинскогоУчета();
	
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПодбораНаСервере(ВыбранныеФизЛица)
	
	СтруктураПоиска = Новый Структура("ФизическоеЛицо");
	МассивФизЛицКЗаполнению = Новый Массив;
	
	Для Каждого ФизическоеЛицо Из ВыбранныеФизЛица Цикл
		СтруктураПоиска.ФизическоеЛицо = ФизическоеЛицо;
		Если Объект.Сотрудники.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда 
			МассивФизЛицКЗаполнению.Добавить(ФизическоеЛицо);	
		КонецЕсли;
	КонецЦикла;	
	
	Если МассивФизЛицКЗаполнению.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	КадровыеДанные = Документы.ХодатайствоОБронированииГражданПребывающихВЗапасе.КадровыеДанныеФизическихЛиц(МассивФизЛицКЗаполнению, Объект.Организация, Объект.Дата);
	
	Для Каждого КадровыеДанныеФизическогоЛица Из КадровыеДанные Цикл 
		НоваяСтрока = Объект.Сотрудники.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, КадровыеДанныеФизическогоЛица);
		НоваяСтрока.ДанныеВоинскогоУчета = ПредставлениеДанныхВоинскогоУчета(НоваяСтрока);
	КонецЦикла;
	
КонецПроцедуры	

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	
	ТекущиеДанные = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
	
	КадровыеДанные = Документы.ХодатайствоОБронированииГражданПребывающихВЗапасе.КадровыеДанныеФизическихЛиц(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТекущиеДанные.ФизическоеЛицо), Объект.Организация, Объект.Дата);
	
	Если КадровыеДанные.Количество() > 0 Тогда 
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, КадровыеДанные[0]);
	КонецЕсли;
	
	ТекущиеДанные.ДанныеВоинскогоУчета = ПредставлениеДанныхВоинскогоУчета(ТекущиеДанные);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеПодсказки()
	
	Отображение = ?(Объект.Проведен, ОтображениеПодсказки.ОтображатьСнизу, ОтображениеПодсказки.Нет);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Сотрудники", "ОтображениеПодсказки", Отображение);
	
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
	
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтаФорма, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));	
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиРасширеннаяПодсказкаОбработкаНавигационнойСсылки(Элемент, 
	НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура("Основание", Объект.Ссылка);
	ОткрытьФорму("Документ.БронированиеГражданПребывающихВЗапасе.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеДанныхВоинскогоУчета(ДанныеВоинскогоУчета)
	
	ПредставлениеДанных = "";
	ПредставлениеДанных = ПредставлениеДанных + ДанныеВоинскогоУчета.Состав;
	ПредставлениеДанных = ПредставлениеДанных + ?(ПредставлениеДанных = "" Или Не ЗначениеЗаполнено(ДанныеВоинскогоУчета.Звание), "", ", ") + ДанныеВоинскогоУчета.Звание;
	ПредставлениеДанных = ПредставлениеДанных + ?(ПредставлениеДанных = "" Или Не ЗначениеЗаполнено(ДанныеВоинскогоУчета.ВУС), "", ", ") + ДанныеВоинскогоУчета.ВУС;
	ПредставлениеДанных = ПредставлениеДанных + ?(ПредставлениеДанных = "" Или Не ЗначениеЗаполнено(ДанныеВоинскогоУчета.Годность), "", ", ") + ДанныеВоинскогоУчета.Годность;
	ПредставлениеДанных = ПредставлениеДанных + ?(ПредставлениеДанных = "" Или Не ДанныеВоинскогоУчета.НаличиеМобпредписания, "", ", ") + ?(ДанныеВоинскогоУчета.НаличиеМобпредписания, НСтр("ru = 'Есть мобпредписание'"), "");
	ПредставлениеДанных = ПредставлениеДанных + ?(ПредставлениеДанных = "" Или Не ЗначениеЗаполнено(ДанныеВоинскогоУчета.НомерКомандыПартии), "", ", ") + ДанныеВоинскогоУчета.НомерКомандыПартии;
	ПредставлениеДанных = ?(ПредставлениеДанных = "", НСтр("ru = 'Нет данных'"), ПредставлениеДанных);
	
	Возврат ПредставлениеДанных;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПредставлениеДанныхВоинскогоУчета()
	
	Для Каждого ДанныеСотрудника Из Объект.Сотрудники Цикл 
		ДанныеСотрудника.ДанныеВоинскогоУчета = ПредставлениеДанныхВоинскогоУчета(ДанныеСотрудника);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов()
	
	ОбъектЗафиксирован = ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбъектФормыЗафиксирован(ЭтотОбъект);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Шапка", "ТолькоПросмотр", ОбъектЗафиксирован);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Сотрудники", "ТолькоПросмотр", ОбъектЗафиксирован);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПодписиГруппа", "ТолькоПросмотр", ОбъектЗафиксирован);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СотрудникиПодбор", "Доступность", Не ОбъектЗафиксирован);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаОтменитьВсеИсправления", "Доступность", Не ОбъектЗафиксирован);
	
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(ОбщегоНазначения.ВыгрузитьКолонку(Объект.Сотрудники, "ФизическоеЛицо"), УникальныйИдентификатор);
	
КонецФункции

#Область МеханизмФиксацииИзменений

&НаСервере
Функция ОбъектЗафиксирован() Экспорт
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	Возврат ДокументОбъект.ОбъектЗафиксирован();
	
КонецФункции

&НаСервере
Функция ФиксацияОписаниеФормы(ПараметрыФиксацииВторичныхДанных) Экспорт
	
	ОписаниеФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеФормы();
	
	ОписаниеЭлементовФормы = Новый Соответствие();
	ОписаниеЭлементаФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеЭлементаФормы();
	
	ОписаниеЭлементаФормы.ПрефиксПути = "Объект";
	ОписаниеЭлементаФормы.ПрефиксПутиТекущиеДанные = "Элементы.Сотрудники.ТекущиеДанные";
	
	Для каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
		ОписаниеЭлементовФормы.Вставить(ОписаниеФиксацииРеквизита.Ключ, ОписаниеЭлементаФормы);
	КонецЦикла;
	
	ОписаниеФормы.Вставить("ОписаниеЭлементовФормы", ОписаниеЭлементовФормы);
	
	Возврат ОписаниеФормы;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ФиксацияЭлементыОбработчикаЗафиксироватьИзменение()
	
	ОписаниеЭлементов = Новый Соответствие;
	ОписаниеЭлементов.Вставить("СотрудникиПодразделение",			"Подразделение");
	ОписаниеЭлементов.Вставить("СотрудникиДолжность",				"Должность");
	ОписаниеЭлементов.Вставить("СотрудникиЗвание",					"Звание");
	ОписаниеЭлементов.Вставить("СотрудникиСостав",					"Состав");
	ОписаниеЭлементов.Вставить("СотрудникиВУС",						"ВУС");
	ОписаниеЭлементов.Вставить("СотрудникиГодность",				"Годность");
	ОписаниеЭлементов.Вставить("СотрудникиНаличиеМобпредписания",	"НаличиеМобпредписания");
	ОписаниеЭлементов.Вставить("СотрудникиНомерКомандыПартии",		"НомерКомандыПартии");
	ОписаниеЭлементов.Вставить("СотрудникиПунктПеречня",			"ПунктПеречня");
	ОписаниеЭлементов.Вставить("СотрудникиДанныеВоинскогоУчета",	"ДанныеВоинскогоУчета");
	
	Возврат	ОписаниеЭлементов;
	
КонецФункции

&НаКлиенте
Процедура ФиксацияЗафиксироватьИзменениеРеквизита(ИмяРеквизита)
	
	ТекущаяСтрока = Элементы.Сотрудники.ТекущаяСтрока;
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтаФорма, ИмяРеквизита, ТекущаяСтрока);
	
КонецПроцедуры

&НаСервере
Процедура ФиксацияОбновитьФиксациюВФорме()
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбновитьФорму(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ФиксацияЗаполнитьРеквизитыФормыФикс(ТекущийОбъект)
	ФиксацияВторичныхДанныхВДокументахФормы.ЗаполнитьРеквизитыФормыФикс(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ФиксацияЗаполнитьИдентификаторыФиксТЧ(Форма)
	
	ИменаРеквизитовИЭлементов = ФиксацияВторичныхДанныхВДокументахКлиентСервер.ИменаСлужебныхРеквизитовИЭлементовМеханизмаФиксацииДанных();
	ОписанияТЧ = Форма[ИменаРеквизитовИЭлементов.Получить("ПараметрыФиксацииВторичныхДанных")]["ОписанияТЧ"];
	
	Для каждого ОписаниеТЧ Из ОписанияТЧ Цикл
		ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗаполнитьИдентификаторыФиксТЧ(Форма.Объект[ОписаниеТЧ.Ключ]);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ФиксацияСохранитьРеквизитыФормыФикс(Форма, ТекущийОбъект)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СохранитьРеквизитыФормыФикс(Форма, ТекущийОбъект);
КонецПроцедуры

&НаСервере
Функция ФиксацияПодготовленныйДокумент()
	
	ФиксацияЗаполнитьИдентификаторыФиксТЧ(ЭтаФорма);
	ПодготовленныйДокумент = РеквизитФормыВЗначение("Объект");
	ФиксацияСохранитьРеквизитыФормыФикс(ЭтаФорма, ПодготовленныйДокумент);
	
	Возврат ПодготовленныйДокумент;
	
КонецФункции 

&НаСервере
Процедура ФиксацияУстановитьОбъектЗафиксирован();
	 ФиксацияВторичныхДанныхВДокументахФормы.УстановитьОбъектЗафиксирован(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ОбновитьВторичныеДанныеДокумента(СписокФизическихЛиц = Неопределено) Экспорт
	
	Если ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбъектФормыЗафиксирован(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Документ = ФиксацияПодготовленныйДокумент();
	
	Если Документ.ОбновитьТабличнуюЧастьСотрудники(СписокФизическихЛиц) Тогда
		Если НЕ Документ.ЭтоНовый() Тогда
			ФиксацияВторичныхДанныхВДокументахФормы.УстановитьМодифицированность(ЭтотОбъект, Истина);	
		КонецЕсли;		
		ЗначениеВРеквизитФормы(Документ, "Объект");
	КонецЕсли;
	
	ФиксацияЗаполнитьРеквизитыФормыФикс(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьВсеИсправленияНаСервере()

	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОчиститьФиксациюИзменений(ЭтаФорма, Объект);
	ФиксацияЗаполнитьРеквизитыФормыФикс(Объект);
	ОбновитьВторичныеДанныеДокумента();
	ФиксацияОбновитьФиксациюВФорме();
	ПриПолученииДанныхНаСервере("Объект")
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(Элемент, СтандартнаяОбработка = Ложь) Экспорт
	
	ТекущаяСтрока = Элементы.Сотрудники.ТекущаяСтрока;
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(ЭтаФорма, Элемент, ФиксацияЭлементыОбработчикаЗафиксироватьИзменение(), ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
