#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру параметров для ограничения регистрации объекта при обмене
// Вызывается ПередЗаписью объекта.
//
// Возвращаемое значение:
//	ОграниченияРегистрации - Структура - Описание см. ОбменДаннымиЗарплатаКадры.ОграниченияРегистрации.
//
Функция ОграниченияРегистрации() Экспорт
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизации(ЭтотОбъект, Организация);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьЗапросПоСтрокамЗадолженностиДляПроверки()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаЗадолженности", СведенияОЗадолженности);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.НомерСтроки,
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.ТипСтроки,
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.Год,
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.СтраховаяЧасть,
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.НакопительнаяЧасть,
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.ДополнительныйТариф
	|ПОМЕСТИТЬ ВТТаблицаЗадолженности
	|ИЗ
	|	&ТаблицаЗадолженности КАК ВедомостьУплатыАДВ_11СведенияОЗадолженности
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗадолженности.НомерСтроки,
	|	ТаблицаЗадолженности.ТипСтроки,
	|	ТаблицаЗадолженности.Год,
	|	ТаблицаЗадолженности.СтраховаяЧасть,
	|	ТаблицаЗадолженности.НакопительнаяЧасть,
	|	ТаблицаЗадолженности.ДополнительныйТариф,
	|	ВТТаблицаЗадолженностиДубль.НомерСтроки КАК НомерСтрокиДубль
	|ИЗ
	|	ВТТаблицаЗадолженности КАК ТаблицаЗадолженности
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаЗадолженности КАК ВТТаблицаЗадолженностиДубль
	|		ПО ТаблицаЗадолженности.ТипСтроки = ВТТаблицаЗадолженностиДубль.ТипСтроки
	|			И ТаблицаЗадолженности.Год = ВТТаблицаЗадолженностиДубль.Год
	|			И ТаблицаЗадолженности.НомерСтроки > ВТТаблицаЗадолженностиДубль.НомерСтроки";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Процедура ПроверитьДанныеДокумента( Отказ) Экспорт
	Ошибки = Новый Массив;
	
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;	
	
	Если Не ДополнительныеСвойства.Свойство("НеПроверятьДанныеОрганизации") Тогда
		ПерсонифицированныйУчет.ПроверитьДанныеОрганизации(ЭтотОбъект, Организация, Отказ);
	КонецЕсли;	
	
	Если ОтчетныйПериод >= 2011 Тогда
		ТекстСообщения = НСтр("ru = 'Отчетный период не может быть больше 2010 года.'");
		
		ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуЗаполненияЭлементаДокумента(Ошибки, Ссылка, ТекстСообщения, "ОтчетныйПериод", Отказ);
	КонецЕсли;
	
	ГодОтчетногоПериода = ОтчетныйПериод;
	
	ВыборкаПоЗадолженности = СформироватьЗапросПоСтрокамЗадолженностиДляПроверки().Выбрать();
	
	Пока ВыборкаПоЗадолженности.Следующий() Цикл
		
		Если ВыборкаПоЗадолженности.НомерСтрокиДубль <> Null Тогда
			ТекстСообщения = НСтр("ru = 'Данные были введены в документе ранее.'");
			
			ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуДанныхОЗадолженности(Ошибки, Ссылка, ВыборкаПоЗадолженности.НомерСтроки, ТекстСообщения, "ТипСтроки", Отказ);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ВыборкаПоЗадолженности.ТипСтроки) И ВыборкаПоЗадолженности.ТипСтроки <> Перечисления.РазделыАДВ11.УплатаЗаПериод И ВыборкаПоЗадолженности.СтраховаяЧасть * ВыборкаПоЗадолженности.НакопительнаяЧасть < 0 Тогда
			ТекстСообщения = НСтр("ru = 'Суммы страховой и накопительной части пенсии должны иметь один знак.'");
			
			ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуДанныхОЗадолженности(Ошибки, Ссылка, ВыборкаПоЗадолженности.НомерСтроки, ТекстСообщения, "СтраховаяЧасть", Отказ);
		КонецЕсли;
		
		Если (ВыборкаПоЗадолженности.ТипСтроки = Перечисления.РазделыАДВ11.ЗадолженностьНаНачало Или ВыборкаПоЗадолженности.ТипСтроки = Перечисления.РазделыАДВ11.ЗадолженностьНаКонец) И ВыборкаПоЗадолженности.Год > 2010 Тогда
			ТекстСообщения = НСтр("ru = 'Год задолженности не должен превышать 2010'");
			
			ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуДанныхОЗадолженности(Ошибки, Ссылка, ВыборкаПоЗадолженности.НомерСтроки, ТекстСообщения, "Год", Отказ);
		ИначеЕсли ВыборкаПоЗадолженности.ТипСтроки = Перечисления.РазделыАДВ11.УплатаЗаПериод И ВыборкаПоЗадолженности.Год >= 2010 Тогда
			ТекстСообщения = НСтр("ru = 'Год, за который уплачены взносы, не должен превышать 2009.'");
			
			ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуДанныхОЗадолженности(Ошибки, Ссылка, ВыборкаПоЗадолженности.НомерСтроки, ТекстСообщения, "Год", Отказ);
		ИначеЕсли ВыборкаПоЗадолженности.ТипСтроки = Перечисления.РазделыАДВ11.ЗадолженностьНаНачало Тогда
			Если ВыборкаПоЗадолженности.СтраховаяЧасть >= 0 И ВыборкаПоЗадолженности.НакопительнаяЧасть >= 0 Тогда
				Если ВыборкаПоЗадолженности.Год >= ГодОтчетногоПериода Тогда
					ТекстСообщения = НСтр("ru = 'Год задолженности должен быть меньше расчетного периода.'");
					
					ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуДанныхОЗадолженности(Ошибки, Ссылка, ВыборкаПоЗадолженности.НомерСтроки, ТекстСообщения, "Год", Отказ);
				КонецЕсли;
				
			ИначеЕсли ВыборкаПоЗадолженности.СтраховаяЧасть * ВыборкаПоЗадолженности.НакопительнаяЧасть < 0 Тогда
				
			ИначеЕсли ВыборкаПоЗадолженности.СтраховаяЧасть <= 0 И ВыборкаПоЗадолженности.НакопительнаяЧасть <= 0 Тогда
				Если ВыборкаПоЗадолженности.Год > ГодОтчетногоПериода Тогда
					ТекстСообщения = НСтр("ru = 'Год переплаты не должен превышать год расчетного периода.'");
					
					ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуДанныхОЗадолженности(Ошибки, Ссылка, ВыборкаПоЗадолженности.НомерСтроки, ТекстСообщения, "Год", Отказ);
				КонецЕсли;
				
			КонецЕсли;
		ИначеЕсли ВыборкаПоЗадолженности.ТипСтроки = Перечисления.РазделыАДВ11.УплатаЗаПериод И ВыборкаПоЗадолженности.Год > ГодОтчетногоПериода Тогда
			ТекстСообщения = НСтр("ru = 'Год уплаты взносов не должен превышать год расчетного периода.'");
			
			ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуДанныхОЗадолженности(Ошибки, Ссылка, ВыборкаПоЗадолженности.НомерСтроки, ТекстСообщения, "Год", Отказ);
		ИначеЕсли ВыборкаПоЗадолженности.ТипСтроки = Перечисления.РазделыАДВ11.ЗадолженностьНаКонец  Тогда 
			Если ВыборкаПоЗадолженности.СтраховаяЧасть >= 0 И ВыборкаПоЗадолженности.НакопительнаяЧасть >= 0 Тогда
				Если ВыборкаПоЗадолженности.Год > ГодОтчетногоПериода Тогда
					ТекстСообщения = НСтр("ru = 'Год задолженности не должен превышать год расчетного периода.'");
					
					ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуДанныхОЗадолженности(Ошибки, Ссылка, ВыборкаПоЗадолженности.НомерСтроки, ТекстСообщения, "Год", Отказ);
				КонецЕсли;
			ИначеЕсли ВыборкаПоЗадолженности.СтраховаяЧасть <= 0 И ВыборкаПоЗадолженности.НакопительнаяЧасть <= 0 Тогда
				Если ВыборкаПоЗадолженности.Год > ГодОтчетногоПериода + 1 Тогда
					ТекстСообщения = НСтр("ru = 'Год переплаты не должен превышать год расчетного периода более чем на 1.'");
					
					ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуДанныхОЗадолженности(Ошибки, Ссылка, ВыборкаПоЗадолженности.НомерСтроки, ТекстСообщения, "Год", Отказ);
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ОкончаниеОтчетногоПериода() Экспорт
	
	Возврат ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаПерсУчета(
		Дата(?(ОтчетныйПериод <= 0, 1, ОтчетныйПериод), 12, 31));
	
КонецФункции

#КонецОбласти

#КонецЕсли