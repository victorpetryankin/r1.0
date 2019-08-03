#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции  

Процедура СоздатьВТСправкиФизическихЛицНаДату(МенеджерВременныхТаблиц, ВидыСправок, ДатаЗначения) Экспорт

	Если ТипЗнч(ВидыСправок) = Тип("СправочникСсылка.ВидыСправок") Тогда
		СписокСправок = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВидыСправок);
	Иначе
		СписокСправок = ВидыСправок;
	КонецЕсли; 
	
	Запрос = Новый Запрос;	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТДанныеДокумента.ФизическоеЛицо
		|ПОМЕСТИТЬ ВТФизическиеЛица
		|ИЗ
		|	ВТДанныеДокумента КАК ВТДанныеДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ФизическиеЛица.ФизическоеЛицо КАК Владелец,
		|	СправкиФизическихЛиц.Ссылка,
		|	СправкиФизическихЛиц.ДатаС,
		|	СправкиФизическихЛиц.ВидСправки
		|ПОМЕСТИТЬ ВТСправкиФизическогоЛица
		|ИЗ
		|	ВТФизическиеЛица КАК ФизическиеЛица
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СправкиФизическихЛиц КАК СправкиФизическихЛиц
		|		ПО ФизическиеЛица.ФизическоеЛицо = СправкиФизическихЛиц.Владелец
		|ГДЕ
		|	СправкиФизическихЛиц.ВидСправки В(&СписокСправок)
		|	И (СправкиФизическихЛиц.ДатаПо = ДАТАВРЕМЯ(1, 1, 1)
		|			ИЛИ СправкиФизическихЛиц.ДатаПо >= &Дата)
		|	И СправкиФизическихЛиц.ДатаС <= &Дата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(СправкиФизическогоЛица.ДатаС) КАК ДатаС,
		|	СправкиФизическогоЛица.ВидСправки,
		|	СправкиФизическогоЛица.Владелец
		|ПОМЕСТИТЬ ВТМаксимумДатаС
		|ИЗ
		|	ВТСправкиФизическогоЛица КАК СправкиФизическогоЛица
		|
		|СГРУППИРОВАТЬ ПО
		|	СправкиФизическогоЛица.ВидСправки,
		|	СправкиФизическогоЛица.Владелец
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СправкиФизическогоЛица.Ссылка,
		|	СправкиФизическогоЛица.ВидСправки,
		|	СправкиФизическогоЛица.Владелец
		|ПОМЕСТИТЬ ВТСправкиФизическихЛиц
		|ИЗ
		|	ВТСправкиФизическогоЛица КАК СправкиФизическогоЛица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТМаксимумДатаС КАК МаксимумДатаС
		|		ПО СправкиФизическогоЛица.ДатаС = МаксимумДатаС.ДатаС
		|			И СправкиФизическогоЛица.ВидСправки = МаксимумДатаС.ВидСправки";

	Запрос.УстановитьПараметр("СписокСправок", СписокСправок);
	Запрос.УстановитьПараметр("Дата",ДатаЗначения);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли