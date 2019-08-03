

#Область ОбработчикиСобытийФормы

// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;		
	
	// Заполняем переменные
	
	Тест            = Параметры.Тест;
	Страница        = Параметры.Страница;
	ЭлектронныйКурс = Параметры.ЭлектронныйКурс;

	РазработкаЭлектронныхКурсовСлужебный.УстановитьРодителяНовогоОбъекта(Объект, Параметры, "СправочникСсылка.ТестовыеВопросы");
	
	РазработкаЭлектронныхКурсовСлужебный.УстановитьПредпочитаемогоПоставщика(Объект);
	
	Вес = 1;
	
	Если ЗначениеЗаполнено(Параметры.Страница) Тогда
		Вес = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Страница, "ВесВопроса");
	КонецЕсли;
	
	МассивТиповВопросов = Новый Массив();
	МассивТиповВопросов.Добавить(Перечисления.ТипыТестовыхВопросов.ПоШаблону);
	МассивТиповВопросов.Добавить(Перечисления.ТипыТестовыхВопросов.Таблица);
	МассивТиповВопросов.Добавить(Перечисления.ТипыТестовыхВопросов.Соответствие);
	МассивТиповВопросов.Добавить(Перечисления.ТипыТестовыхВопросов.Открытый);
	МассивТиповВопросов.Добавить(Перечисления.ТипыТестовыхВопросов.ЭлементActiveX);
	МассивТиповВопросов.Добавить(Перечисления.ТипыТестовыхВопросов.РаботаВПрограмме);
	
	МассивПараметровВыбора = Новый Массив();
	
	МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("ИсключитьЗначения", Новый ФиксированныйМассив(МассивТиповВопросов)));
	Элементы.ТипВопроса.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ЗагрузитьВерсиюНаСервере(ТекущийОбъект);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
			
	ТекущийОбъект.Наименование = ЭлектронноеОбучениеСлужебный.НаименованиеЭлементаИзТекста(Задание);
	ТекущийОбъект.Задание      = Новый ХранилищеЗначения(Задание);

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)	
	
	// Делаем проверки
	
	Если (Объект.ТипВопроса = Перечисления.ТипыТестовыхВопросов.ОдинИзМногих
		ИЛИ Объект.ТипВопроса = Перечисления.ТипыТестовыхВопросов.МногиеИзМногих
		ИЛИ Объект.ТипВопроса = Перечисления.ТипыТестовыхВопросов.Таблица
		ИЛИ Объект.ТипВопроса = Перечисления.ТипыТестовыхВопросов.Последовательность
		ИЛИ Объект.ТипВопроса = Перечисления.ТипыТестовыхВопросов.Соответствие
		ИЛИ Объект.ТипВопроса = Перечисления.ТипыТестовыхВопросов.ПоШаблону)		
		И ВариантыОтветов.Количество() = 0 Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Добавьте варианты ответов'"),,,"ВариантыОтветов",Отказ);				
		Возврат;
		
	КонецЕсли; 
	
	Если Объект.ТипВопроса = Перечисления.ТипыТестовыхВопросов.ОдинИзМногих
		ИЛИ Объект.ТипВопроса = Перечисления.ТипыТестовыхВопросов.МногиеИзМногих Тогда
		
		КоличествоВерныхВариантов = ВариантыОтветов.НайтиСтроки(Новый Структура("Верный", Истина)).Количество();
		
		Если КоличествоВерныхВариантов = 0 Тогда			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Укажите хотя бы один верный вариант ответа'"),,,,Отказ);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	НомерВарианта = 1;
	Для каждого Строка Из ВариантыОтветов Цикл
		
		Если НЕ ЗначениеЗаполнено(Строка.Текст) Тогда			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Укажите текст варианта ответа'"),,ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВариантыОтветов", НомерВарианта, "Текст"),,Отказ);
			Возврат;
		КонецЕсли;
		
		НомерВарианта = НомерВарианта + 1;
		
	КонецЦикла;		
		
	// Записываем варианты ответа
	
	НомерВарианта = 1;
	
	Для каждого Строка Из ВариантыОтветов Цикл		
		
		Если НЕ ЗначениеЗаполнено(Строка.Ссылка) Тогда
			
			ВариантОбъект = Справочники.ВариантыОтветовНаТестовыеВопросы.СоздатьЭлемент();			
			ВариантОбъект.Владелец = ТекущийОбъект.Ссылка;
			
			РазработкаЭлектронныхКурсовСлужебный.УстановитьПредпочитаемогоПоставщика(ВариантОбъект);
			
			Строка.Ссылка = ВариантОбъект.Ссылка;
			
		Иначе
			
			ВариантОбъект = Строка.Ссылка.ПолучитьОбъект();
			
		КонецЕсли;
		
		ВариантОбъект.Код = НомерВарианта;
		ВариантОбъект.Наименование = Строка.Текст;		
		ВариантОбъект.ТекстВарианта = Новый ХранилищеЗначения(Строка.Текст);
		ВариантОбъект.Верный = Строка.Верный;
		
		ВариантОбъект.Записать();
		
		НомерВарианта = НомерВарианта + 1;
		
	КонецЦикла;	
	
	Если ЗначениеЗаполнено(Страница) Тогда
		Справочники.СтраницыЭлементовЭлектронныхКурсов.Перезаписать(Страница, Вес);	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ЭлементКурсаЗаписан", Объект.Ссылка, ЭтотОбъект);
	
	Если ЗначениеЗаполнено(Тест) Тогда
		Оповестить("ПодборкаОбновлена", Тест, ЭтотОбъект);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ТипВопросаПриИзменении(Элемент)
	УстановитьДоступностьЭлементовФормы(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВариантыОтветов

// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ВариантыОтветов

&НаКлиенте
Процедура ВариантыОтветовПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда	
		УдалитьВариантОтветаНаСервере(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантыОтветовВерныйПриИзменении(Элемент)
	
	Если Объект.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыТестовыхВопросов.ОдинИзМногих") Тогда
		
		КоличествоВерныхВариантов = ВариантыОтветов.НайтиСтроки(Новый Структура("Верный", Истина)).Количество();
		
		Если КоличествоВерныхВариантов > 1 Тогда
			Объект.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыТестовыхВопросов.МногиеИзМногих");
		КонецЕсли;
		
	КонецЕсли;		
	
КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УдалитьВариантОтветаНаСервере(ВариантОтвета)
	
	ВариантОтветаОбъект = ВариантОтвета.ПолучитьОбъект();
	ВариантОтветаОбъект.УстановитьПометкуУдаления(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьВерсиюНаСервере(ТекущийОбъект)
	
	Если НЕ ТекущийОбъект.Ссылка.Пустая() Тогда 
		
		// Загружаем текст вопроса (задание)
		
		Задание = ТекущийОбъект.Задание.Получить();		
		
		// Загружаем таблицу с данными вариантов ответов
		
		ВариантыОтветов.Очистить();
		
		Запрос = Новый Запрос();
		Запрос.Текст = "ВЫБРАТЬ
		               |	ВариантыОтветов.Ссылка КАК Ссылка,
		               |	ВариантыОтветов.Верный КАК Верный,
		               |	ВариантыОтветов.ТекстВарианта КАК ТекстВарианта
		               |ИЗ
		               |	Справочник.ВариантыОтветовНаТестовыеВопросы КАК ВариантыОтветов
		               |ГДЕ
		               |	ВариантыОтветов.Владелец = &Владелец
		               |	И ВариантыОтветов.ПометкаУдаления = ЛОЖЬ
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	ВариантыОтветов.Код";		
		
		Запрос.УстановитьПараметр("Владелец", ТекущийОбъект.Ссылка); 
		
		ВыборкаВариантыОтветов = Запрос.Выполнить().Выбрать();
		
		Пока ВыборкаВариантыОтветов.Следующий() Цикл
			
			НоваяСтрока = ВариантыОтветов.Добавить();
			НоваяСтрока.Ссылка = ВыборкаВариантыОтветов.Ссылка;
			НоваяСтрока.Текст = ВыборкаВариантыОтветов.ТекстВарианта.Получить();
			НоваяСтрока.Верный = ВыборкаВариантыОтветов.Верный;
			
		КонецЦикла;
		
	КонецЕсли;
	
	УстановитьДоступностьЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовФормы(Форма)
	
	// Поле Верный вариантов ответов
	
	Если Форма.Объект.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыТестовыхВопросов.Последовательность")
		ИЛИ Форма.Объект.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыТестовыхВопросов.Соответствие")
		ИЛИ Форма.Объект.ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыТестовыхВопросов.Таблица") Тогда
		
		Форма.Элементы.ВариантыОтветовВерный.Видимость = Ложь;
		
	Иначе
		
		Форма.Элементы.ВариантыОтветовВерный.Видимость = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти