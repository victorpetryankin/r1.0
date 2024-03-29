#Область СлужебныйПрограммныйИнтерфейс

#Область ОткрытиеФорм

Процедура ОткрытьФормуКадровыйРезерв(ФормаВладелец, ФизическоеЛицоСсылка) Экспорт

	ПараметрыФормы = Новый Структура("ФизическоеЛицоСсылка", ФизическоеЛицоСсылка);
	ОткрытьФорму("ОбщаяФорма.КадровыйРезерв", ПараметрыФормы, ФормаВладелец);

КонецПроцедуры

Процедура ОткрытьФормуСправочникаКадровыйРезерв(Форма, ПараметрыФормы) Экспорт
	ОткрытьФорму("Справочник.КадровыйРезерв.ФормаОбъекта", ПараметрыФормы, Форма, Новый УникальныйИдентификатор);
КонецПроцедуры

Процедура ОткрытьФормуСправочникаФизическиеЛица(Форма, ИмяСписка) Экспорт

	ТекущиеДанные = Форма.Элементы[ИмяСписка].ТекущиеДанные;
	Если НЕ ТекущиеДанные = Неопределено Тогда
		ФизическоеЛицоСсылка = ТекущиеДанные.ФизическоеЛицо;
		ПараметрыФормы = Новый Структура("Ключ", ФизическоеЛицоСсылка);
		ОткрытьФорму("Справочник.ФизическиеЛица.ФормаОбъекта", ПараметрыФормы, Форма, Новый УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры

Процедура ОткрытьФормуЗаявкаНаВключениеВКадровыйРезерв(Форма, ПараметрыФормы = Неопределено, ИмяТабличнойЧасти = "КадровыйРезервПозицииШР") Экспорт
	
	// Если параметры не заполнены - надо формировать.
	Если ПараметрыФормы = Неопределено Тогда
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ПозицияРезерва", Форма.КадровыйРезервСвязаннаяПозицияРезерва);
		ТекущиеДанные = Форма.Элементы[ИмяТабличнойЧасти].ТекущиеДанные;
		Если НЕ ТекущиеДанные = Неопределено Тогда
			ЗначенияЗаполнения.Вставить("ФизическоеЛицо", ТекущиеДанные.ФизическоеЛицо);
			ЗначенияЗаполнения.Вставить("ВидРезерва", ТекущиеДанные.ВидРезерва);
		КонецЕсли;
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	КонецЕсли;
	ОткрытьФорму("Документ.ЗаявкаНаВключениеВКадровыйРезерв.ФормаОбъекта", ПараметрыФормы, Форма, Новый УникальныйИдентификатор);
	
КонецПроцедуры

Процедура ОткрытьФормуВключениеВКадровыйРезерв(Форма, ПараметрыФормы = Неопределено, ИмяТабличнойЧасти = "КадровыйРезервПозицииШР") Экспорт
	
	// Если параметры не заполнены - надо формировать.
	Если ПараметрыФормы = Неопределено Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ПозицияРезерва", Форма.КадровыйРезервСвязаннаяПозицияРезерва);
		ТекущиеДанные = Форма.Элементы[ИмяТабличнойЧасти].ТекущиеДанные;
		Если НЕ ТекущиеДанные = Неопределено Тогда
			ПараметрыФормы.Вставить("ФизическоеЛицо", ТекущиеДанные.ФизическоеЛицо);
			ПараметрыФормы.Вставить("ВидРезерва", ТекущиеДанные.ВидРезерва);
		КонецЕсли;
	КонецЕсли;
	ОткрытьФорму("Документ.ВключениеВКадровыйРезерв.ФормаОбъекта", ПараметрыФормы, Форма, Новый УникальныйИдентификатор);
	
КонецПроцедуры

Процедура ОткрытьФормуИсключениеИзКадровогоРезерва(Форма, ПараметрыФормы = Неопределено) Экспорт
	
	// Если параметры не заполнены - надо формировать.
	Если ПараметрыФормы = Неопределено Тогда
		ТекущиеДанные = Форма.Элементы.КадровыйРезервПозицииШР.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ФизическоеЛицоСсылка = ТекущиеДанные.ФизическоеЛицо;
		ПараметрыФормы = Новый Структура("ФизическоеЛицо", ФизическоеЛицоСсылка);
	КонецЕсли;
	ОткрытьФорму("Документ.ИсключениеИзКадровогоРезерва.ФормаОбъекта", ПараметрыФормы, Форма, Новый УникальныйИдентификатор);
	
КонецПроцедуры

Функция ПараметрыОткрытияФормыСправочникаКадровыйРезерв(Форма) Экспорт
	
	
	Если ЗначениеЗаполнено(Форма.КадровыйРезервСвязаннаяПозицияРезерва) Тогда
		Возврат Новый Структура("Ключ", Форма.КадровыйРезервСвязаннаяПозицияРезерва);
	Иначе	
		ЗначенияЗаполнения = Новый Структура("ПозицияШтатногоРасписания", Форма.Объект.Ссылка);
		Возврат Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	КонецЕсли;
		
КонецФункции

#КонецОбласти 

#Область КадровыйПеревод

Процедура КадровыйРезервОставитьДляОбщихДокументов(Форма) Экспорт

	ТекущиеДанные = Форма.Элементы.КадровыйРезерв.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Действие = ПредопределенноеЗначение("Перечисление.ДействияСКадровымиРезервистами.Оставить");
	
	КадровыйРезервКлиентСервер.ЗаполнитьОписаниеДействия(ТекущиеДанные);
	КадровыйРезервКлиентСервер.УстановитьДоступностьКомандКадровогоРезерваДокументовДляОбщихДокументов(Форма, ТекущиеДанные);
	
КонецПроцедуры

Процедура КадровыйРезервИсключитьДляОбщихДокументов(Форма) Экспорт

	ТекущиеДанные = Форма.Элементы.КадровыйРезерв.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Действие = ПредопределенноеЗначение("Перечисление.ДействияСКадровымиРезервистами.Отклонить");
	
	КадровыйРезервКлиентСервер.ЗаполнитьОписаниеДействия(ТекущиеДанные);
	КадровыйРезервКлиентСервер.УстановитьДоступностьКомандКадровогоРезерваДокументовДляОбщихДокументов(Форма, ТекущиеДанные);
	
КонецПроцедуры

Процедура КадровыйРезервПриАктивизацииСтрокиДляОбщихДокументов(Форма) Экспорт

	ТекущиеДанные = Форма.Элементы.КадровыйРезерв.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	КадровыйРезервКлиентСервер.УстановитьДоступностьКомандКадровогоРезерваДокументовДляОбщихДокументов(Форма, ТекущиеДанные);

КонецПроцедуры


#КонецОбласти 

Процедура ПроверитьПоляКадровогоРезерва(Форма) Экспорт

	ТекущиеДанные = Форма.Элементы.РезультатыАттестации.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РекомендуетсяВКадровыйРезерв = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.РешенияАттестационныхКомиссий.РекомендуетсяВКадровыйРезерв");
	
	Если РекомендуетсяВКадровыйРезерв = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ТекущиеДанные.РешениеКомиссии = РекомендуетсяВКадровыйРезерв Тогда
		ТекущиеДанные.ПозицияРезерва = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.КадровыйРезерв.ПустаяСсылка");
		ТекущиеДанные.ВидРезерва = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыКадровогоРезерва.ПустаяСсылка");
	КонецЕсли;

КонецПроцедуры

Функция ТекущиеДанныеТаблицы(Форма) Экспорт
	ТекущиеДанные = Форма.Элементы.КадровыйРезервПозицииШР.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат Неопределено;
	Иначе
		Возврат Новый Структура("ПозицияРезерва, ФизическоеЛицо", Форма.КадровыйРезервСвязаннаяПозицияРезерва, ТекущиеДанные.ФизическоеЛицо);
	КонецЕсли;
КонецФункции

#КонецОбласти 