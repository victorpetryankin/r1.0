
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный, Месяц", 
			"Объект.Организация", "Объект.Ответственный", "Объект.ДатаНачала");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		РасчетЗарплатыРасширенныйФормы.ЗаполнитьУдержаниеВФормеДокументаПоРоли(
			ЭтаФорма,
			Объект.Удержание,
			Перечисления.КатегорииУдержаний.ДобровольныеВзносыВНПФ,
			Новый Структура("СпособВыполненияУдержания", Перечисления.СпособыВыполненияУдержаний.ЕжемесячноПриОкончательномРасчете));
		РасчетЗарплатыРасширенныйФормы.ЗаполнитьКонтрагентаВФормеДокументаПоУдержанию(ЭтотОбъект, "НПФ", Объект.Удержание);
		Если Не ЗначениеЗаполнено(Объект.Действие) Тогда
			Объект.Действие = Перечисления.ДействияСУдержаниями.Начать;
		КонецЕсли;
		ПриПолученииДанныхНаСервере();
	КонецЕсли;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
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
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	РеквизитыВДанные(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ДанныеВРеквизиты();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УдержаниеДобровольныхВзносовВНПФ", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыПоказателиДокумента" И Источник.ВладелецФормы = ЭтотОбъект Тогда
		Если Параметр.Показатели.Количество() > 0 Тогда 
			ОбработатьИзменениеПоказателейНаСервере(Параметр.Показатели);
		КонецЕсли;
		
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
	
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтотОбъект);
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УдержаниеПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтотОбъект);
	УдержаниеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДействиеПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтотОбъект);
	ДействиеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтотОбъект);
	ДокументОснованиеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ДатаНачала", "ДатаНачалаСтрокой", Модифицированность);
	Объект.ДатаНачала = НачалоМесяца(Объект.ДатаНачала);
	
	ДатаНачалаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ДатаНачалаСтрокойНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ДатаНачала", "ДатаНачалаСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаСтрокойНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	Объект.ДатаНачала = НачалоМесяца(Объект.ДатаНачала);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ДатаНачала", "ДатаНачалаСтрокой", Направление, Модифицированность);
	Объект.ДатаНачала = НачалоМесяца(Объект.ДатаНачала);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ДатаОкончания", "ДатаОкончанияСтрокой", Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ДатаОкончания", "ДатаОкончанияСтрокой");
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ДатаОкончания", "ДатаОкончанияСтрокой", Направление, Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаИзмененияСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ДатаНачала", "ДатаНачалаСтрокой", Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаИзмененияСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ДатаНачала", "ДатаНачалаСтрокой");
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаИзмененияСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ДатаНачала", "ДатаНачалаСтрокой", Направление, Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаИзмененияСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаИзмененияСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияИзмененияСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ДатаОкончания", "ДатаОкончанияСтрокой", Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияИзмененияСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ДатаОкончания", "ДатаОкончанияСтрокой");
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияИзмененияСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ДатаОкончания", "ДатаОкончанияСтрокой", Направление, Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияИзмененияСтрокойАвтоПодбор(Элемент,
	Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияИзмененияСтрокойОкончаниеВводаТекста(Элемент,
	Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура БухучетЗаданВДокументеПриИзменении(Элемент)
	
	Если Объект.БухучетЗаданВДокументе Тогда
		Объект.СтатьяФинансирования = СтатьяФинансированияПрошлоеЗначение;
		Объект.СтатьяРасходов 		= СтатьяРасходовПрошлоеЗначение;
	Иначе
		СтатьяФинансированияПрошлоеЗначение = Объект.СтатьяФинансирования;
		Объект.СтатьяФинансирования = "";
		СтатьяРасходовПрошлоеЗначение = Объект.СтатьяРасходов;
		Объект.СтатьяРасходов = "";
	КонецЕсли;
	ОбновитьДоступностьНастроекБухучета(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУдержания

&НаКлиенте
Процедура УдержанияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не ЗначениеЗаполнено(Объект.Удержание) Тогда 
		ТекстСообщения = НСтр("ru = 'Не указано удержание.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Удержание", "Объект", Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ЗарплатаКадрыРасширенныйКлиент.ВводНачисленийВШапкеПриНачалеРедактирования(ЭтотОбъект, "Удержания", НоваяСтрока);
	ЗарплатаКадрыРасширенныйКлиент.УстановитьОграничениеТипаПоТочностиПоказателя(Элементы.Удержания.ТекущиеДанные, ЭтотОбъект, "Удержания", 1);
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбработкаПодбораНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияПослеУдаления(Элемент)
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияФизическоеЛицоПриИзменении(Элемент)
	
	УдержанияФизическоеЛицоПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияПредставлениеРабочегоМестаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УдержанияПредставлениеРабочегоМестаНачалоВыбораНаСервере(Элементы.Удержания.ТекущиеДанные.ФизическоеЛицо, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияПредставлениеРабочегоМестаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ЗарплатаКадрыРасширенныйКлиент.РабочиеМестаУдержанийОбработкаВыбораРабочегоМеста(ЭтотОбъект, Элементы.Удержания.ТекущиеДанные, ВыбранноеЗначение, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подбор(Команда)
	
	Отбор = Новый Структура;
	Отбор.Вставить("ДатаПримененияОтбора", Объект.ДатаНачала);
	Отбор.Вставить("ВАрхиве", Ложь);
		
	Если МассивФизическихЛиц.Количество() > 0 Тогда 
		Отбор.Вставить("Ссылка", МассивФизическихЛиц);
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Отбор", Отбор);
	
	КадровыйУчетКлиент.ВыбратьФизическихЛицОрганизации(Элементы.Удержания, Объект.Организация, Истина, , АдресСпискаПодобранныхСотрудников(), , ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоказатели(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Удержание) Тогда 
		ТекстСообщения = НСтр("ru = 'Не указано удержание.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Удержание");
		Возврат;
	КонецЕсли;
	
	МассивПоказателей = Новый Массив;
	ВидРасчетаИнфо = ЗарплатаКадрыРасширенныйКлиентПовтИсп.ПолучитьИнформациюОВидеРасчета(Объект.Удержание);
	Для Каждого ОписаниеПоказателя Из ВидРасчетаИнфо.Показатели Цикл
		Если ОписаниеПоказателя.ЗапрашиватьПриВводе Тогда
			МассивПоказателей.Добавить(ОписаниеПоказателя.Показатель);
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура("МассивПоказателей", МассивПоказателей);
	ОткрытьФорму("ОбщаяФорма.ГрупповоеЗаполнениеПоказателейДокументов", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ОписаниеТаблицыВидовРасчета = ОписаниеТаблицыУдержаний();
	ЗарплатаКадрыРасширенный.ВводНачисленийВШапкеДополнитьФорму(ЭтотОбъект, ОписаниеТаблицыВидовРасчета, 1);
	ЗарплатаКадрыРасширенный.УстановитьВидимостьПредставленияРабочегоМеста(ЭтотОбъект, "УдержанияПредставлениеРабочегоМеста");

	ДанныеВРеквизиты();
	
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(ЭтотОбъект);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	
	РасчетЗарплатыРасширенныйФормы.ДокументыПлановыхУдержанийУстановитьВидимостьПоказателей(Элементы, Объект.Удержание, "УдержанияПоказатели");
	РасчетЗарплатыРасширенныйФормы.ДокументыПлановыхУдержанийУстановитьВидимостьРазмера(Элементы, Объект.Удержание, "УдержанияРазмер");
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ДатаНачала", "ДатаНачалаСтрокой");
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ДатаОкончания", "ДатаОкончанияСтрокой");
	
	УстановитьСтраницуДействия();
	УстановитьДоступностьПоляДатаОкончания();
	УстановитьДоступностьДокументаОснования();
	УстановитьДоступностьПоляРазмер();
	
	ЗаполнитьМассивДоступныхФизическихЛиц();
	УстановитьПараметрыВыбораФизическихЛиц();
	
	УстановитьДоступностьНастроекБухучета();
	СтатьяФинансированияПрошлоеЗначение = Объект.СтатьяФинансирования;
	СтатьяРасходовПрошлоеЗначение 		= Объект.СтатьяРасходов;
	ОбновитьДоступностьНастроекБухучета(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСтраницуДействия()
	
	РасчетЗарплатыРасширенныйФормы.УдержанияСпискомУстановитьСтраницуДействия(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьПоляДатаОкончания()
	
	Если Объект.Действие = Перечисления.ДействияСУдержаниями.Изменить Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИзменитьОтменитьГруппа", "ТекущаяСтраница", Элементы.ИзменитьГруппа);
	ИначеЕсли Объект.Действие = Перечисления.ДействияСУдержаниями.Прекратить Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИзменитьОтменитьГруппа", "ТекущаяСтраница", Элементы.ПрекратитьГруппа);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьДокументаОснования()
	
	Если Объект.Действие = Перечисления.ДействияСУдержаниями.Начать Тогда
		Объект.ДокументОснование = Неопределено;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДокументОснование", "Доступность", Ложь);
		Возврат;
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДокументОснование", "Доступность", Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьПоляРазмер()
	
	РасчетЗарплатыРасширенныйФормы.УдержанияСпискомУстановитьДоступностьПоляРазмер(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Объект.ДокументОснование = Неопределено;
	
	ЗаполнитьМассивДоступныхФизическихЛиц();
	УстановитьПараметрыВыбораФизическихЛиц();
	
	ЗарплатаКадрыРасширенный.УстановитьВидимостьПредставленияРабочегоМеста(ЭтотОбъект, "УдержанияПредставлениеРабочегоМеста");
	ЗарплатаКадрыРасширенный.УстановитьПредставленияРабочихМест(ЭтотОбъект);	

КонецПроцедуры

&НаСервере
Процедура УдержаниеПриИзмененииНаСервере()
	
	Объект.ДокументОснование = Неопределено;
	Объект.НПФ = Неопределено;
	
	ОписаниеТаблицыВидовРасчета = ОписаниеТаблицыУдержаний();
	ЗарплатаКадрыРасширенный.ВводНачисленийВШапкеВидРасчетаПриИзменении(ЭтаФорма, ОписаниеТаблицыВидовРасчета, 1);
	
	РасчетЗарплатыРасширенныйФормы.ДокументыПлановыхУдержанийУстановитьВидимостьПоказателей(Элементы, Объект.Удержание, "УдержанияПоказатели");
	РасчетЗарплатыРасширенныйФормы.ДокументыПлановыхУдержанийУстановитьВидимостьРазмера(Элементы, Объект.Удержание, "УдержанияРазмер");
	
	УстановитьДоступностьДокументаОснования();
	
	Если Объект.Действие = Перечисления.ДействияСУдержаниями.Начать Тогда 
		РасчетЗарплатыРасширенныйФормы.ЗаполнитьКонтрагентаВФормеДокументаПоУдержанию(ЭтотОбъект, "НПФ", Объект.Удержание);
	КонецЕсли;
	
	ЗаполнитьМассивДоступныхФизическихЛиц();
	УстановитьПараметрыВыбораФизическихЛиц();
	УстановитьДоступностьНастроекБухучета();
	
КонецПроцедуры

&НаСервере
Процедура ДействиеПриИзмененииНаСервере()
	
	УстановитьСтраницуДействия();
	УстановитьДоступностьДокументаОснования();
	УстановитьДоступностьПоляДатаОкончания();
	УстановитьДоступностьПоляРазмер();
	
	РасчетЗарплатыРасширенныйФормы.УдержанияСпискомУстановитьРазмерПриПрекращенииУдержания(ЭтотОбъект, ОписаниеТаблицыУдержаний());
	
	ЗаполнитьМассивДоступныхФизическихЛиц();
	УстановитьПараметрыВыбораФизическихЛиц();
	УстановитьДоступностьНастроекБухучета();
	
КонецПроцедуры

&НаСервере
Процедура ДокументОснованиеПриИзмененииНаСервере()
	
	Объект.НПФ = Неопределено;
	
	Если Не ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		ЗаполнитьМассивДоступныхФизическихЛиц();
		УстановитьПараметрыВыбораФизическихЛиц();
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Объект.ДокументОснование);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	УдержаниеДобровольныхВзносовВНПФУдержания.ФизическоеЛицо,
	               |	УдержаниеДобровольныхВзносовВНПФУдержания.Размер,
	               |	УдержаниеДобровольныхВзносовВНПФУдержания.ИдентификаторСтрокиВидаРасчета
	               |ИЗ
	               |	Документ.УдержаниеДобровольныхВзносовВНПФ.Удержания КАК УдержаниеДобровольныхВзносовВНПФУдержания
	               |ГДЕ
	               |	УдержаниеДобровольныхВзносовВНПФУдержания.Ссылка = &Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	УдержаниеДобровольныхВзносовВНПФПоказатели.Показатель,
	               |	УдержаниеДобровольныхВзносовВНПФПоказатели.Значение,
	               |	УдержаниеДобровольныхВзносовВНПФПоказатели.ИдентификаторСтрокиВидаРасчета
	               |ИЗ
	               |	Документ.УдержаниеДобровольныхВзносовВНПФ.Показатели КАК УдержаниеДобровольныхВзносовВНПФПоказатели
	               |ГДЕ
	               |	УдержаниеДобровольныхВзносовВНПФПоказатели.Ссылка = &Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	УдержаниеДобровольныхВзносовВНПФ.НПФ
	               |ИЗ
	               |	Документ.УдержаниеДобровольныхВзносовВНПФ КАК УдержаниеДобровольныхВзносовВНПФ
	               |ГДЕ
	               |	УдержаниеДобровольныхВзносовВНПФ.Ссылка = &Ссылка";
				   
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	Выборка = РезультатыЗапроса[0].Выбрать();			   
	Пока Выборка.Следующий() Цикл 
		ЗаполнитьЗначенияСвойств(Объект.Удержания.Добавить(), Выборка);
	КонецЦикла;
	
	Выборка = РезультатыЗапроса[1].Выбрать();			   
	Пока Выборка.Следующий() Цикл 
		ЗаполнитьЗначенияСвойств(Объект.Показатели.Добавить(), Выборка);
	КонецЦикла;
	
	Выборка = РезультатыЗапроса[2].Выбрать();			   
	Если Выборка.Следующий() Тогда  
		Объект.НПФ = Выборка.НПФ;
	КонецЕсли;
	
	ДанныеВРеквизиты();
	
	РасчетЗарплатыРасширенныйФормы.УдержанияСпискомУстановитьРазмерПриПрекращенииУдержания(ЭтотОбъект, ОписаниеТаблицыУдержаний());
	
	ЗаполнитьМассивДоступныхФизическихЛиц();
	УстановитьПараметрыВыбораФизическихЛиц();
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ДатаНачалаПриИзмененииНаСервере()
	
	ЗарплатаКадрыРасширенный.УстановитьВидимостьПредставленияРабочегоМеста(ЭтотОбъект, "УдержанияПредставлениеРабочегоМеста");
	
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(ОбщегоНазначения.ВыгрузитьКолонку(Объект.Удержания, "ФизическоеЛицо"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ОбработкаПодбораНаСервере(ВыбранныеФизическиеЛица)
	
	РасчетЗарплатыРасширенныйФормы.УдержанияСпискомОбработкаПодбораНаСервере(ЭтотОбъект, ВыбранныеФизическиеЛица);
	ЗарплатаКадрыРасширенный.УстановитьПредставленияРабочихМест(ЭтотОбъект);	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ДанныеВРеквизиты()
	
	ЗарплатаКадрыРасширенный.УстановитьПредставленияРабочихМест(ЭтотОбъект);	
	ЗарплатаКадрыРасширенный.ВводНачисленийДанныеВРеквизит(ЭтотОбъект, ОписаниеТаблицыУдержаний(), 1);
	
КонецПроцедуры

&НаСервере
Процедура РеквизитыВДанные(ТекущийОбъект)
	
	РасчетЗарплатыРасширенныйФормы.УдержанияСпискомРеквизитыВДанные(ЭтотОбъект, ТекущийОбъект, ОписаниеТаблицыУдержаний());
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьМассивДоступныхФизическихЛиц()
	
	ФизическиеЛица = Новый Массив;
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда 
		
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("Ссылка", Объект.ДокументОснование);
		
		Запрос.Текст = "ВЫБРАТЬ
		               |	УдержаниеДобровольныхВзносовВНПФУдержания.ФизическоеЛицо
		               |ИЗ
		               |	Документ.УдержаниеДобровольныхВзносовВНПФ.Удержания КАК УдержаниеДобровольныхВзносовВНПФУдержания
		               |ГДЕ
		               |	УдержаниеДобровольныхВзносовВНПФУдержания.Ссылка = &Ссылка";
					   
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл 
			ФизическиеЛица.Добавить(Выборка.ФизическоеЛицо);
		КонецЦикла;
		
	КонецЕсли;
	
	МассивФизическихЛиц = Новый ФиксированныйМассив(ФизическиеЛица);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораФизическихЛиц()
	
	РасчетЗарплатыРасширенныйФормы.УдержанияСпискомУстановитьПараметрыВыбораФизическихЛиц(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеТаблицыУдержаний()
	
	ОписаниеТаблицы = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	ОписаниеТаблицы.ИмяТаблицы = "Удержания";
	ОписаниеТаблицы.ПутьКДанным = "Объект.Удержания";
	ОписаниеТаблицы.ИмяРеквизитаВидРасчета = "Удержание";
	ОписаниеТаблицы.СодержитПолеВидРасчета = Ложь;
	ОписаниеТаблицы.СодержитПолеСотрудник = Истина;
	ОписаниеТаблицы.ИмяРеквизитаСотрудник = "ФизическоеЛицо";
	ОписаниеТаблицы.ЭтоПлановыеНачисленияУдержания = Истина;
	
	Возврат ОписаниеТаблицы;	
	
КонецФункции	

&НаСервере
Процедура ОбработатьИзменениеПоказателейНаСервере(ЗначенияПоказателей)
	
	ВидРасчетаИнфо = ЗарплатаКадрыРасширенныйПовтИсп.ПолучитьИнформациюОВидеРасчета(Объект.Удержание);
	ФиксированнаяСумма = ЗначенияПоказателей[Справочники.ПоказателиРасчетаЗарплаты.ПустаяСсылка()];
	
	Для Каждого СтрокаСотрудника Из Объект.Удержания Цикл
		
		Если ФиксированнаяСумма = Неопределено Тогда
			
			МаксимальноеЧислоПоказателей = ВидРасчетаИнфо.КоличествоПостоянныхПоказателей;
			Для Сч = 1 По МаксимальноеЧислоПоказателей Цикл
				
				Показатель = СтрокаСотрудника["Показатель" + Сч];
				Если Не ЗначениеЗаполнено(Показатель) Тогда 
					Прервать;
				КонецЕсли;
				
				ЗначениеПоказателя = ЗначенияПоказателей[Показатель];
				Если ЗначениеПоказателя <> Неопределено Тогда 
					СтрокаСотрудника["Значение" + Сч] = ЗначениеПоказателя;
				КонецЕсли;
				
			КонецЦикла;
			
		Иначе 
			
			СтрокаСотрудника.Размер = ФиксированнаяСумма;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УдержанияФизическоеЛицоПриИзмененииНаСервере()
	
	ТекущиеДанные = Объект.Удержания.НайтиПоИдентификатору(Элементы.Удержания.ТекущаяСтрока);
	ЗарплатаКадрыРасширенный.РабочиеМестаУдержанийПриИзмененииФизическогоЛица(ЭтотОбъект, ТекущиеДанные);
	
КонецПроцедуры

&НаСервере
Процедура УдержанияПредставлениеРабочегоМестаНачалоВыбораНаСервере(ФизическоеЛицо, ДанныеВыбора, СтандартнаяОбработка) 
	
	ЗарплатаКадрыРасширенный.РабочиеМестаУдержанийНачалоВыбораРабочегоМеста(ЭтотОбъект, ФизическоеЛицо, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОбновитьДоступностьНастроекБухучета(Форма)
	
	НастройкаДоступна = Форма.Объект.БухучетЗаданВДокументе;
	Элементы = Форма.Элементы;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяФинансирования", "Доступность", НастройкаДоступна);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяФинансирования", "АвтоОтметкаНезаполненного", НастройкаДоступна);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяФинансирования", "ОтметкаНезаполненного", НастройкаДоступна И Не ЗначениеЗаполнено(Форма.Объект.СтатьяФинансирования));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяРасходов", "Доступность", НастройкаДоступна);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяРасходов", "АвтоОтметкаНезаполненного", НастройкаДоступна);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяРасходов", "ОтметкаНезаполненного", НастройкаДоступна И Не ЗначениеЗаполнено(Форма.Объект.СтатьяРасходов));
	
КонецФункции

&НаСервере
Процедура УстановитьДоступностьНастроекБухучета()

	Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплата") Тогда
		
		НастройкаДоступна = Объект.Действие <> Перечисления.ДействияСУдержаниями.Прекратить;
		Если НастройкаДоступна Тогда
			НастройкаДоступна = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Удержание, "ДоступнаСтратегияОтраженияКакЗаданоВидуРасчета");
			НастройкаДоступна = ?(НастройкаДоступна = Неопределено, Ложь, НастройкаДоступна);
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "БухучетГруппа", "Видимость", НастройкаДоступна);
		Если Не НастройкаДоступна Тогда
			Объект.БухучетЗаданВДокументе = Ложь;
			Объект.СтатьяФинансирования = "";
			Объект.СтатьяРасходов = "";
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#Область КлючевыеРеквизитыЗаполненияФормы

&НаСервере
// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	
	МассивТаблиц = Новый Массив;
	МассивТаблиц.Добавить("Объект.Удержания");
	МассивТаблиц.Добавить("Объект.Показатели");
	
	Возврат МассивТаблиц;
	
КонецФункции

&НаСервере
// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация",			Нстр("ru = 'организации'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Удержание",				Нстр("ru = 'удержания'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Действие",				Нстр("ru = 'действия'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "ДокументОснование",		Нстр("ru = 'основания'")));
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти

#КонецОбласти
