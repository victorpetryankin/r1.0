#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// используется при загрузке данных
Процедура РассчитатьФОТПоДокументу(ДокументОбъект) Экспорт

	ТаблицаНачислений = ПлановыеНачисленияСотрудников.ТаблицаНачисленийДляРасчетаВторичныхДанных();
	ТаблицаПоказателей = ПлановыеНачисленияСотрудников.ТаблицаИзвестныеПоказатели();
	ИзвестныеКадровыеДанные = ПлановыеНачисленияСотрудников.СоздатьТаблицаКадровыхДанных();
		
	Отбор = Новый Структура("Сотрудник");
	Для каждого СтрокаСотрудник Из ДокументОбъект.Сотрудники Цикл
		
		КадровыеДанныеСотрудника = ИзвестныеКадровыеДанные.Добавить();
		КадровыеДанныеСотрудника.Сотрудник = СтрокаСотрудник.Сотрудник;
		КадровыеДанныеСотрудника.Период = ДокументОбъект.Месяц;
		КадровыеДанныеСотрудника.Организация = ДокументОбъект.Организация;
		КадровыеДанныеСотрудника.Подразделение = ДокументОбъект.Подразделение;
		КадровыеДанныеСотрудника.ГрафикРаботы = СтрокаСотрудник.ГрафикРаботы;
		КадровыеДанныеСотрудника.КоличествоСтавок = СтрокаСотрудник.КоличествоСтавок;
	    				
		Отбор.Сотрудник = СтрокаСотрудник.Сотрудник;
		СтрокиНачисления = ДокументОбъект.Начисления.Выгрузить(Отбор);
		Для Каждого СтрокаНачисления Из СтрокиНачисления Цикл
			ДанныеНачисления = ТаблицаНачислений.Добавить();
			ДанныеНачисления.Сотрудник = СтрокаНачисления.Сотрудник;
			ДанныеНачисления.Период = ДокументОбъект.Месяц;
			ДанныеНачисления.Начисление = СтрокаНачисления.Начисление;
			ДанныеНачисления.Размер = СтрокаНачисления.Размер;
		КонецЦикла;
		
		СтрокиПоказателя = ДокументОбъект.Показатели.Выгрузить(Отбор);
		Для Каждого СтрокаПоказателя Из СтрокиПоказателя Цикл
			ДанныеПоказателя = ТаблицаПоказателей.Добавить();
			ДанныеПоказателя.Сотрудник = СтрокаНачисления.Сотрудник;
			ДанныеПоказателя.Период = ДокументОбъект.Месяц;
			ДанныеПоказателя.Показатель = СтрокаПоказателя.Показатель;
			ДанныеПоказателя.Значение = СтрокаПоказателя.Значение;
		КонецЦикла;
				
	КонецЦикла;
	
	РассчитанныеДанные = ПлановыеНачисленияСотрудников.РассчитатьВторичныеДанныеПлановыхНачислений(ТаблицаНачислений, ТаблицаПоказателей, ИзвестныеКадровыеДанные);
	Отбор = Новый Структура("Сотрудник,Начисление");
	Для Каждого ОписаниеНачисления Из РассчитанныеДанные.ПлановыйФОТ Цикл
		ЗаполнитьЗначенияСвойств(Отбор,ОписаниеНачисления);
		СтрокиДокумента = ДокументОбъект.Начисления.НайтиСтроки(Отбор);
		Если СтрокиДокумента.Количество() > 0 Тогда
			СтрокиДокумента[0].Размер = ОписаниеНачисления.ВкладВФОТ;
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.НачальнаяШтатнаяРасстановка;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти	


#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

Функция ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок) Экспорт
	ДанныеДляРегистрации = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НачальнаяШтатнаяРасстановкаСотрудники.Сотрудник,
	|	НачальнаяШтатнаяРасстановкаСотрудники.Подразделение,
	|	НачальнаяШтатнаяРасстановкаСотрудники.Должность,
	|	НачальнаяШтатнаяРасстановкаСотрудники.ДолжностьПоШтатномуРасписанию,
	|	НачальнаяШтатнаяРасстановкаСотрудники.КоличествоСтавок,
	|	НачальнаяШтатнаяРасстановкаСотрудники.ГрафикРаботы,
	|	НачальнаяШтатнаяРасстановкаСотрудники.ВидЗанятости,
	|	НачальнаяШтатнаяРасстановкаСотрудники.Ссылка.Месяц,
	|	НачальнаяШтатнаяРасстановкаСотрудники.Ссылка КАК Ссылка,
	|	НачальнаяШтатнаяРасстановкаСотрудники.Ссылка.Организация КАК Организация
	|ИЗ
	|	Документ.НачальнаяШтатнаяРасстановка.Сотрудники КАК НачальнаяШтатнаяРасстановкаСотрудники
	|ГДЕ
	|	НачальнаяШтатнаяРасстановкаСотрудники.Ссылка В(&МассивСсылок)
	|	И НачальнаяШтатнаяРасстановкаСотрудники.Сотрудник = НачальнаяШтатнаяРасстановкаСотрудники.Сотрудник.ГоловнойСотрудник
	|	И НЕ НачальнаяШтатнаяРасстановкаСотрудники.Ссылка.ВидДоговора В (ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровССотрудниками.ВоеннослужащийПоПризыву), ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровССотрудниками.КонтрактВоеннослужащего))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать(); 
	
	Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл
		ДанныеДляРегистрацииПоДокументу = УчетСтажаПФР.ДанныеДляРегистрацииВУчетеСтажаПФР();
		ДанныеДляРегистрации.Вставить(Выборка.Ссылка, ДанныеДляРегистрацииПоДокументу);
		
		Пока Выборка.Следующий() Цикл
			ОписаниеПериода = УчетСтажаПФР.ОписаниеРегистрируемогоПериода();
			ОписаниеПериода.Сотрудник = Выборка.Сотрудник;	
			ОписаниеПериода.ДатаНачалаПериода = Выборка.Месяц;
			ОписаниеПериода.Состояние = Перечисления.СостоянияСотрудника.Работа;
			ОписаниеПериода.ВидЗанятости = Выборка.ВидЗанятости;

			РегистрируемыйПериод = УчетСтажаПФР.ДобавитьЗаписьВДанныеДляРегистрацииВУчета(ДанныеДляРегистрацииПоДокументу, ОписаниеПериода);
										
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Организация", Выборка.Организация);
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Подразделение", Выборка.Подразделение);
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ДолжностьПоШтатномуРасписанию", Выборка.ДолжностьПоШтатномуРасписанию);
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Должность", Выборка.Должность);
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "КоличествоСтавок", Выборка.КоличествоСтавок);
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ГрафикРаботы", Выборка.ГрафикРаботы);
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ВидСтажаПФР", Перечисления.ВидыСтажаПФР2014.ВключаетсяВСтажДляДосрочногоНазначенияПенсии);

		КонецЦикла;	
		
	КонецЦикла;	
	
	Возврат ДанныеДляРегистрации;
	
КонецФункции	

Процедура ПеренестиДвиженияКадровойИсторииНаДатуОтсчетаПериодическихСведений(ПараметрыОбновления = Неопределено) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ДатаНачала", ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений());
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	КадроваяИсторияСотрудников.Регистратор КАК Регистратор
		|ПОМЕСТИТЬ ВТРегистраторы
		|ИЗ
		|	РегистрСведений.КадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
		|		ПО КадроваяИсторияСотрудников.Сотрудник = ТекущиеКадровыеДанныеСотрудников.Сотрудник
		|			И (НАЧАЛОПЕРИОДА(КадроваяИсторияСотрудников.Период, ДЕНЬ) <> ТекущиеКадровыеДанныеСотрудников.ДатаПриема)
		|			И (КадроваяИсторияСотрудников.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.НачальныеДанные))
		|ГДЕ
		|	НАЧАЛОПЕРИОДА(КадроваяИсторияСотрудников.Период, ДЕНЬ) <> &ДатаНачала
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	Регистраторы.Регистратор КАК Регистратор
		|ИЗ
		|	ВТРегистраторы КАК Регистраторы";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ОбработкаЗавершена = Ложь;
		
		// Кадровая история
		Запрос.Текст =
			"ВЫБРАТЬ
			|	Регистраторы.Регистратор КАК Регистратор,
			|	ВЫБОР
			|		КОГДА ТекущиеКадровыеДанныеСотрудников.ДатаПриема = ДАТАВРЕМЯ(1, 1, 1)
			|			ТОГДА &ДатаНачала
			|		ИНАЧЕ ТекущиеКадровыеДанныеСотрудников.ДатаПриема
			|	КОНЕЦ КАК Период,
			|	КадроваяИсторияСотрудников.*
			|ПОМЕСТИТЬ ВТДанныеРегистратров
			|ИЗ
			|	ВТРегистраторы КАК Регистраторы
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
			|			ПО КадроваяИсторияСотрудников.Сотрудник = ТекущиеКадровыеДанныеСотрудников.Сотрудник
			|		ПО Регистраторы.Регистратор = КадроваяИсторияСотрудников.Регистратор
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ДанныеРегистратров.Сотрудник КАК Сотрудник
			|ПОМЕСТИТЬ ВТОтборДляПереформирования
			|ИЗ
			|	ВТДанныеРегистратров КАК ДанныеРегистратров
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ДанныеРегистратров.*
			|ИЗ
			|	ВТДанныеРегистратров КАК ДанныеРегистратров
			|
			|УПОРЯДОЧИТЬ ПО
			|	Регистратор";
			
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.СледующийПоЗначениюПоля("Регистратор") Цикл
			
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
				ПараметрыОбновления, "РегистрСведений.КадроваяИсторияСотрудников.НаборЗаписей", "Регистратор", Выборка.Регистратор) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			НаборЗаписей = РегистрыСведений.КадроваяИсторияСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			
			Пока Выборка.Следующий() Цикл
				
				НоваяСтрока = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка, , "Период, Регистратор");
				
				НоваяСтрока.Период = Выборка.Период;
				НоваяСтрока.Регистратор = Выборка.Регистратор;
				
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
		ПараметрыПостроения = ЗарплатаКадрыПериодическиеРегистры.ПараметрыПостроенияИнтервальногоРегистра();
		ПараметрыПостроения.ПараметрыРесурсов = ЗарплатаКадрыПериодическиеРегистры.ПараметрыНаследованияРесурсов("КадроваяИсторияСотрудников");
		
		ПараметрыПостроения.ОсновноеИзмерение = "Сотрудник";
		
		ПараметрыПостроения.Вставить("ПолноеПереформирование", Истина);
		ПараметрыПостроения.Вставить("РежимЗагрузки", Истина);
		
		ЗарплатаКадрыПериодическиеРегистры.СформироватьДвиженияИнтервальногоРегистра(
			"КадроваяИсторияСотрудников", Запрос.МенеджерВременныхТаблиц, ПараметрыПостроения, ПараметрыОбновления);
		
		// Виды занятости
		Запрос.Текст =
			"ВЫБРАТЬ
			|	Регистраторы.Регистратор КАК Регистратор,
			|	ВЫБОР
			|		КОГДА ТекущиеКадровыеДанныеСотрудников.ДатаПриема = ДАТАВРЕМЯ(1, 1, 1)
			|			ТОГДА &ДатаНачала
			|		ИНАЧЕ ТекущиеКадровыеДанныеСотрудников.ДатаПриема
			|	КОНЕЦ КАК Период,
			|	ВидыЗанятостиСотрудников.*
			|ПОМЕСТИТЬ ВТДанныеРегистратровВидыЗанятостиСотрудников
			|ИЗ
			|	ВТРегистраторы КАК Регистраторы
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВидыЗанятостиСотрудников КАК ВидыЗанятостиСотрудников
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
			|			ПО ВидыЗанятостиСотрудников.Сотрудник = ТекущиеКадровыеДанныеСотрудников.Сотрудник
			|		ПО Регистраторы.Регистратор = ВидыЗанятостиСотрудников.Регистратор
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ДанныеРегистратров.Сотрудник КАК Сотрудник
			|ПОМЕСТИТЬ ВТОтборДляПереформирования
			|ИЗ
			|	ВТДанныеРегистратровВидыЗанятостиСотрудников КАК ДанныеРегистратров
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ДанныеРегистратров.*
			|ИЗ
			|	ВТДанныеРегистратровВидыЗанятостиСотрудников КАК ДанныеРегистратров
			|
			|УПОРЯДОЧИТЬ ПО
			|	ДанныеРегистратров.Регистратор";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.СледующийПоЗначениюПоля("Регистратор") Цикл
			
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
				ПараметрыОбновления, "РегистрСведений.ВидыЗанятостиСотрудников.НаборЗаписей", "Регистратор", Выборка.Регистратор) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			НаборЗаписей = РегистрыСведений.ВидыЗанятостиСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			
			Пока Выборка.Следующий() Цикл
				
				НоваяСтрока = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка, , "Период, Регистратор");
				
				НоваяСтрока.Период = Выборка.Период;
				НоваяСтрока.Регистратор = Выборка.Регистратор;
				
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
		ПараметрыПостроения = ЗарплатаКадрыПериодическиеРегистры.ПараметрыПостроенияИнтервальногоРегистра();
		ПараметрыПостроения.ПараметрыРесурсов = ЗарплатаКадрыПериодическиеРегистры.ПараметрыНаследованияРесурсов("ВидыЗанятостиСотрудников");
		
		ПараметрыПостроения.ОсновноеИзмерение = "Сотрудник";
		
		ПараметрыПостроения.Вставить("ПолноеПереформирование", Истина);
		ПараметрыПостроения.Вставить("РежимЗагрузки", Истина);
		
		ЗарплатаКадрыПериодическиеРегистры.СформироватьДвиженияИнтервальногоРегистра(
			"ВидыЗанятостиСотрудников", Запрос.МенеджерВременныхТаблиц, ПараметрыПостроения, ПараметрыОбновления);
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", ОбработкаЗавершена);
	
КонецПроцедуры

Процедура ПеренестиДвиженияДанныхСостоянийСотрудниковНаДатуОтсчетаПериодическихСведений(ПараметрыОбновления = Неопределено) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДанныеСостоянийСотрудников.Регистратор КАК Регистратор
		|ПОМЕСТИТЬ ВТРегистраторы
		|ИЗ
		|	РегистрСведений.ДанныеСостоянийСотрудников КАК ДанныеСостоянийСотрудников
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
		|		ПО ДанныеСостоянийСотрудников.Сотрудник = ТекущиеКадровыеДанныеСотрудников.Сотрудник
		|			И (НАЧАЛОПЕРИОДА(ДанныеСостоянийСотрудников.Начало, ДЕНЬ) <> ТекущиеКадровыеДанныеСотрудников.ДатаПриема)
		|			И (ТИПЗНАЧЕНИЯ(ДанныеСостоянийСотрудников.Регистратор) = ТИП(Документ.НачальнаяШтатнаяРасстановка))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	Регистраторы.Регистратор КАК Регистратор
		|ИЗ
		|	ВТРегистраторы КАК Регистраторы";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ОбработкаЗавершена = Ложь;
		
		Запрос.УстановитьПараметр("ДатаНачала", ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений());
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	Регистраторы.Регистратор КАК Регистратор,
			|	ВЫБОР
			|		КОГДА ТекущиеКадровыеДанныеСотрудников.ДатаПриема = ДАТАВРЕМЯ(1, 1, 1)
			|			ТОГДА &ДатаНачала
			|		ИНАЧЕ ТекущиеКадровыеДанныеСотрудников.ДатаПриема
			|	КОНЕЦ КАК Начало,
			|	ДанныеСостоянийСотрудников.*
			|ПОМЕСТИТЬ ВТДанныеКОбновлению
			|ИЗ
			|	ВТРегистраторы КАК Регистраторы
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеСостоянийСотрудников КАК ДанныеСостоянийСотрудников
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
			|			ПО ДанныеСостоянийСотрудников.Сотрудник = ТекущиеКадровыеДанныеСотрудников.Сотрудник
			|		ПО Регистраторы.Регистратор = ДанныеСостоянийСотрудников.Регистратор
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ДанныеКОбновлению.Сотрудник КАК Сотрудник,
			|	ДанныеКОбновлению.Начало КАК Начало,
			|	ДанныеКОбновлению.Окончание КАК Окончание
			|ПОМЕСТИТЬ ВТКлючиИзменившихсяДанных
			|ИЗ
			|	ВТДанныеКОбновлению КАК ДанныеКОбновлению
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ДанныеКОбновлению.*
			|ИЗ
			|	ВТДанныеКОбновлению КАК ДанныеКОбновлению
			|
			|УПОРЯДОЧИТЬ ПО
			|	Регистратор";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.СледующийПоЗначениюПоля("Регистратор") Цикл
			
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
				ПараметрыОбновления, "РегистрСведений.ДанныеСостоянийСотрудников.НаборЗаписей", "Регистратор", Выборка.Регистратор) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			НаборЗаписей = РегистрыСведений.ДанныеСостоянийСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			
			Пока Выборка.Следующий() Цикл
				ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
		СостоянияСотрудников.ОбновитьСостоянияСотрудников(Запрос.МенеджерВременныхТаблиц, , Истина);
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", ОбработкаЗавершена);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли