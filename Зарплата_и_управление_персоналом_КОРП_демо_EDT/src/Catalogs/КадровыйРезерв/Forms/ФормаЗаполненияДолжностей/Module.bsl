
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьДанныеФормы(Параметры);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура ОК(Команда)
	
	Если Модифицированность Тогда
		СтруктураПараметраОповещения = Новый Структура;
		СтруктураПараметраОповещения.Вставить("Должности", АдресДолжностей());
		Оповестить("ИзмененыДолжности", СтруктураПараметраОповещения, ВладелецФормы);
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДанныеФормы(Параметры)

	Если НЕ Параметры.Свойство("ТаблицаДолжностей") Тогда
		Возврат;
	КонецЕсли;
	
	Должности.Загрузить(ПолучитьИзВременногоХранилища(Параметры.ТаблицаДолжностей));

КонецПроцедуры

&НаСервере
Функция АдресДолжностей()
	Возврат ПоместитьВоВременноеХранилище(Должности.Выгрузить(), Новый УникальныйИдентификатор);
КонецФункции

#КонецОбласти