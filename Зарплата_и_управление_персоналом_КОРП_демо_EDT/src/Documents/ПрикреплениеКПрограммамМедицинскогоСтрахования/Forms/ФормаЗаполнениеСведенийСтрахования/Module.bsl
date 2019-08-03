
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("ОрганизацияСсылка") Тогда
		ВызватьИсключение НСтр("ru='Обработка не предназначена для непосредственного использования.'");
	КонецЕсли;
	
	Объект.Организация = Параметры.ОрганизацияСсылка;
	Заголовок = Строка(Параметры.ОрганизацияСсылка) + " (" + НСтр("ru = 'Заполнение сведений страхования'") + ")";
	
	ПрограммыСтрахования.ЗагрузитьЗначения(Параметры.ПрограммыСтрахования);
	РасширенияПрограммСтрахования.ЗагрузитьЗначения(Параметры.РасширенияПрограммСтрахования);
	ДатаНачалаСтрахования = Параметры.ДатаНачалаСтрахования;
	СуммаУдержания = Параметры.СуммаУдержания;
	УдерживатьССотрудника = СуммаУдержания <> 0;
	СуммаПредела = Параметры.СуммаПредела;
	ПрекратитьУдержания = СуммаПредела <> 0;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УдержатьПриПрикрепленииПриИзменении(Элемент)
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ПрекратитьУдержанияПриИзменении(Элемент)
	УстановитьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("ПрограммыСтрахования", ПрограммыСтрахования.ВыгрузитьЗначения());
	ПараметрыЗакрытия.Вставить("РасширенияПрограммСтрахования", РасширенияПрограммСтрахования.ВыгрузитьЗначения());
	ПараметрыЗакрытия.Вставить("ДатаНачалаСтрахования", ДатаНачалаСтрахования);
	ПараметрыЗакрытия.Вставить("СуммаУдержания", СуммаУдержания);
	ПараметрыЗакрытия.Вставить("СуммаПредела", СуммаПредела);
	ПараметрыЗакрытия.Вставить("СтраховаяПремия", СтраховаяПремия);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьДоступностьЭлементов()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СуммаУдержания", "Доступность", УдерживатьССотрудника);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СуммаПредела", "Доступность", ПрекратитьУдержания);
	
КонецПроцедуры

#КонецОбласти
