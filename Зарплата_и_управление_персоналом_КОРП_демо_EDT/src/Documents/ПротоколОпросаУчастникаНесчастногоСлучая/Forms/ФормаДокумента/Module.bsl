
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
		
		ОрганизацияПриИзмененииНаСервере();
		
		ПриПолученииДанныхНаСервере();
		Объект.ВидОпрашиваемогоЛица = "Пострадавший";
		
	КонецЕсли;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов"
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
	
	ПриПолученииДанныхНаСервере();
	
	ОбменДаннымиЗарплатаКадры.ПриЧтенииНаСервереДокумента(ЭтотОбъект, ТекущийОбъект);
	
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
	Оповестить("Запись_ПротоколОпросаУчастникаНесчастногоСлучая", ПараметрыЗаписи, Объект.Ссылка);
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
Процедура РуководительПриИзменении(Элемент)
	НастроитьОтображениеГруппыПодписей();
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйЗаОхрануТрудаПриИзменении(Элемент)
	НастроитьОтображениеГруппыПодписей();
КонецПроцедуры

&НаКлиенте
Процедура ЭлементРедактированияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОповещения = Новый Структура;
	ИмяЭлемента = Элемент.Имя;
	Если ТипЗнч(ЭтотОбъект.ТекущийЭлемент) = Тип("ТаблицаФормы") Тогда
		ИмяЭлемента = СтрЗаменить(ИмяЭлемента, ЭтотОбъект.ТекущийЭлемент.Имя, "");
		ПараметрыОповещения.Вставить("ТаблицаФормы", ЭтотОбъект.ТекущийЭлемент.Имя);
	КонецЕсли;
	ПараметрыОповещения.Вставить("ИмяЭлемента", ИмяЭлемента);
	Оповещение = Новый ОписаниеОповещения("ЭлементРедактированияЗавершениеВвода", ЭтотОбъект, ПараметрыОповещения);
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(
		Оповещение,
		Элемент.ТекстРедактирования,
		Элемент.Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОпрашиваемогоЛицаПриИзменении(Элемент)
	
	Если Объект.ВидОпрашиваемогоЛица <> ВидОпрашиваемогоЛицаПредыдущий Тогда
		Объект.ОпрашиваемоеЛицо = ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка");
		ВидОпрашиваемогоЛицаПредыдущий = Объект.ВидОпрашиваемогоЛица;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпрашиваемоеЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Объект.ВидОпрашиваемогоЛица = "Пострадавший" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОпрашиваемоеЛицоВыборЗавершение", ЭтотОбъект);
		ПоказатьВыборИзСписка(ОписаниеОповещения, СписокПострадавших(), Элемент);
		
	ИначеЕсли Объект.ВидОпрашиваемогоЛица = "Очевидец" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОпрашиваемоеЛицоВыборЗавершение", ЭтотОбъект);
		ПоказатьВыборИзСписка(ОписаниеОповещения, СписокОчевидцев(), Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпрашиваемоеЛицоВыборЗавершение(СписокЭлемент, ДополнительныеПараметры) Экспорт
	
	Если СписокЭлемент = Неопределено Тогда
		Объект.ОпрашиваемоеЛицо = ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка");
	Иначе
		Объект.ОпрашиваемоеЛицо = СписокЭлемент.Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		ДокументОснованиеПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУчастникиОпроса

&НаКлиенте
Процедура УчастникиОпросаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.УчастникиОпроса.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ТекущиеДанные.ВидУчастникаОпроса) Тогда
		ТекущиеДанные.ВидУчастникаОпроса = НСтр("ru = 'Из справочника'");
	КонецЕсли;
	
	ПриИзмененииВидаУчастникаОпроса(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиОпросаВидУчастникаОпросаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.УчастникиОпроса.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПриИзмененииВидаУчастникаОпроса(ТекущиеДанные);
	
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
Процедура ЗаполнитьЧленамиКомиссии(Команда)
	
	ЗаполнитьУчастниковОпросаЧленамиКомиссииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЭлементРедактированияЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.Свойство("ТаблицаФормы") Тогда
		Элементы[ДополнительныеПараметры.ТаблицаФормы].ТекущиеДанные[ДополнительныеПараметры.ИмяЭлемента] = ВведенныйТекст;
	Иначе
		Объект[ДополнительныеПараметры.ИмяЭлемента] = ВведенныйТекст;
	КонецЕсли;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	НастроитьОтображениеГруппыПодписей();
	ВидОпрашиваемогоЛицаПредыдущий = Объект.ВидОпрашиваемогоЛица;
	ЗаполнитьВидыУчастниковОпроса();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
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
	
	НастроитьОтображениеГруппыПодписей();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеГруппыПодписей()
	ЗарплатаКадры.НастроитьОтображениеГруппыПодписей(Элементы.ПодписиГруппа, "Объект.Руководитель", "Объект.ОтветственныйЗаОхрануТруда");
КонецПроцедуры

&НаСервере
Функция СписокПострадавших()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Объект.ДокументОснование);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НесчастныйСлучайНаПроизводствеПострадавшие.Пострадавший КАК Пострадавший
	|ИЗ
	|	Документ.НесчастныйСлучайНаПроизводстве.Пострадавшие КАК НесчастныйСлучайНаПроизводствеПострадавшие
	|ГДЕ
	|	НесчастныйСлучайНаПроизводствеПострадавшие.Ссылка = &Ссылка";
	
	СписокВозврата = Новый СписокЗначений;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокВозврата.Добавить(Выборка.Пострадавший);
	КонецЦикла;
	
	Возврат СписокВозврата;
	
КонецФункции

&НаСервере
Функция СписокОчевидцев()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Объект.ДокументОснование);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НесчастныйСлучайНаПроизводствеОчевидцы.Очевидец КАК Очевидец
	|ИЗ
	|	Документ.НесчастныйСлучайНаПроизводстве.Очевидцы КАК НесчастныйСлучайНаПроизводствеОчевидцы
	|ГДЕ
	|	НесчастныйСлучайНаПроизводствеОчевидцы.Ссылка = &Ссылка";
	
	СписокВозврата = Новый СписокЗначений;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокВозврата.Добавить(Выборка.Очевидец);
	КонецЦикла;
	
	Возврат СписокВозврата;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьУчастниковОпросаЧленамиКомиссииНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Объект.ДокументОснование);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НесчастныйСлучайНаПроизводствеКомиссия.ЧленКомиссии КАК ЧленКомиссии
	|ИЗ
	|	Документ.НесчастныйСлучайНаПроизводстве.Комиссия КАК НесчастныйСлучайНаПроизводствеКомиссия
	|ГДЕ
	|	НесчастныйСлучайНаПроизводствеКомиссия.Ссылка = &Ссылка";
	
	Объект.УчастникиОпроса.Очистить();
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрокаУчастникаОпроса = Объект.УчастникиОпроса.Добавить();
		НоваяСтрокаУчастникаОпроса.Участник = Выборка.ЧленКомиссии;
		НоваяСтрокаУчастникаОпроса.ВидУчастникаОпроса = НСтр("ru = 'Из справочника'");
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииВидаУчастникаОпроса(ТекущиеДанные)
	
	Если ТекущиеДанные.ВидУчастникаОпроса = НСтр("ru = 'Из справочника'")
		И ТипЗнч(ТекущиеДанные.Участник) <> Тип("СправочникСсылка.ФизическиеЛица") Тогда
		ТекущиеДанные.Участник = ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка");
	КонецЕсли;
	
	Если ТекущиеДанные.ВидУчастникаОпроса = НСтр("ru = 'ФИО строкой'")
		И ТипЗнч(ТекущиеДанные.Участник) <> Тип("Строка") Тогда
		ТекущиеДанные.Участник = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидыУчастниковОпроса()
	
	Для каждого СтрокаУчастникаОпроса Из Объект.УчастникиОпроса Цикл
		Если ТипЗнч(СтрокаУчастникаОпроса.Участник) = Тип("Строка") Тогда
			СтрокаУчастникаОпроса.ВидУчастникаОпроса = НСтр("ru = 'ФИО строкой'");
		Иначе
			СтрокаУчастникаОпроса.ВидУчастникаОпроса = НСтр("ru = 'Из справочника'");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДокументОснованиеПриИзмененииНаСервере()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.Заполнить(ДокументОбъект.ДокументОснование);
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

#КонецОбласти
