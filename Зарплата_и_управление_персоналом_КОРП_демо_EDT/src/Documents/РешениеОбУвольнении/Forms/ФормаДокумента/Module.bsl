
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный, ДатаСобытия", 
			"Объект.Организация", "Объект.Ответственный", "Объект.ДатаУвольнения");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
		
		Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
			ЗаполнитьМероприятияНаСервере();
		КонецЕсли;
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ИмяСобытия = "Запись_Увольнение" Тогда
		ОбновитьДанныеФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ОбновитьДанныеФормы();
	
	ОбменДаннымиЗарплатаКадры.ПриЧтенииНаСервереДокумента(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	АдаптацияУвольнениеФормы.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_РешениеОбУвольнении", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
	АдаптацияУвольнениеФормы.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Объект.МероприятияАдаптацииУвольнения.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	ЗаполнитьМероприятияЗавершение(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ДатаУвольненияПриИзменении(Элемент)
	ЗаполнитьМероприятияЗавершение(Ложь);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыМероприятия

&НаКлиенте
Процедура НазначаемыеМероприятияМероприятиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	АдаптацияУвольнениеКлиент.НазначаемыеМероприятияМероприятиеНачалоВыбора(ЭтотОбъект, Элемент, СтандартнаяОбработка, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура НазначаемыеМероприятияМероприятиеОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура НазначаемыеМероприятияМероприятиеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ДопПараметры = ПараметрыПолученияСвойствНазначаемогоМероприятия();
	АдаптацияУвольнениеКлиент.НазначаемыеМероприятияМероприятиеОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, ДопПараметры);
	
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

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ЗаполнитьМероприятия(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьМероприятияЗавершение", ЭтотОбъект);
	ЗарплатаКадрыРасширенныйКлиент.ПроверитьВозможностьОчисткиТабличныхЧастей(ЭтотОбъект, "МероприятияАдаптацииУвольнения", Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ЗаполнитьМероприятияЗавершение(Отказ, ДополнительныеПараметры = Неопределено) Экспорт 
	
	Если Не Отказ И ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		ЗаполнитьМероприятияНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьМероприятияНаСервере()
	
	ПараметрыЗаполнения = Документы.РешениеОбУвольнении.ПараметрыЗаполненияМероприятий(Объект);
	АдаптацияУвольнениеФормы.ЗаполнитьНазначаемыеМероприятия(ЭтотОбъект, ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыПолученияСвойствНазначаемогоМероприятия()
	
	ПараметрыПолучения = АдаптацияУвольнениеКлиент.ПараметрыПолученияСвойствНазначаемогоМероприятия();
	ПараметрыПолучения.ФизическоеЛицо = Объект.ФизическоеЛицо;
	ПараметрыПолучения.ДатаСобытия = Объект.ДатаУвольнения;
	
	Возврат ПараметрыПолучения;
	
КонецФункции

&НаСервере
Процедура ОбновитьДанныеФормы()
	АдаптацияУвольнениеФормы.РешениеПриПолученииДанных(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

