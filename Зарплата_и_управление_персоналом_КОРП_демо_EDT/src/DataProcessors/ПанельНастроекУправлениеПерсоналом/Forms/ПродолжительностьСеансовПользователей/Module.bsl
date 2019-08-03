
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ГруппыДоступаБезОграниченияПродолжительностиСеанса.ГруппаДоступа
	               |ИЗ
	               |	РегистрСведений.ГруппыДоступаБезОграниченияПродолжительностиСеанса КАК ГруппыДоступаБезОграниченияПродолжительностиСеанса
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ПродолжительностьСеансаГруппДоступа.ГруппаДоступа,
	               |	ПродолжительностьСеансаГруппДоступа.ПродолжительностьСеанса
	               |ИЗ
	               |	РегистрСведений.ПродолжительностьСеансаГруппДоступа КАК ПродолжительностьСеансаГруппДоступа";
				   
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	Выборка = РезультатыЗапроса[0].Выбрать();
	Пока Выборка.Следующий() Цикл 
		ЗаполнитьЗначенияСвойств(ГруппыДоступаБезОграничений.Добавить(), Выборка);
	КонецЦикла;
				   
	Выборка = РезультатыЗапроса[1].Выбрать();
	Пока Выборка.Следующий() Цикл 
		ЗаполнитьЗначенияСвойств(ПродолжительностьСеансов.Добавить(), Выборка);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Отказ = Ложь;
	СохранитьДанныеНаСервере(Отказ);
	
	Если Не Отказ Тогда 
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СохранитьДанныеНаСервере(Отказ)
	
	ПроверитьЗаполнениеНаСервере(Отказ);
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ГруппыДоступаБезОграниченияПродолжительностиСеанса.СоздатьНаборЗаписей();
	Для Каждого СтрокаГруппыДоступа Из ГруппыДоступаБезОграничений Цикл 
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), СтрокаГруппыДоступа);
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
	НаборЗаписей = РегистрыСведений.ПродолжительностьСеансаГруппДоступа.СоздатьНаборЗаписей();
	Для Каждого СтрокаГруппыДоступа Из ПродолжительностьСеансов Цикл 
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), СтрокаГруппыДоступа);
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеНаСервере(Отказ)
	
	УникальныеГруппыДоступа = Новый Соответствие;
	
	Для Каждого СтрокаГруппыДоступа Из ГруппыДоступаБезОграничений Цикл 
		
		Отбор = Новый Структура("ГруппаДоступа", СтрокаГруппыДоступа.ГруппаДоступа);
		Если ПродолжительностьСеансов.НайтиСтроки(Отбор).Количество() <> 0 Тогда 
			ИндексСтроки = ГруппыДоступаБезОграничений.Индекс(СтрокаГруппыДоступа);
			ТекстСообщения = НСтр("ru = 'Группа доступа %1 присутствует в обоих списках.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрокаГруппыДоступа.ГруппаДоступа);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ГруппыДоступаБезОграничений[" + Формат(ИндексСтроки, "ЧН=0; ЧГ=0") + "].ГруппаДоступа", , Отказ);
		КонецЕсли;
		
		Если УникальныеГруппыДоступа[СтрокаГруппыДоступа.ГруппаДоступа] <> Неопределено Тогда 
			ИндексСтроки = ГруппыДоступаБезОграничений.Индекс(СтрокаГруппыДоступа);
			ТекстСообщения = НСтр("ru = 'Группа доступа %1 уже указана в списке ранее.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрокаГруппыДоступа.ГруппаДоступа);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ГруппыДоступаБезОграничений[" + Формат(ИндексСтроки, "ЧН=0; ЧГ=0") + "].ГруппаДоступа", , Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаГруппыДоступа.ГруппаДоступа) Тогда 
			ИндексСтроки = ГруппыДоступаБезОграничений.Индекс(СтрокаГруппыДоступа);
			ТекстСообщения = НСтр("ru = 'Не указана группа доступа.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ГруппыДоступаБезОграничений[" + Формат(ИндексСтроки, "ЧН=0; ЧГ=0") + "].ГруппаДоступа", , Отказ);
		КонецЕсли;
		
		УникальныеГруппыДоступа.Вставить(СтрокаГруппыДоступа.ГруппаДоступа, Истина);
		
	КонецЦикла;
	
	УникальныеГруппыДоступа = Новый Соответствие;
	
	Для Каждого СтрокаГруппыДоступа Из ПродолжительностьСеансов Цикл
		
		Если УникальныеГруппыДоступа[СтрокаГруппыДоступа.ГруппаДоступа] <> Неопределено Тогда 
			ИндексСтроки = ПродолжительностьСеансов.Индекс(СтрокаГруппыДоступа);
			ТекстСообщения = НСтр("ru = 'Группа доступа %1 уже указана в списке ранее.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрокаГруппыДоступа.ГруппаДоступа);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ПродолжительностьСеансов[" + Формат(ИндексСтроки, "ЧН=0; ЧГ=0") + "].ГруппаДоступа", , Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаГруппыДоступа.ГруппаДоступа) Тогда 
			ИндексСтроки = ПродолжительностьСеансов.Индекс(СтрокаГруппыДоступа);
			ТекстСообщения = НСтр("ru = 'Не указана группа доступа.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ПродолжительностьСеансов[" + Формат(ИндексСтроки, "ЧН=0; ЧГ=0") + "].ГруппаДоступа", , Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаГруппыДоступа.ПродолжительностьСеанса) Тогда 
			ИндексСтроки = ПродолжительностьСеансов.Индекс(СтрокаГруппыДоступа);
			ТекстСообщения = НСтр("ru = 'Не указана продолжительность сеанса.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ПродолжительностьСеансов[" + Формат(ИндексСтроки, "ЧН=0; ЧГ=0") + "].КоличествоСеансов", , Отказ);
		КонецЕсли;
		
		УникальныеГруппыДоступа.Вставить(СтрокаГруппыДоступа.ГруппаДоступа, Истина);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
