#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ВакансииКандидатов = Новый Массив;
	ОтменитьРешениеПоКандидатамНаСервере(ПараметрКоманды, ВакансииКандидатов);
	
	// Отражаем изменения в открытых формах.
	ФормаВладелец = ПараметрыВыполненияКоманды.Источник;
	Если ФормаВладелец.Параметры.Свойство("Ключ") Тогда
		ФормаВладелец.Прочитать();
	КонецЕсли;
	ОповеститьОбИзменении(ТипЗнч("СправочникСсылка.Кандидаты"));
	
	ПараметрыОповещения = Новый Структура("Кандидаты, Вакансии");
	ПараметрыОповещения.Кандидаты = ПараметрКоманды;
	ПараметрыОповещения.Вакансии = ВакансииКандидатов;
	
	Оповестить("ОтменаРешенияПоКандидату", ПараметрыОповещения, ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтменитьРешениеПоКандидатамНаСервере(Кандидаты, ВакансииКандидатов)
	
	Для Каждого Кандидат Из Кандидаты Цикл
		Справочники.Кандидаты.УстановитьРешениеПоКандидату(Кандидат, Перечисления.СостоянияСогласования.ПустаяСсылка());
	КонецЦикла;
	
	ПодборПерсонала.ЗаполнитьВакансииКандидатов(Кандидаты, ВакансииКандидатов);
	
КонецПроцедуры

#КонецОбласти